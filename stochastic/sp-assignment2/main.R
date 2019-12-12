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
