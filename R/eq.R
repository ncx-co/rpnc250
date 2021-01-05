#' Estimate height
#'
#' Estimate height to a given top diameter given species, diameter, site index,
#' and stand basal area. The height equation is applied by the function
#' \code{\link{apply_height_eq}}.
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
#' The height equation is as follows:
#' \deqn{Height = 4.5 + b_1(1-e^{(-b_2D)})^{b_3}*S^{b_4}*T^{b_5}*B^{b_6}}
#' 
#' Where:
#' \itemize{
#'   \item \eqn{b_1}, \eqn{b_2}, \eqn{b_3}, \eqn{b_4}, \eqn{b_5}, \eqn{b_6} are
#'   species specific coefficients from Table 1
#'   \item \eqn{D} is diameter at breast height in inches
#'   \item \eqn{S} is site index (base age 50)
#'   \item \eqn{T} is \eqn{1.00001 - d/D}, \eqn{d} is top diameter outside bark
#'   \item \eqn{B} is stand basal area in square feet per acre
#' }
#'
#' @param b1,b2,b3,b4,b5,b6 numeric vector of model coefficients from Table 1
#' @inheritParams estimate_height
#'
#' @return vector of height estimates
#' @examples
#' apply_height_eq(
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

#' Estimate volume
#'
#' Estimate volume to specified height along stem in either cubic feet or
#' International 1/4 board feet. The equation is applied by the function
#' \code{\link{apply_volume_equation}}
#'
#' @param vol_type units for volume estimates, either \code{cuft} or
#' \code {bdft}
#' @param height vector of heights to which to estimate volume
#' @inheritParams estimate_height
#'
#' @return vector of volume estimates
#' @examples
#' estimate_volume(
#'   spcd = c(541, 371, 95, 73),
#'   dbh = c(10, 11, 12, 13),
#'   height = 40, 40, 24, 24,
#'   vol_type = "cuft"
#' )
#' @export

estimate_volume <- function(spcd, dbh, height, vol_type = c("cuft", "bdft")) {
  # verify volume type as either cuft or bdft
  vol_type <- match.arg(vol_type, choices = c("cuft", "bdft"))

  # assign species_group
  species_groups <- assign_species_group(spcd)

  # choose coef table 2 or 3 depending on volume type
  coef_table <- switch(
    vol_type,
    cuft = table2,
    bdft = table3
  )

  # get coefficients
  match_idx <- match(species_groups, coef_table$species_group)
  coeffs <- coef_table[match_idx, ]

  # estimate height
  apply_volume_eq(
    dbh = dbh,
    height = height,
    b0 = coeffs$b0,
    b1 = coeffs$b1
  )
}

#' Apply volume equation
#'
#' Apply the volume equation (eq. 1 in publication) from RP NC-250 using
#' provided dbh, height to merchantable limit, and coefficients from Table 1 in
#' the publication.
#'
#' The volume equation is as follows:
#' \deqn{V = b_0 + b_1 D^2 H}
#'
#' Where:
#' \itemize{
#'   \item \eqn{V} is the volume in either cubic feet or board feet
#'   \item \eqn{b_0} and \eqn{b_1} are species specific coefficients from Table
#'   1
#'   \item \eqn{D} is diameter at breast height in inches
#'   \item \eqn{H} height to which volume is to be computed
#' }
#'
#' @param b0,b1 vector of model coefficients from Table 2 or Table 3
#' @inheritParams estimate_volume
#'
#' @return vector of volume estimates
#' @examples
#' apply_volume_eq(
#'   dbh = 10,
#'   height = 40
#'   b0 = table2$b0[1],
#'   b1 = table2$b1[1]
#' )

apply_volume_eq <- function(dbh, height, b0, b1) {

  b0 + b1 * dbh^2 * height

}
