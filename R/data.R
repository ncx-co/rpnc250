#' species
#'
#' A dataframe relating the 'Species Group' in RP NC-250 to records in FIA's
#' ref_species table
#'
#' @format dataframe:
#' \describe{
#'   \item{species_group}{species group label from paper}
#'   \item{scientific_name}{Genus species}
#'   \item{common_name}{common name}
#'   \item{spcd}{numeric FIA species code}
#' }
#' @source data-raw/species.R
"species"

#' table1
#'
#' A dataframe containing coefficients for the height model equation from Table
#' 1 in the original publication.
#'
#' @format dataframe:
#' \describe{
#'   \item{species_group}{species group label from paper}
#'   \item{b1}{first height model coefficient for diameter term}
#'   \item{b2}{second height model coefficient for DBH term}
#'   \item{b3}{third height model coefficient for diameter term}
#'   \item{b4}{height model coefficient for site index term}
#'   \item{b5}{height model coefficient for top diameter term}
#'   \item{b6}{height model coefficient for basal area term}
#'   \item{std_err}{standard error (feet) of model estimates for each species}
#' }
#' @source data-raw/tables.R
"table1"


#' table2
#'
#' A dataframe containing volume model coefficients for cubic foot volume from
#' Table 2 in the original publication.
#'
#' @format dataframe:
#' \describe{
#'   \item{species_group}{species group label from paper}
#'   \item{n}{number of trees in fitting data}
#'   \item{b0}{intercept term in volume model equation}
#'   \item{b1}{volume model coefficient for DBH term}
#'   \item{std_err}{standard error (cubic feet) of model estimates for each
#'   species}
#'   \item{br2}{\eqn{R^2}: coefficient of determination for the species-level
#'   model}
#'   \item{growing_stock_cull_pct}{expected percent of gross volume that is cull
#'   for growing stock trees}
#'   \item{rough_cull_pct}{expected percent of gross volume that is cull for
#'   rough trees}
#'   \item{rotten_cull_pct}{expected percent of gross volume that is cull for
#'   rotten trees}
#' }
#' @source data-raw/tables.R
"table2"

#' table3
#'
#' A dataframe containing volume model coefficients for board foot volume from
#' Table 3 in the original publication.
#'
#' @format dataframe:
#' \describe{
#'   \item{species_group}{species group label from paper}
#'   \item{n}{number of trees in fitting data}
#'   \item{b0}{intercept term in volume model equation}
#'   \item{b1}{volume model coefficient for DBH term}
#'   \item{std_err}{standard error (board feet) of model estimates for each
#'   species}
#'   \item{br2}{\eqn{R^2}: coefficient of determination for the species-level
#'   model}
#'   \item{growing_stock_cull_pct}{expected percent of gross volume that is cull
#'   for growing stock trees}
#'   \item{short_log_cull_pct}{expected percent of gross volume that is cull for
#'   short log trees}
#' }
#' @source data-raw/tables.R
"table3"

#' table4
#'
#' A dataframe containing coefficients for stump volume, bark corrections, and
#' biomass from Table 4 in the original publication.
#'
#' @format dataframe:
#' \describe{
#'   \item{species_group}{species group label from paper}
#'   \item{stump_coef}{stump volume model coefficient for DBH term}
#'   \item{bark_b0}{intercept term in bark volume model equation}
#'   \item{bark_b1}{bark weight model coefficient for DBH term}
#'   \item{biomass_lbs_per_ft3}{expected density conversion factor
#'   (\eqn{lbs/ft^3}) for each species}
#' }
#' @source data-raw/tables.R
"table4"

#' test_trees
#'
#' A dataframe containing a sample of measured trees from FIA plots in northern
#' Minnesota.
#'
#' @format dataframe:
#' \describe{
#'   \item{cn}{tree cn}
#'   \item{plt_cn}{plot cn}
#'   \item{statuscd}{tree status code: 0 = dead, 1 = alive}
#'   \item{spcd}{numeric FIA species code}
#'   \item{common_name}{species common name}
#'   \item{dbh}{diameter at breast height in inches}
#'   \item{tpa_unadj}{trees per acre expansion factor for plot_cn}
#'   \item{volcfgrs}{gross cubic foot volume as computed by FIA}
#' }
#' @source data-raw/test_trees.R
"test_trees"

#' ref_species
#'
#' ref_species table from USFS FIADB: see page 9-19 of FIADB 2.0 User Guide for
#' description
#' 
#' @source data-raw/ref_species.R
"ref_species"
