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
    autoWaiter(ns(c("room_type_bar", 
                    "reviews_price_scatter",
                    "wordcloud_low",
                    "wordcloud_high"))), 
    
    col_12(h2("Graph Gallery")),
    col_8(
      echarts4rOutput(ns("room_type_bar"), height = "50vh")
    ),
    col_4(
      echarts4rOutput(ns("reviews_price_scatter"))
    ), 
    col_6(
      echarts4rOutput(ns("wordcloud_low"))
    ), 
    col_6(
      echarts4rOutput(ns("wordcloud_high"))
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
        e_tooltip(trigger = "axis") %>% 
        e_legend(orient = "vertical", right = "5", top = "10%")
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
    
  output$wordcloud_low <- renderEcharts4r(
    listings_words %>% 
      mutate(prop = n / sum(n)) %>%
      filter(price == "lower than 100") %>% 
      e_color_range(n, color, 
                    colors = c(
                      "#ffffcc",
                      "#c7e9b4",
                      "#7fcdbb",
                      "#41b6c4",
                      "#2c7fb8",
                      "#253494")) %>% 
      e_charts() %>% 
      e_cloud(word, prop, color) %>% 
      e_tooltip(formatter = htmlwidgets::JS("
                    function(params){
                      return(params.name + ': ' + params.value.toFixed(3) * 100 + '%')
                    }
                    ")) %>% 
      e_title("common words in description", subtext = "price lower than 100")
    
  )
    
  output$wordcloud_high <- renderEcharts4r(
    listings_words %>% 
      mutate(prop = n / sum(n)) %>% 
      filter(price == "higher than 100") %>% 
      e_color_range(n, color, 
                    colors = c("#feedde",
                               "#fdd0a2",
                               "#fdae6b",
                               "#fd8d3c",
                               "#e6550d",
                               "#a63603")) %>% 
      e_charts() %>% 
      e_cloud(word, prop, color) %>% 
      e_tooltip(formatter = htmlwidgets::JS("
                    function(params){
                      return(params.name + ': ' + params.value.toFixed(3) * 100 + '%')
                    }
                    ")) %>% 
      e_title("common words in description", subtext = "price higher than 100")
  )
  })
}
    
## To be copied in the UI
# mod_gallery_ui("gallery_ui_1")
    
## To be copied in the server
# mod_gallery_server("gallery_ui_1")
