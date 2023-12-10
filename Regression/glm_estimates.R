library(tidyverse)

data <- read_csv(("data/glm_estimate.csv"))

reason <- data |>
  filter(grepl("intake", coefficients)) |>
  arrange(estimates) |>
  mutate(
    coefficients = substr(coefficients, nchar("intakereason_new") + 1, nchar(coefficients))
  )

reason$coefficients <- factor(reason$coefficients, levels = reason$coefficients)

plot <- ggplot(reason, aes(coefficients, estimates)) +
  geom_bar(stat = "identity") +
  labs(x = "Intake Reasons", y = "Coefficient Estimates") +
  coord_flip()

ggsave("figures/estimate_reasons.png", plot, width=20, height=15, units='cm')



species <- data |>
  filter(grepl("species", coefficients)) |>
  arrange(estimates) |>
  mutate(
    coefficients = substr(coefficients, nchar("speciesname_new") + 1, nchar(coefficients))
  )

species$coefficients <- factor(species$coefficients, levels = species$coefficients)

plot <- ggplot(species, aes(coefficients, estimates)) +
  geom_bar(stat = "identity") +
  labs(x = "Species", y = "Coefficient Estimates")

ggsave("figures/estimate_species.png", plot, width=20, height=15, units='cm')

