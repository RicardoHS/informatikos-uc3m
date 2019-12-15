library(tidyverse)
library(rtweet)

#tweets <- get_timeline(user="rosaliavt",n=3200)
#retweet_data <- vector(mode = "list", length = 200)
#for(i in 0:200){
#  if(i %% 74 == 0) Sys.sleep(905)
#  retweet_data[[i]] <- get_retweets(tweets[i,]$status_id)
#}

tweets <- readRDS("data/tweets-elmundo.rds")
retweet_data <- readRDS("data/retweet_data.rds")

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
indexes <- sample(c(1:200), 20)
rts <- as.data.frame(cbind(c(1:n_retweets[i]), retweet_difference[[i]], cumsum_retweet_times[[i]]))
colnames(rts) <- c("Count", "Min", "TotalTime")
plot(rts$TotalTime, rts$Count, type = "l", xlim = c(0, 1000), ylim = c(0,95))
for (i in indexes[-1]){
  if(n_retweets[i] > 0) {
    rts <- as.data.frame(cbind(c(1:n_retweets[i]), retweet_difference[[i]], cumsum_retweet_times[[i]]))
    colnames(rts) <- c("Count", "Min", "TotalTime")
    lines(rts$TotalTime, rts$Count)
  }
}


## All Plots
lines = matrix(0, length(cumsum_retweet_times), maximum_RT)
for(row in 1:length(cumsum_retweet_times)){
  lines[row,] = c(cumsum_retweet_times[[row]], rep(0,maximum_RT-length(cumsum_retweet_times[[row]])))
}
# each line is the time between retweets of a tweet. Plotted every tweet
matplot(t(lines), type = "l") # maybe less lines per plot is better



lambda <- function(t) theta*exp(-theta*t)

theta = 0.0045
n <- 1200
points = numeric(n)
for (t in c(1:n)){
  points[t] <- integrate(lambda, 0, t)$value
}

points <- data.frame(ExpectedCount=points, TotalTime=c(1:n))
ggplot(points) + geom_line() + aes(x=TotalTime, y=ExpectedCount)


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
times <- simulateNHPP(lambda, 1000, 0.7)
hist(times)
