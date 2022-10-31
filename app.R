
library(shiny)
library(leaflet)
library(leaflegend)

# Read in data ------------------------------------------------------------

loc <- read.csv("data/stellebord_i_bergen.csv")

ui <- fillPage(
  leafletOutput("map", width = "100%", height = "100%")
)

server <- function(input, output) {

  showModal(modalDialog(
    title = "Stellebord i Bergen",
    "Finn ditt nærmeste stellebord når du trenger det mest!",
    footer = "Send tips til: stellebord_i_bergen@protonmail.com",
    easyClose = TRUE
  ))



  output$map <- renderLeaflet({

    mymap <- leaflet() |>
      addProviderTiles(provider = "Esri.WorldStreetMap") |>
      addMarkers(data = loc,
                        layerId = ~title,
                        lng = ~longitude,
                        lat = ~latitude,
                        label = ~title,
                        clusterOptions = markerClusterOptions())

    mymap
  })

  observeEvent(input$map_marker_click, {
    id = input$map_marker_click$id
    showModal(modalDialog(
      title = loc$title[loc$title == id],
      paste0(loc$location[loc$title == id]),
      footer = modalButton("Close"),
      easyClose = TRUE
    ))
  })

}

# Run the application
shinyApp(ui = ui, server = server)
