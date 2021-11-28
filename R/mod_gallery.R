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
#' @import leaflet
#' @importFrom glue glue
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
    ),
    col_4(
      echarts4rOutput(ns("cor_mat"))
    ), 
    col_8(
      leafletOutput(ns("map"))
    )
  )
}
    
#' gallery Server Functions
#'
#' @noRd 
mod_gallery_server <- function(id) {
  moduleServer( id, function(input, output, session) {
    ns <- session$ns
    
    tag_map_title <- tags$style(HTML("
      .leaflet-control.map-title { 
        transform: translate(-50%,20%);
        position: fixed !important;
        left: 50%;
        text-align: center;
        padding-left: 10px; 
        padding-right: 10px; 
        background: rgba(255,255,255,0.75);
        font-weight: bold;
        font-size: 28px;
      }
    "))
    
    map_title <- tags$div(
      tag_map_title, HTML("Listings over $1000")
    )  
    

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
        e_legend(orient = "vertical", right = "5", top = "10%") %>% 
        e_labels()
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
  
  output$cor_mat <- renderEcharts4r(
    listings %>% 
      na.omit() %>% 
      select(!!plot_vars) %>% 
      select(where(is.numeric)) %>%
      cor() %>%
      apply(1, round, 2) %>% 
      e_charts() %>% 
      e_correlations(order = "hclust") %>% 
      e_tooltip() %>% 
      e_legend(orient = "vertical", left = "5", top = "10%") %>% 
      e_title("correlation matrix")
  )
  
  output$map <- renderLeaflet(
    listings %>%
      mutate(label = glue("
        <b>price</b>: {scales::dollar(price)}<br>
        <b>description</b>: {list_description}<br>
        <b>room type</b>: {room_type}<br>
        <b>neighorboud</b>: {neighbourhood}<br>
        <b>neighorboud group</b>: {neighbourhood_group}<br>
        <b>reviews</b>: {reviews}<br>
        <b>minimum nights</b>: {min_nights}<br>
        <b>last review date</b>: {last_review_date}<br>
        <b>list id</b>: {list_id}
      ")) %>% 
      filter(price >= 1000) %>% 
      leaflet() %>% 
      addTiles() %>% 
      addProviderTiles(providers$Esri.WorldTopoMap) %>% 
      addCircleMarkers(clusterOptions = markerClusterOptions(maxClusterRadius = 30),
                       fill = ~ price, popup = ~ label) %>%
      addControl(map_title, position = "topleft", className="map-title") 
      )
})}
    
## To be copied in the UI
# mod_gallery_ui("gallery_ui_1")
    
## To be copied in the server
# mod_gallery_server("gallery_ui_1")
