library(tidyverse)

data <- read_csv(("data/Animal_Shelter_Animals.csv"))

# get the top 5 intake reasons
reasons <- data |>
  group_by(intakereason) |>
  summarise(
    n = n()
  ) |>
  arrange(
    desc(n)
  ) 

top5_reason <- reasons$intakereason[1:5]

# get the top 5 species other than cats and dogs
species <- data |>
  group_by(speciesname) |>
  summarise(
    n = n()
  ) |>
  arrange(
    desc(n)
  ) 

top7_species <- species$speciesname[1:7]

#new intake reasons and speciesname variables
data <- data |>
  mutate(
    intakereason_new = if_else(
      intakereason %in% top5_reason, intakereason, "Other"
    ),
    speciesname_new = if_else(
      speciesname %in% top7_species, speciesname, "Other"
    )
  )

write_csv(data, "derived_data/derived_data.csv")
