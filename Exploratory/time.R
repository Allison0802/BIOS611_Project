library(tidyverse)

data <- read_csv(("data/cleaned_data.csv"))

# get the top 5 species other than cats and dogs

plot <- ggplot(data, aes(x = year(intakedate))) +
  geom_bar() +
  labs(title = "Yearly Animal Intake", x = "Year", y = "Number of Animals")


ggsave("figures/intake_years.png", plot, width=25, height=15, units='cm')

