library(tidyverse)

data <- read_csv(("data/cleaned_data.csv"))

# get the top 5 intake reasons
reasons <- data |>
  group_by(intakereason) |>
  summarise(
    n = n()
  ) |>
  arrange(
    n
  ) |>
  filter(
    !is.na(intakereason)
  )

reasons$intakereason <- factor(reasons$intakereason, levels = reasons$intakereason)

plot <- ggplot(reasons, aes(intakereason, n)) +
  geom_bar(stat = "identity") +
  labs(title = "Animal Intake Reasons", x = "Reasons", y = "Count")+
  coord_flip()

ggsave("figures/intake_reasons.png", plot, width=20, height=15, units='cm')
