library(tidyverse)

data <- read_csv(("data/Animal_Shelter_Animals.csv"))

# clean dates, drop the time because they are all 12:00:00 am
data <- data |>
  distinct() |>
  mutate(
    intakedate = as_date(mdy_hms(intakedate)),
    movementdate = as_date(mdy_hms(movementdate)),
    returndate = as_date(mdy_hms(returndate)),
    deceaseddate = as_date(mdy_hms(deceaseddate))
  )

# transpose to one id per row, create a column indicating if the animal has ever been adopted
move_info <- data |>
  select(id, movementdate,movementtype) 

move_date_type <- move_info |>
  group_by(id) |>
  arrange(movementdate, .by_group = T) |>
  mutate(
    index = row_number(id)
  ) |>
  pivot_wider(
    names_from = index,
    values_from = c(movementdate, movementtype)
  ) |>
  mutate(
    adopt = +if_any(starts_with("movementtype"), ~. == "Adoption"),
    adopt = if_else(is.na(adopt), F, T)
  )

first_adopt <- move_info |>
  group_by(id) |>
  filter(movementtype == "Adoption") |>
  summarise(first_adoption_date = min(movementdate, na.rm = TRUE))

return_date_type <- data |>
  select(id, returndate, returnedreason) |>
  group_by(id) |>
  arrange(returndate, .by_group = T) |>
  mutate(
    index = row_number(id)
  ) |>
  pivot_wider(
    names_from = index,
    values_from = c(returndate, returnedreason)
  )

data <- list(select(data, -c(movementdate, movementtype, returndate, returnedreason)), 
             move_date_type, 
             first_adopt, 
             return_date_type) |>
  reduce(full_join, by = 'id') |>
  distinct()

# view the duplicates
dup_id <- data |>
  group_by(id) |>
  summarise(
    n = n()
  ) |>
  filter(n > 1)

dups <- left_join(dup_id, data)
# all  dups have a True and a False in "istrial" 

count(filter(data, istrial == T))
# a total of 51 with istrial is True -- among which 39 are the duplicates

# change records with conflicting istrial values to True

dups <- dups |>
  mutate(
    istrial = T 
  ) |>
  distinct()|>
  select(-n)

#split the breed column, transform the unit of age to months, calculate time to be adopted

data <- rbind(
  filter(data, !(id %in% dup_id$id)),
  dups
) |>
  separate_wider_delim(
    breedname,
    delim = "/",
    names = c("breed1", "breed2", "breed3"),
    too_few = "align_start",
    cols_remove = F
  ) |>
  mutate(
    age_month = as.numeric(word(animalage, 1)) * 12 + as.numeric(word(animalage, 3)),
    time_in_shelter = difftime(first_adoption_date, intakedate, units = "day")
  )

write_csv(data, "data/cleaned_data.csv")

