#' Estimate height
#'
#' Estimate height to a given top diameter given species, diameter, site index,
#' and stand basal area
#'
#' @param spcd vector of FIA species codes
#' @param dbh vector of DBH observations in inches
#' @param site_index vector of site index estimates (base age 50)
#' @param top_dob vector of outside-bark diameter values to which height will
#' be estimated
#' @param stand_basal_area vector of stand-level basal area estimates
#' corresponding to the stems
#'
#' @return vector of height estimates
#' @examples
#' estimate_height(
#'   spcd = c(541, 371, 95, 73),
#'   dbh = c(10, 11, 12, 13),
#'   site_index = c(60, 65, 60, 70),
#'   top_dob = c(4, 4, 9, 10),
#'   stand_basal_area = 80
#' )
#' @export

estimate_height <- function(spcd, dbh, site_index, top_dob, stand_basal_area) {

  # assign species_group
  species_groups <- assign_species_group(spcd)

  # get coefficients
  match_idx <- match(species_groups, table1$species_group)
  coeffs <- table1[match_idx, ]

  # estimate height
  apply_height_eq(
    dbh = dbh,
    site_index = site_index,
    top_dob = top_dob,
    stand_basal_area = stand_basal_area,
    b1 = coeffs$b1,
    b2 = coeffs$b2,
    b3 = coeffs$b3,
    b4 = coeffs$b4,
    b5 = coeffs$b5,
    b6 = coeffs$b6
  )

}

#' Apply height equation
#'
#' Apply the height equation (eq. 2 in publication) from RP NC-250 using
#' provided dbh, site index, outside-bark top diameter, stand basal area, and
#' coefficients from Table 1 in the publication.
#'
#' @param b1,b2,b3,b4,b5,b6 numeric vector of model coefficients from Table 1
#' @inheritParams estimate_height
#'
#' @return vector of height estimates
#' @examples
#' height_eq(
#'   dbh = 10,
#'   site_index = 60,
#'   top_dob = 4,
#'   stand_basal_area = 75,
#'   b1 = table1$b1[1],
#'   b2 = table1$b2[1],
#'   b3 = table1$b3[1],
#'   b4 = table1$b4[1],
#'   b5 = table1$b5[1],
#'   b6 = table1$b6[1]
#' )

apply_height_eq <- function(dbh, site_index, top_dob, stand_basal_area,
                      b1, b2, b3, b4, b5, b6) {
  t_term <- (1.00001 - top_dob / dbh)

  # equation 2 from RP NC-250
  4.5 + b1 * (1 - exp(-b2 * dbh))^b3 * site_index^b4 * t_term^b5 *
    stand_basal_area^b6
}
