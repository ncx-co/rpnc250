library(tidyverse)

# get ref_species table from FIA
ref_species <- tidyFIA::ref_tables[["species"]] %>%
  transmute(
    common_name,
    spcd,
    scientific_name = paste(genus, species)
  )

# use Appendix III from original paper to generate crosswalk between groups and
# actual species
species_list <- list(
  "Jack pine" = "Pinus banksiana",
  "Red pine" = "Pinus resinosa",
  "White pine" = "Pinus strobus",
  "Ponderosa pine" = "Pinus ponderosa",
  "White spruce" = "Picea glauca",
  "Black spruce" = "Picea mariana",
  "Balsam fir" = "Abies balsamea",
  "Hemlock" = "Tsuga canadensis",
  "Tamarack" = "Larix laricina",
  "Northern white-cedar" = "Thuja occidentalis",
  "Eastern redcedar" = "Juniperus virginiana",
  "Other softwoods" = c(
    "Pinus sylvestris",
    "Pinus nigra",
    "Larix decidua",
    "Picea abies",
    "Pseudotsuga menziesii"
  ),
  "White oak" = c(
    "Quercus alba",
    "Quercus bicolor",
    "Quercus macrocarpa",
    "Quercus muehlenbergii"
  ),
  "Red oak" = c(
    "Quercus rubra",
    "Quercus velutina",
    "Quercus palustris",
    "Quercus ellipsoidalis"
  ),
  "Hickory" = c(
    "Carya cordiformis",
    "Carya ovata",
    "Carya glabra"
  ),
  "Basswood" = "Tilia americana",
  "Beech" = "Fagus grandifolia",
  "Yellow birch" = "Betula alleghaniensis",
  "Hard maple" = c(
    "Acer nigrum",
    "Acer saccharum"
  ),
  "Soft maple" = c(
    "Acer rubrum",
    "Acer saccharinum" # silver maple but species is misspecified in paper
  ),
  "Elm" = c(
    "Ulmus americana",
    "Ulmus rubra",
    "Ulmus thomasii"
  ),
  "Black ash" = "Fraxinus nigra",
  "White & green ash" = c(
    "Fraxinus americana",
    "Fraxinus pennsylvanica"
  ),
  "Sycamore" = "Platanus occidentalis",
  "Cottonwood" = "Populus deltoides",
  "Willow" = "Salix spp.",
  "Hackberry" = "Celtis occidentalis",
  "Balsam poplar" = "Populus balsamifera",
  "Bigtooth aspen" = "Populus grandidentata",
  "Quaking aspen" = "Populus tremuloides",
  "Paper birch" = "Betula papyrifera",
  "River birch" = "Betula nigra",
  "Sweetgum" = "Liquidambar styraciflua",
  "Tupelo" = "Nyssa sylvatica",
  "Black cherry" = "Prunus serotina",
  "Black walnut" = "Juglans nigra",
  "Butternut" = "Juglans cinerea",
  "Yellow poplar" = "Liriodendron tulipifera",
  "Other hardwoods" = c(
    "Acer negundo"
  ),
  "Noncommercial spp." = c(
    "Acer pensylvanicum",
    "Acer spicatum",
    "Ailanthus altissima", # Adanthus altessimor in paper
    "Carpinus caroliniana",
    "Ostrya virginiana",
    "Cercis canadensis",
    "Crataegus spp.",
    "Prunus pensylvanica",
    "Prunus virginiana",
    "Sorbus americana"
  )
)

species_groups <- table1 %>%
  select(
    species_group
  )


species <-
  purrr::imap_dfr(
    .x = species_list,
    .f = ~ tibble::tibble(
      species_group = .y,
      scientific_name = .x
    )
  ) %>%
  left_join(
    ref_species,
    by = "scientific_name"
  )

usethis::use_data(species, overwrite = TRUE)
