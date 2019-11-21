library(tidyverse)
load("data/CustomerJourney_Group_2.RData")

# Question 2 ----
# See the state space of our dataset
(state_space <- (unique(flatten_chr(CJ))))
states <- 1:length(state_space)
# Encodes our states as numbers from 1 to 5.
lookup <- c("Ch 1" = 1, "Ch 2" = 2, "Ch 3" = 3, "Conversion" = 4, "Non-conversion" = 5)
numeric_cj <- map(CJ, ~unname(lookup[.x]))

# Counts the transitions from the state argument to all states in S for each realization
# of the markov chain.
count_transition <- function(list, state){
  count <- rep(0, 5)
  for(i in 1:(length(list)-1)){
    if(list[[i]] == state)
      count[list[[i+1]]] <- count[list[[i+1]]]+1
  }
  count
}

# Number of transitions from state i to any other state.
total_transitions <- map_dbl(states, ~sum(sapply(numeric_cj, count_transition, .)))

# Calculate transition matrix P
P <- diag(5)
for(origin in 1:3){ 
  origin_trans <- lapply(numeric_cj, count_transition, origin)
  for(destination in states){
    P[origin, destination] <- sum(map_dbl(origin_trans, destination))/total_transitions[origin]
  }
}
