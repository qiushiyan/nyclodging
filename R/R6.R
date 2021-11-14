#' R6 class for plotting
#' @import tmap
#' @import dplyr
#' @import sf
#' @import echarts4r
#' @importFrom R6 R6Class
PlotManager <- R6::R6Class(
  "plotting manager", 
  public = list(
    fill_vars = NULL,
    facet_vars = NULL,
    plot_vars = NULL, 
    plot_dist = function() {
      
    }
  )
)