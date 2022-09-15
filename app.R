
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
                        popup = ~paste0("Navn: ", loc$title, "<br><br>",
                                        "Lokasjon: ", loc$location, "<br><br>",
                                        "Beskrivelse: ", loc$description),
                        clusterOptions = markerClusterOptions())

    mymap
  })
}

# Run the application
shinyApp(ui = ui, server = server)
