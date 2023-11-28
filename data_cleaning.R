library(tidyverse)

data <- read_csv(("data/Animal_Shelter_Animals.csv"))

# clean dates, discard the time because they are all 12:00:00 am
data <- data |>
  distinct() |>
  mutate(
    intakedate = as_date(mdy_hms(intakedate)),
    movementdate = as_date(mdy_hms(movementdate)),
    returndate = as_date(mdy_hms(returndate)),
    deceaseddate = as_date(mdy_hms(deceaseddate))
  )

# transpose to one id per row
move_return <- data |>
  select(id, movementdate, movementtype, returndate, returnedreason) 

move_return <- move_return |>
  group_by(id) |>
  arrange( movementdate, returndate, .by_group = T) |>
  mutate(
    index = row_number(id)
  ) |>
  pivot_wider(
    names_from = index,
    values_from = c(movementdate, movementtype, returndate, returnedreason)
  )
  
data <- left_join(select(data, -c(movementdate, movementtype, returndate, returnedreason)), move_return) |>
  distinct() # still have duplicates

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

data <- rbind(
  filter(data, !(id %in% dup_id$id)),
  dups
)

write_csv(data, "data/cleaned_data.csv")
