library(tidyverse)

data <- read_csv(("data/cleaned_data.csv"))

# get the top 5 species other than cats and dogs
species <- data |>
  group_by(speciesname) |>
  summarise(
    n = n()
  ) |>
  arrange(
    n
  ) |>
  filter(
    !is.na(speciesname)
  )

species$speciesname <- factor(species$speciesname, levels = species$speciesname)

plot <- ggplot(species, aes(speciesname, n)) +
  geom_bar(stat = "identity") +
  labs(title = "Animal Species", x = "Species", y = "Count")+
  coord_flip()

ggsave("figures/intake_species.png", plot, width=20, height=15, units='cm')

