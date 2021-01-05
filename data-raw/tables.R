library(tidyverse)

# function to fix hickory/oak species groups to match labels in species table
# we will assume all red oak and hickory species are "select"
filter_reference_tables <- function(x) {
  x %>%
    filter(
      !species_group %in% c("Other red oak", "Other hickory")
    ) %>%
    mutate(
      species_group = case_when(
        species_group == "Select red oak" ~ "Red oak",
        species_group == "Select white oak" ~ "White oak",
        species_group == "Select hickory" ~ "Hickory",
        TRUE ~ species_group
      )
    )
}

# function to make sure species groups line up with groups in species table
check_reference_tables <- function(x) {
  check1 <- all(x$species_group %in% species$species_group)
    
  check2 <- all(species$species_group %in% x$species_group)

  check1 & check2
}

# import all tables from csv, apply filter, check species groups
table1 <- vroom::vroom("inst/csv/table1.csv") %>%
  filter_reference_tables()

assertthat::assert_that(check_reference_tables(table1))

table2 <- vroom::vroom("inst/csv/table2.csv") %>%
  filter_reference_tables()

assertthat::assert_that(check_reference_tables(table2))

table3 <- vroom::vroom("inst/csv/table3.csv") %>%
  filter_reference_tables()

assertthat::assert_that(check_reference_tables(table3))

table4 <- vroom::vroom("inst/csv/table4.csv") %>%
  filter_reference_tables()

assertthat::assert_that(check_reference_tables(table4))

# add to package data
usethis::use_data(table1, overwrite = TRUE)
usethis::use_data(table2, overwrite = TRUE)
usethis::use_data(table3, overwrite = TRUE)
usethis::use_data(table4, overwrite = TRUE)
