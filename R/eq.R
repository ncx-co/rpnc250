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
  match_idx <- match(species_groups, rpnc250::table1$species_group)
  coeffs <- rpnc250::table1[match_idx, ]

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
#' \dontrun{
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
#' }

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
#' \code{\link{apply_volume_eq}}.
#' 
#' Note: this function returns gross volume (not net volume).
#'
#' @param vol_type units for volume estimates, either \code{cuft} or
#' \code{bdft}
#' @param height vector of heights to which to estimate volume
#' @inheritParams estimate_height
#'
#' @return vector of volume estimates
#' @examples
#' estimate_volume(
#'   spcd = c(541, 371, 95, 73),
#'   dbh = c(10, 11, 12, 13),
#'   height = c(40, 40, 24, 24),
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
    cuft = rpnc250::table2,
    bdft = rpnc250::table3
  )

  # get coefficients
  match_idx <- match(species_groups, coef_table$species_group)
  coeffs <- coef_table[match_idx, ]

  # estimate volume
  vols <- apply_volume_eq(
    dbh = dbh,
    height = height,
    b0 = coeffs$b0,
    b1 = coeffs$b1
  )

  # set small stem volume to NA
  vols[dbh < 5] <- NA

  return(vols)
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
#' \dontrun{
#' apply_volume_eq(
#'   dbh = 10,
#'   height = 40
#'   b0 = table2$b0[1],
#'   b1 = table2$b1[1]
#' )
#' }

apply_volume_eq <- function(dbh, height, b0, b1) {

  b0 + b1 * dbh^2 * height

}

#' Estimate biomass
#'
#' Estimate green tons of biomass to a given top diameter following the system
#' outlined in the original publication. Biomass of the bole (stem + stump),
#' bark, and top are summed to obtain an estimate of the total biomass.
#'
#' @inheritParams estimate_height
#'
#' @return estimates of biomass in tons
#' @examples
#' estimate_biomass(
#'   spcd = c(541, 371, 95, 73),
#'   dbh = c(10, 11, 12, 13),
#'   site_index = c(60, 65, 60, 70),
#'   stand_basal_area = 80
#' )
#'
#' @export

estimate_biomass <- function(spcd, dbh, site_index, stand_basal_area) {
  
  # height to 4" top
  height <- estimate_height(
    spcd = spcd,
    dbh = dbh,
    site_index = site_index,
    top_dob = 4,
    stand_basal_area = stand_basal_area
  )

  # gross volume
  gross_vol_cuft <- estimate_volume(
    spcd = spcd,
    dbh = dbh,
    height = height,
    vol_type = "cuft"
  )

  # stump volume
  stump_vol_cuft <- estimate_stump_volume(
    spcd = spcd,
    dbh = dbh
  )

  # species bark correction factor to adjust volume
  bark_correction_factor <- get_bark_correction_factor(
    spcd = spcd,
    dbh = dbh
  )

  # bark weight
  bark_weight_lbs <- estimate_bark_weight(
    gross_vol_cuft = gross_vol_cuft,
    stump_vol_cuft = stump_vol_cuft,
    bark_correction_factor = bark_correction_factor
  )

  # get total bole weight (stem + stump + bark)
  bole_weight_tons <- estimate_bole_weight(
    spcd = spcd,
    gross_vol_cuft = gross_vol_cuft,
    stump_vol_cuft = stump_vol_cuft,
    bark_weight_lbs = bark_weight_lbs
  )

  # get top weight
  top_weight_tons <- estimate_top_weight(
    spcd = spcd,
    bark_weight_lbs = bark_weight_lbs,
    gross_vol_cuft = gross_vol_cuft
  )

  # total biomass = bole + top
  biomass <- bole_weight_tons + top_weight_tons

  # identify trees smaller than 5" dbh
  small_trees <- dbh < 5

  # substitute alternative values for trees <5" DBH
  biomass[small_trees] <- apply_small_tree_biomass_eq(
    dbh = dbh[small_trees]
  )

  return(biomass)
}

#' Estimate stump volume
#'
#' Estimate stump volume following equation 3 in the original publication.
#'
#' @inheritParams estimate_height
#'
#' @return estimates of stump volume in cubic feet

estimate_stump_volume <- function(spcd, dbh) {
  # assign species_group
  species_groups <- assign_species_group(spcd)

  # get coefficients
  match_idx <- match(species_groups, rpnc250::table4$species_group)
  coeffs <- rpnc250::table4[match_idx, ][["stump_coef"]]

  assertthat::noNA(coeffs)

  # apply equation
  coeffs * dbh^2
}

#' Get bark correction factor
#'
#' Compute bark weight correction factor based on species and DBH following
#' equation 4 in the original publication.
#'
#' @inheritParams estimate_height
#'
#' @return species-specific bark correction factor values

get_bark_correction_factor <- function(spcd, dbh) {
  # assign species_group
  species_groups <- assign_species_group(spcd)

  # get coefficients
  match_idx <- match(species_groups, rpnc250::table4$species_group)
  coeffs <- rpnc250::table4[match_idx, ]

  assertthat::noNA(coeffs)

  # compute species correction factor
  (coeffs$bark_b0 + coeffs$bark_b1 * dbh) / 100
}

#' Estimate bark weight
#'
#' Estimate bark weight in lbs following equation 5 in the original publication.
#'
#' @param gross_vol_cuft estimates of gross volume in cubic feet
#' @param stump_vol_cuft estimates of stump volume in cubic feet
#' @param bark_correction_factor species-specific bark correction factors
#' estimated by \code{\link{get_bark_correction_factor}}
#'
#' @return estimates of bark weight in pounds

estimate_bark_weight <- function(gross_vol_cuft, stump_vol_cuft,
                                 bark_correction_factor) {

  (gross_vol_cuft + stump_vol_cuft) * (1.1646 - bark_correction_factor) * 37

}

#' Estimate bole weight
#'
#' Estimate bole (stump + stem) weight in tons following equation 6 in the
#' original publication.
#'
#' @param bark_weight_lbs estimates of bark weight in pounds estimated by
#' \code{\link{estimate_bark_weight}}
#' @inheritParams estimate_height
#' @inheritParams estimate_bark_weight
#'
#' @return estimates of bole weight in tons

estimate_bole_weight <- function(spcd, gross_vol_cuft, stump_vol_cuft,
                                 bark_weight_lbs) {
  # assign species_group
  species_groups <- assign_species_group(spcd)

  # get coefficients
  match_idx <- match(species_groups, rpnc250::table4$species_group)
  coeffs <- rpnc250::table4[match_idx, ][["biomass_lbs_per_ft3"]]

  assertthat::noNA(coeffs)

  # apply equation
  (bark_weight_lbs + (gross_vol_cuft + stump_vol_cuft) * coeffs) / 2000
}

#' Estimate top weight
#'
#' Estimate top weight in tons following equation 7 in the original publication.
#'
#' @inheritParams estimate_bole_weight
#'
#' @return estimates of bole weight in tons

estimate_top_weight <- function(spcd, bark_weight_lbs, gross_vol_cuft) {
  # assign species_group
  species_groups <- assign_species_group(spcd)

  # get coefficients
  match_idx <- match(species_groups, rpnc250::table4$species_group)
  coeffs <- rpnc250::table4[match_idx, ][["biomass_lbs_per_ft3"]]

  # apply equation
  0.4545 * (bark_weight_lbs + gross_vol_cuft * coeffs) / 2000
}

#' Apply small tree biomass equation
#' 
#' Apply the equation used for estimating biomass in trees less than 5" DBH
#' 
#' @inheritParams estimate_biomass
#' 
#' @return vector of biomass estimates in tons
#' @examples
#' \dontrun{
#' apply_small_tree_biomass_eq(4)
#' }

apply_small_tree_biomass_eq <- function(dbh) {

  4.8900625 * dbh^2.4323866 * 0.8 / 2000

}
