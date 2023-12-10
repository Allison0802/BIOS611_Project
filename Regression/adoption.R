library(tidyverse)
library(gbm)
library(plotmo)   

data <- read_csv(("data/cleaned_data.csv"))

#data prep

# get the top 5 intake reasons
reasons <- data |>
  group_by(intakereason) |>
  summarise(
    n = n()
  ) |>
  arrange(
    desc(n)
  ) 

top16_reason <- reasons$intakereason[1:16]

# get the top 5 species other than cats and dogs
species <- data |>
  group_by(speciesname) |>
  summarise(
    n = n()
  ) |>
  arrange(
    desc(n)
  ) 

top6_species <- species$speciesname[1:6]

data <- data |>
  select(
    intakereason, speciesname, sexname, adopt, age_month, istransfer, istrial
  ) |>
  mutate(
    intakereason_new = as.factor(if_else(
      intakereason %in% top16_reason, intakereason, "Other"
    )),
    speciesname_new = as.factor(if_else(
      speciesname %in% top6_species, speciesname, "Other"
    )),
    sexname = as.factor(sexname),
    istrial = 1 * istrial,
    istransfer = 1 * istransfer,
    adopt = 1 * adopt
  )

#build the model
explanatory <- data %>% select(-adopt, -intakereason, -speciesname) %>% names()
formula <- as.formula(sprintf("adopt ~ %s", paste(explanatory, collapse=" + ")))

model <- gbm(formula, data = data)
summary(model)

plotres(model) 

# try to improve the model performance
model1 <- gbm(adopt ~ sexname + age_month + intakereason_new + speciesname_new, 
              data = data, interaction.depth = 2)
summary(model1)

# residual plot
png(filename = "figures/residual_plot.png", width = 20, height = 15, units = "cm", res = 300)
plotres(model1) 
dev.off()


