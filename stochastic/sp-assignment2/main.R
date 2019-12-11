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
