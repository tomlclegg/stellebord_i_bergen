
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
    "Please contact with updates or new locations",
    easyClose = TRUE
  ))

  output$map <- renderLeaflet({

    quality_icons <- awesomeIconList(
      good    = makeAwesomeIcon(icon= 'check',    library = "fa", markerColor = 'green'),
      okay    = makeAwesomeIcon(icon= 'minus',    library = "fa", markerColor = 'orange'),
      poor    = makeAwesomeIcon(icon= 'close',    library = "fa", markerColor = 'red'),
      unknown = makeAwesomeIcon(icon= 'question', library = "fa", markerColor = 'lightgray'))


    mymap <- leaflet() |>
      addProviderTiles(provider = "Esri.WorldStreetMap") |>
      addAwesomeMarkers(data = loc,
                        layerId = ~title,
                        lng = ~longitude,
                        lat = ~latitude,
                        label = ~title,
                        icon = ~quality_icons[quality],
                        popup = ~paste0("Navn: ", loc$title, "<br><br>",
                                        "Lokasjon: ", loc$location, "<br><br>",
                                        "Beskrivelse: ", loc$description),
                        clusterOptions = markerClusterOptions()) |>
      addLegendAwesomeIcon(iconSet = quality_icons,
                           orientation = 'vertical',
                           title = htmltools::tags$div(
                             style = 'font-size: 20px;',
                             "Quality"),
                           labelStyle = 'font-size: 16px;',
                           position = 'bottomright')



    mymap
  })
}

# Run the application
shinyApp(ui = ui, server = server)
