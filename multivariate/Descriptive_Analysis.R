library(plotly)
library(tidyverse)
library(MASS)
library("pracma")
library(corrplot)
library("GGally")


data <- read.csv("pokemon.csv")


encode_labels <- function() {
  # Pokemon Types
  types_ <- unique(as.character(data$poke1_Type.1))
  types <- unique(as.character(data$poke1_Type.2)) # Type None
  
  encoded_types <- as.numeric(as.factor(types))
  variables <- c("poke1_Type.1", "poke1_Type.2", "poke2_Type.1", "poke2_Type.2")
  
  for (variable in variables){
    data[[variable]] <- as.character(data[[variable]])
    for (i in 1:length(types)){
      index <- which(data[[variable]] == types[i])
      data[[variable]][index] <- encoded_types[i]
    }
    data[[variable]] <- as.numeric(data[[variable]])
    
  }
  
  # Legendaries
  data$poke1_Legendary <- ifelse(data$poke1_Legendary == "True",1, 0)
  data$poke2_Legendary <- ifelse(data$poke2_Legendary == "True",1, 0)
  
  data[, -c(1,2,13)]
}


data <- encode_labels()


# Legendaries do not seem to be Outliers
legendaries <- data[data$poke1_Legendary == 1 | data$poke2_Legendary == 1,]

# Reduce Data for plots
pokemon_sample <- sample_n(data, 1000)

#Legendary Colour Red
legend_colours <- character(nrow(pokemon_sample))
legend_colours[] <- "deepskyblue2"
legend_colours[pokemon_sample$poke1_Legendary == 1] <- "red"

pairs(pokemon_sample[c(3:8, 13:18)], col=legend_colours)
parcoord(pokemon_sample, col=legend_colours,var.label=TRUE)

andrewsplot(as.matrix(pokemon_sample),as.factor(pokemon_sample$poke1_Legendary),style="cart")

cor <- cor(pokemon_sample)
corrplot(cor, method="circle")

ggpairs(pokemon_sample, aes(colour = as.factor(poke1_Legendary)))

