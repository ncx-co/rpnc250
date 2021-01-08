#' Assign species group
#'
#' Assign individual FIA species codes to one of the 'Species Groups' as
#' described in the original paper.
#'
#' @inheritParams estimate_height
#'
#' @return character vector of valid species groups from the tables in the
#' original publication
#' @examples
#' \dontrun{
#'   assign_species_group(c(541, 371, 95, 73))
#' }

assign_species_group <- function(spcd) {
  # get hardwood/softwood for each species
  major_group <- rpnc250::ref_species$major_spgrpcd[
    match(spcd, rpnc250::ref_species$spcd)
    ]

  species_groups <- dplyr::case_when(
    spcd %in% rpnc250::species$spcd ~
      species$species_group[match(spcd, species$spcd)],
    major_group %in% c(1, 2) ~ "Other softwoods",
    major_group %in% c(3, 4) ~ "Other hardwoods",
    TRUE ~ NA_character_
  )

  assertthat::noNA(species_groups)

  return(species_groups)
}
