library(tidyverse)
library(rtweet)

# Data downloading
# tweets <- get_timeline(user="elmundoes",n=3200)
# retweet_data <- map(tweets$status_id, get_retweets)
# retweet_data <- vector(mode = "list", length = 200)
# for(i in 1:200){
#   if(i %% 74 == 0) Sys.sleep(905)
#   retweet_data[[i]] <- get_retweets(tweets[i,]$status_id)
# }

tweets <- readRDS("data/tweets-elmundo.rds")
retweet_data <- readRDS("data/retweet_data.rds")

retweet_times <- map(retweet_data, "created_at")
n_retweets <- map_dbl(retweet_times, length)


# Descriptive Analysis
which(n_retweets==max(n_retweets))

times <- numeric(length(retweet_times[[54]]))
times[1] <- difftime(retweet_times[[54]][1], tweets[54,]$created_at, units = "secs")[[1]]

for (i in 1:(length(retweet_times[[54]]) - 1)){
  times[i+1] <- difftime(retweet_times[[54]][i], retweet_times[[54]][i+1], units = "secs")[[1]]
}

rts <- as.data.frame(cbind(c(1:length(retweet_times[[54]])), times, cumsum(times)))
colnames(rts) <- c("Count", "ms", "TotalTime")


ggplot(rts) + geom_line() + aes(x=TotalTime, y=Count)



## all plots
sort_retweet_times = lapply(retweet_times, sort)
sort_cumsum_retweet_times = lapply(sort_retweet_times, diff) %>% lapply(as.numeric, units='secs') %>% lapply(cumsum)
max_list_length = max(unlist(lapply(sort_cumsum_retweet_times, length)))
lines = matrix(0, length(sort_cumsum_retweet_times), max_list_length)
for(row in 1:length(sort_cumsum_retweet_times)){
  lines[row,] = c(unlist(sort_cumsum_retweet_times[row]), rep(0,max_list_length-length(unlist(sort_cumsum_retweet_times[row]))))
}
# each line is the time between retweets of a tweet. Plotted every tweet
matplot(t(lines), type = "l") # maybe less lines per plot is better



lambda <- function(t) theta*exp(theta*t)

theta = 0.005
n <- 1000
points = numeric(n)
for (t in c(1:n)){
  points[t] <- integrate(lambda, 0, t)$value
}

points <- data.frame(ExpectedCount=points, TotalTime=c(1:n))
ggplot(points) + geom_line() + aes(x=TotalTime, y=ExpectedCount)
