library(tidyFIA)
library(tidyverse)

# pull some FIA data for testing out the functions
coord <- sf::st_point(c(-91.724078, 47.905365))

aoi <- sf::st_sfc(coord, crs = 4326) %>%
  sf::st_transform(crs = 2163) %>%
  sf::st_buffer(6000) %>%
  sf::st_transform(4326) %>%
  sf::st_as_sf()

fia_data <- tidy_fia(
  aoi = aoi,
  postgis = TRUE,
  table_names = c("plot", "subplot", "cond", "tree")
)

test_trees <- fia_data[["tree"]] %>%
  filter(invyr >= 2000) %>%
  dplyr::left_join(
    ref_tables[["species"]],
    by = "spcd"
  ) %>%
  dplyr::select(
    cn,
    plt_cn,
    statuscd,
    spcd,
    common_name, 
    dbh = dia,
    tpa_unadj,
    ht,
    volcfgrs
  )

usethis::use_data(test_trees, overwrite = TRUE)
