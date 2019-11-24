library(tidyverse)

# First column is just a pandas index.
poke <- read_csv2("data/pokemon.csv")[,-1]
