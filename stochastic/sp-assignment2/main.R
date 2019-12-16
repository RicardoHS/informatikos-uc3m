library(tidyverse)
library(rtweet)

#tweets <- get_timeline(user="realmadrid",n=3200)
#retweet_data <- vector(mode = "list", length = 200)
#for(i in 30:230){
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
colnames(rts) <- c("Count", "Min", "TotalTime")
ggplot(rts) + geom_line() + aes(x=TotalTime, y=Count)


# Pot Sample Tweets
rts <- as.data.frame(cbind(c(1:maximum_RT), retweet_difference[[index]], cumsum_retweet_times[[index]]))
colnames(rts) <- c("Count", "Min", "TotalTime")
plot(rts$TotalTime, rts$Count, type = "l", xlim = c(0, 5000), ylim = c(0,95))
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
    interpolated_tweets[row,] = approx(1:length(cumsum_retweet_times[[row]]), cumsum_retweet_times[[row]], n=96)$y
  }
}
interpolated_tweets = as.data.frame(interpolated_tweets)
interpolated_tweets = interpolated_tweets[apply(interpolated_tweets[,-1], 1, function(x) !all(x==0)),]
matplot(t(interpolated_tweets), type = 'l')
mean_tweet = colSums(interpolated_tweets)/dim(interpolated_tweets)[1]
mean_tweet_df = data.frame(TotalTime=mean_tweet, Count=1:96)

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
ggplot(points) + geom_line() + aes(x=TotalTime, y=ExpectedCount, color='Expected') + geom_line(data = foo_rts, aes(x=TotalTime-foo_rts_min, y=Count, color='Real'))

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
ggplot(points) + geom_line() + aes(x=TotalTime, y=ExpectedCount, color='Expected') + geom_line(data = foo_rts, aes(x=TotalTime-foo_rts_min, y=Count, color='Real'))
############################################## END OPT


simulateNHPP <- function(intensity_function, time, lambda_bound) {
  X <- numeric(0)

  while( length(X) <= time){
    u <- runif(2)
    accept <- u[2] <= intensity_function(time*u[1]) / lambda_bound
    if (accept)
      X <- c(X, time * u[1])
  }

  return(sort(X))
}
times <- simulateNHPP(lambda, 10000, 0.7)
hist(times)
