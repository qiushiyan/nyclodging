names_that_are <- function(class_is) {
  r <- sapply(listings, class)
  ns <- names(r[r %in% class_is])
  intersect(ns, plot_vars)
}
