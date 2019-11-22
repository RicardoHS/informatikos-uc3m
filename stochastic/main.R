library(tidyverse)
load("data/CustomerJourney_Group_2.RData")

# Question b ----
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

# Question c ----
# We are asked for P(X3 = 4 | X2 = 2, X1 = 3) = P(X3 = 4 |X2=2) * P(X2 = 2 | X1 =3) * P(X1 = 3) = 
# = P_{2,4} * P_{3,2} * (alpha*P)_{5}
# Assuming alpha = c(1/3, 1/3, 1/3, 0, 0), the answer is:
alpha <- c(rep(1/3, 3),0,0)
P[2,4] * P[3,2] * (alpha %*% P)[3]

# Question d ----
# We obtain the limiting distribution like in Dobrow 3.11
Q <- P[1:3,1:3]
R <- P[1:3,4:5]
# Lim P-> infty = (I-Q)^-1 * R
limit <- solve(diag(nrow(Q))-Q) %*% R
# The proportion of visits ending in a conversion (4) is:
(conversion_rate <- sum(limit[,1])/sum(limit))
# This is not the same as the limiting distribution for the conversion state. First of all, the 
# conversion proportion is a number and the limiting distribution is a vector that tells us for each
# starting state what proportion ends in conversion.
# 
# Question e ----
removal_effect_a <- function(P, state, conversion_rate){
  Pa <- P[-state, -state]
  for(i in 1:nrow(Pa)){
    Pa[i,] <- Pa[i,]/rowSums(Pa)[i]
  }
  Qa <- Pa[1:2, 1:2]
  Ra <- Pa[1:2, 3:4]
  limit_a <- solve(diag(nrow(Qa)) - Qa) %*% Ra
  
  1 - sum(limit_a[,1]/sum(limit_a))/conversion_rate
}

removal_effect_b <- function(P, state, conversion_rate){
  # Convertimos al estado iminar en un estado "inutil"
  Pb <- P
  Pb[state, ] <- 0
  Pb[state, 5] <- 1
  
  # Calculamos el removal effect
  Qb <- Pb[1:3, 1:3]
  Rb <- Pb[1:3, 4:5]
  limit <- solve(diag(nrow(Qb)) - Qb) %*% Rb
  
  1 - sum(limit[,1]/sum(limit))/conversion_rate
}
