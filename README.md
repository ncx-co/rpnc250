
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rpnc250

<!-- badges: start -->

<!-- badges: end -->

The goal of rpnc250 is to provide R functions that produce height,
volume, and biomass estimates using the equations and coefficients from
USFS Research Paper NC-250: Tree volume and biomass equations for the
Lake States.

Hahn, Jerold T. 1984. Tree volume and biomass equations for the Lake
States. Research Paper NC-250. St. Paul, MN: U.S. Dept. of Agriculture,
Forest Service, North Central Forest Experiment Station

The original publication can be accessed from the
[USFS](https://www.fs.usda.gov/treesearch/pubs/10037).

## Installation

You can install the released version of rpnc250 from Github with:

``` r
remotes::install_github("SilviaTerra/rpnc250")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(rpnc250)
library(dplyr)
library(ggplot2)

trees_with_biomass <- test_trees %>%
  filter(!is.na(dbh)) %>%
  mutate(
    biomass = estimate_biomass(
      spcd = spcd,
      dbh = dbh,
      site_index = 65,
      stand_basal_area = 75
    )
  )

trees_with_biomass %>%
  ggplot(aes(x = dbh, y = biomass, color = common_name)) +
  geom_point()
```

<img src="man/figures/README-example-1.png" width="100%" />
