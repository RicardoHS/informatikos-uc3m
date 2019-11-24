library(tidyverse)

# First column is just a pandas index.
poke <- read_csv2("data/pokemon.csv")[,-1]

poke_long <- poke %>%
  select(-target, -contains("Type")) %>%
  pivot_longer(cols = everything(),
               names_to = c("Pokemon", "statistic"),
               values_to = "value",
               names_pattern = "poke(.)_(.*)")

poke_long %>%
  filter(!(statistic %in% c("Legendary", "Generation"))) %>%
  ggplot()+
  geom_boxplot(aes(x = statistic, y = value))+
  coord_flip()

