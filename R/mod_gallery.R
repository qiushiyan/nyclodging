#' gallery UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @importFrom waiter autoWaiter
#' @import echarts4r
#' @import dplyr 
mod_gallery_ui <- function(id) {
  ns <- NS(id)
  tagList(
    autoWaiter(ns(c("room_type_bar", "reviews_price_scatter"))), 
    col_12(h2("Graph Gallery")),
    col_8(
      echarts4rOutput(ns("room_type_bar"), height = "50vh")
    ),
    col_4(
      echarts4rOutput(ns("reviews_price_scatter"))
    )
  )
}
    
#' gallery Server Functions
#'
#' @noRd 
mod_gallery_server <- function(id) {
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$room_type_bar <- renderEcharts4r(
      listings_cut %>%
        filter(!is.na(price_cut)) %>%
        group_by(room_type) %>%
        count(price_cut) %>%
        group_by(price_cut) %>%
        e_chart(room_type, reorder = TRUE) %>%
        e_bar(n) %>%
        e_title("price intervals for room type") %>%
        e_tooltip(trigger = "axis")
    )
    
    output$reviews_price_scatter <- renderEcharts4r(
      listings %>% 
        slice_sample(n = 3000) %>% 
        filter(price <= 500, reviews <= 100) %>% 
        group_by(room_type) %>% 
        e_chart(reviews, timeline = TRUE) %>%
        e_scatter(price) %>%
        e_loess(price ~ reviews) %>% 
        e_title("price vs. reviews", subtext = "n = 3000 sample") %>%
        e_legend(show = FALSE) %>% 
        e_tooltip(trigger = "item",
                  formatter = htmlwidgets::JS("
                    function(params){
                      return('wt: ' + params.value[0] + '<br />mpg: ' + params.value[1])
                    }
                    "))
    )
    
    

  })
}
    
## To be copied in the UI
# mod_gallery_ui("gallery_ui_1")
    
## To be copied in the server
# mod_gallery_server("gallery_ui_1")
