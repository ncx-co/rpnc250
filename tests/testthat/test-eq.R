test_that("height functions work", {
  ht_est <- estimate_height(
    spcd = 318,
    dbh = 12,
    site_index = 65,
    top_dob = 4,
    stand_basal_area = 88
  )

  expect_equal(
    ht_est, 49.6419 - 1.2e-05
  )

  ht_coeffs <- dplyr::filter(
    table1,
    species_group == "Hard maple"
  )

  expect_equal(
    apply_height_eq(
      dbh = 12,
      site_index = 65,
      top_dob = 4,
      stand_basal_area = 88,
      b1 = ht_coeffs$b1,
      b2 = ht_coeffs$b2,
      b3 = ht_coeffs$b3,
      b4 = ht_coeffs$b4,
      b5 = ht_coeffs$b5,
      b6 = ht_coeffs$b6
    ),
    49.64189 - 1.95e-06
  )
})

test_that("volume functions work", {
  gross_vol_cuft <- estimate_volume(
    spcd = 318,
    dbh = 12,
    height = 49.6,
    vol_type = "cuft"
  )

  expect_equal(
    gross_vol_cuft,
    17.13073 + 4.4e-06
  )

  cuft_vol_coeffs <- dplyr::filter(
    table2,
    species_group == "Hard maple"
  )

  expect_equal(
    apply_volume_eq(
      dbh = 12,
      height = 49.6,
      b0 = cuft_vol_coeffs$b0,
      b1 = cuft_vol_coeffs$b1
    ),
    17.13073 + 4.4e-06
  )

  # sawtimber
  saw_ht <- estimate_height(
    spcd = 318,
    dbh = 12,
    site_index = 65,
    top_dob = 9,
    stand_basal_area = 88
  )

  gross_vol_bdft <- estimate_volume(
    spcd = 318,
    dbh = 12,
    height = saw_ht,
    vol_type = "bdft"
  )

  expect_equal(
    gross_vol_bdft,
    90.78875 - 1.48e-06
  )
})

test_that("biomass functions work", {
  gross_vol_cuft <- estimate_volume(
    spcd = 318,
    dbh = 12,
    height = 49.6,
    vol_type = "cuft"
  )
  
  # stump volume
  stump_vol_cuft <- estimate_stump_volume(
    spcd = 318,
    dbh = 12
  )

  expect_equal(
    stump_vol_cuft,
    1.280736
  )

  # bark correction factor
  bark_correction_factor <- get_bark_correction_factor(
    spcd = 318,
    dbh = 12
  )

  expect_equal(
    bark_correction_factor,
    0.97064
  )

  # bark weight
  bark_weight_lbs <- estimate_bark_weight(
    gross_vol_cuft = gross_vol_cuft,
    stump_vol_cuft = stump_vol_cuft,
    bark_correction_factor = bark_correction_factor
  )

  expect_equal(
    bark_weight_lbs,
    132.1303 - 1.44e-05
  )

  # bole weight
  bole_weight_tons <- estimate_bole_weight(
    spcd = 318,
    gross_vol_cuft = gross_vol_cuft,
    stump_vol_cuft = stump_vol_cuft,
    bark_weight_lbs = bark_weight_lbs
  )

  expect_equal(
    bole_weight_tons,
    0.5815863
  )

  # top weight
  top_weight_tons <- estimate_top_weight(
    spcd = 318,
    bark_weight_lbs = bark_weight_lbs,
    gross_vol_cuft = gross_vol_cuft
  )

  expect_equal(
    top_weight_tons,
    0.2480323 + 3.34e-08
  )

  # small stem biomass
  expect_equal(
    apply_small_tree_biomass_eq(4),
    0.05699241
  )
  

  # user facing function
  expect_equal(
    estimate_biomass(
      spcd = 318,
      dbh = c(12, 4),
      site_index = 65,
      stand_basal_area = 88
    ),
    c(0.83023001, 0.05699241)
  )
})
