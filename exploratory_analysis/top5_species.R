library(tidyverse)

data <- read_csv("project/derived_data/derived_data.csv")

data <- data |>
  filter(
    !(speciesname_new %in% c("Cat", "Dog"))
  ) |>
  group_by(
    speciesname_new
  ) |>
  summarise(
    n = n()
  ) |>
  mutate(
    pct = 100*n/sum(n),
    pct_label = paste0(round(pct, 1), "%")
  ) |>
  arrange(
    desc(n)
  ) 

data$speciesname_new <- factor(data$speciesname_new, levels = as.character(data$speciesname_new))

plot <- ggplot(data, aes(x = "", y = n, fill = speciesname_new)) +
  geom_bar(stat="identity", width=1, color="white") +
  coord_polar("y", start=0) + 
  geom_text(aes(x = 1.25, label = pct_label), position = position_stack(vjust = .5)) +
  theme_void() +
  guides(fill = guide_legend(title = "Species")) + 
  labs(caption = "Most intook species other than cats and dogs")

ggsave("project/figures/top5_species.png", plot, width=20, height=15, units='cm')
