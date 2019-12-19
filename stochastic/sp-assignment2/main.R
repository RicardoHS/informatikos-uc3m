library(tidyverse)
library(rtweet)
library(tikzDevice)

#tweets <- get_timeline(user="realmadrid",n=3200)
#retweet_data <- vector(mode = "list", length = 200)
#for(i in 1:200){
#  if(i %% 74 == 0) Sys.sleep(905)
#  retweet_data[[i]] <- get_retweets(tweets[i,]$status_id)
#}
#saveRDS(tweets, "data/tweets-rm")
#saveRDS(retweet_data, "data/retweet-rm")


tweets <- readRDS("data/tweets-rm")
retweet_data <- readRDS("data/retweet-rm")

retweet_times <- map(retweet_data, "created_at")
n_retweets <- map_dbl(retweet_times, length)


# Descriptive Analysis

retweet_times = lapply(retweet_times, sort)
retweet_difference <- lapply(retweet_times, diff) %>% lapply(as.numeric, units='mins')
for (i in 1:length(retweet_times)){
  if (n_retweets[i] > 0) {
    first_rt <- difftime(retweet_times[[i]][1], tweets[i,]$created_at, units = "mins")[[1]]
    retweet_difference[[i]] <- append(retweet_difference[[i]], first_rt, 0)
  }
}
cumsum_retweet_times =  retweet_difference %>% lapply(cumsum)


# Plot for Max RT
maximum_RT <- max(n_retweets)
index <- which(n_retweets == maximum_RT)

rts <- as.data.frame(cbind(c(1:n_retweets[index]), retweet_difference[[index]], cumsum_retweet_times[[index]]))
colnames(rts) <- c("Retweets", "Min", "Time")
# tikz('reportBueno/Figures/maxRTcurve.tex',width=2.5, height=2.5)
ggplot(rts) + geom_line() + aes(x=Time, y=Retweets)


# Pot Sample Tweets
rts <- as.data.frame(cbind(c(1:maximum_RT), retweet_difference[[index]], cumsum_retweet_times[[index]]))
colnames(rts) <- c("Count", "Min", "TotalTime")
plot(rts$TotalTime, rts$Count, type = "l", xlim = c(0, 5000), ylim = c(0,95), xlab='Time', ylab='Retweets')
for (i in c(1:200)){
  if(n_retweets[i] > 0) {
    rts <- as.data.frame(cbind(c(1:n_retweets[i]), retweet_difference[[i]], cumsum_retweet_times[[i]]))
    colnames(rts) <- c("Count", "Min", "TotalTime")
    lines(rts$TotalTime, rts$Count)
  }
}

######################### Compute mean rt times

interpolated_tweets = matrix(0, length(retweet_times), length(retweet_times[[index]]))
for(row in 1:length(retweet_times)){
  if(!is_empty(cumsum_retweet_times[[row]])){
    interpolated_tweets[row,] = approx(1:length(cumsum_retweet_times[[row]]), cumsum_retweet_times[[row]], n=maximum_RT)$y
  }
}
interpolated_tweets = as.data.frame(interpolated_tweets)
interpolated_tweets = interpolated_tweets[apply(interpolated_tweets[,-1], 1, function(x) !all(x==0)),]
matplot(t(interpolated_tweets), type = 'l')
mean_tweet = colSums(interpolated_tweets)/dim(interpolated_tweets)[1]
mean_tweet_df = data.frame(TotalTime=mean_tweet, Count=1:maximum_RT)

#########################

scale_01 = function(x){(x-min(x))/(max(x)-min(x))}
foo_rts = mean_tweet_df
foo_rts$Count = scale_01(foo_rts$Count)
foo_rts_min = min(foo_rts$TotalTime)
foo_rts_max = max(foo_rts$TotalTime) %>% round()
lambda <- function(t) theta*exp(-theta*t)
theta = 0.00099
n <- foo_rts_max-foo_rts_min
points = numeric(n)
for (t in c(1:n)){
  points[t] <- integrate(lambda, 0, t)$value
}

points <- data.frame(ExpectedCount=points, TotalTime=c(1:n))

ggplot(points) + geom_line() + aes(x=TotalTime, y=ExpectedCount, color='Simulated') + geom_line(data = foo_rts, aes(x=TotalTime-foo_rts_min, y=Count, color='Mean'))

############################################################### OPT
#### get minima theta, minimize area between lines
opt_func = function(theta, n, fun_bX, fun_bY) {
  lambda <- function(t) theta*exp(-theta*t)
  # simulate with theta
  points = numeric(n)
  for (t in c(1:n)){
    points[t] <- integrate(lambda, 0, t)$value
  }

  #calculate area between lines
  #fun_aY = points
  #fun_bX = foo_rts$TotalTime-foo_rts_min
  #fun_bY = foo_rts$Count
  line_a = points # fun_a
  line_b = approx(fun_bX, fun_bY, n=length(line_a))$y
  line_max = pmax(line_a, line_b)
  line_min = pmin(line_a, line_b)
  # value to minimize
  loss = sum(line_max-line_min)

  return(loss)

}
o = optimize(opt_func, foo_rts_max-foo_rts_min, foo_rts$TotalTime-foo_rts_min, foo_rts$Count, interval=c(0.0005, 0.005))
print(o$minimum)

theta = o$minimum
n <- foo_rts_max-foo_rts_min
points = numeric(n)
for (t in c(1:n)){
  points[t] <- integrate(lambda, 0, t)$value
}

points <- data.frame(ExpectedCount=points, TotalTime=c(1:n))

ggplot(points) + geom_line() + aes(x=TotalTime, y=ExpectedCount, color='Simulated') + geom_line(data = foo_rts, aes(x=TotalTime-foo_rts_min, y=Count, color='Mean'))
############################################## END OPT


simulateNHPP <- function(intensity_function, time, lambda_bound) {
  X <- numeric(0)

  for ( t in 1:time){
    u <- runif(2)
    accept <- u[2] <= intensity_function(time*u[1]) / lambda_bound
    if (accept)
      X <- c(X, time * u[1])
  }

  return(sort(X))
}

times <- simulateNHPP(lambda, 10000, 0.01)
hist(times)


# Exercise 2d ----
simulate_2d <- function(lambda, mu, k){
  # Simulation of the arrivals as a Poisson Process
  inter_arrivals <- rexp(k, rate = lambda)
  sn <- cumsum(inter_arrivals)

  # Obtain times of people leaving.
  exit_times <- numeric(k)
  exit_times[1] <- sn[1] + rexp(1, rate = mu)
  exit_times[2] <- sn[2] + rexp(1, rate = mu)
  for(i in 3:length(exit_times)){
    if(sn[i] > min(exit_times[(i-2):(i-1)])){
      # If there are free cashiers, he is serviced as he arrives.
      exit_times[i] <- sn[i] + rexp(1, rate = mu)
    }else{
      # Otherwise, he is serviced as soon as a cashier is free
      exit_times[i] <- min(exit_times[(i-2):(i-1)]) + rexp(1, rate = mu)
    }
  }
  list(
    xt = function(t) sum(sn < t) - sum(exit_times < t),
    exit_times = exit_times,
    sn = sn
  )
}
k <- 300
simulation <- simulate_2d(2/5, 1/4, k)

# Plot trajectory
range <- seq(0, k, by = .01)
plot(range, sapply(range, simulation$xt), type = "l")

# Probability of overtaking:
p_overtakes <- numeric(1000)
for(i in 1:1000){
  simul <- simulate_2d(2/5, 1/4, 300)
  # Calculate overtake probabilities
  overtakes <- 0
  for(j in 2:length(simul$exit_times)){
    if(any(simul$exit_times[j] < simul$exit_times[1:(j-1)])){
      overtakes <- overtakes + 1
    }
  }
  p_overtakes[i] <- overtakes/length(simul$exit_times)
}
mean(p_overtakes)

# Long run average of customers in the system
averages <- numeric(1000)
for(i in 1:1000){
  simul <- simulate_2d(2/5, 1/4, 300)
  averages[i] <- mean(sapply(1:k, simul$xt))
}
mean(averages)

# Long Run average of customers in the system (alternative)
ncust <- seq(3, 2000, by = 5)
averages <- numeric(length(ncust))
for(i in 1:length(ncust)){
  simul <- simulate_2d(2/5, 1/4, ncust[i])
  range <- seq(0, ncust[i], by = .1)
  averages[i] <- mean(sapply(range, simul$xt))
}
mean(averages)
a <- tibble(ncust = ncust, meanxt = averages)
# tikz('report/figures/longrunavg.tex',width=2.5, height=2.5)
ggplot(a, aes(ncust, meanxt)) +
  geom_jitter()+
  theme_bw()+
  # geom_hline(yintercept = mean(a$meanxt), color = "red")+
  labs(x= "Total Number of Customers", y = "Mean of Xt")
# dev.off()

lambda <- 2/5
mu <- 1/4
# Calculate stationary distribution
calculate_pi0 <- function(lambda, mu){
  result <- 1 + lambda/mu + ((lambda/mu)^2)/2 * 1/(1 - (lambda/2*mu))
  1/result
}
pi0 <- calculate_pi0(lambda, mu)
pi <- numeric(1000)
for(k in 1:length(pi)){
  pi[k] <- pi0*(lambda/mu)^k * 1/(2^(k-1))
}

L <- 0
for(i in 1:length(pi)){
  L <- L + i*pi[i]
}

length(times)

rts <- data.frame("Retweets"=c(1:length(times)), "Time"=times)

#tikz('reportBueno/Figures/simulated3.tex',width=2.5, height=2.5)
ggplot(rts) + geom_line() + aes(x=Time, y=Retweets)

# Expected in 24h
integrate(lambda, 0, 1440)$value / 0.01
# P more than 10 RT first hour
1-ppois(10,integrate(lambda, 0, 60)$value/ 0.01)
