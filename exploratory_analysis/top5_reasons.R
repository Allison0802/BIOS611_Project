library(tidyverse)

data <- read_csv("derived_data/derived_data.csv")


data <- data |>
  group_by(
    intakereason_new
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

data$intakereason_new <- factor(data$intakereason_new, levels = as.character(data$intakereason_new))

plot <- ggplot(data, aes(x = "", y = n, fill = intakereason_new)) +
  geom_bar(stat="identity", width=1, color="white") +
  coord_polar("y", start=0) + 
  geom_text(aes(x = 1.25, label = pct_label), position = position_stack(vjust = .5)) +
  theme_void() +
  guides(fill = guide_legend(title = "Intake Reasons"))

ggsave("figures/top5_reasons.png", plot, width=20, height=15, units='cm')