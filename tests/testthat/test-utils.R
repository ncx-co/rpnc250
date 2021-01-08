test_that("assign_species_group works", {
  expect_identical(
    assign_species_group(
      spcd = unique(test_trees$spcd)
    ),
    c(
      "Black spruce", "Tamarack", "Quaking aspen",
      "Balsam fir", "Paper birch", "Soft maple",
      "White spruce", "Black ash", "Noncommercial spp.",
      "Bigtooth aspen"
    )
  )
})
