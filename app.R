
library(shiny)
library(leaflet)
library(leaflegend)




# Read in data ------------------------------------------------------------


loc <- read.csv("data/baby_sted_i_bergen.csv")


ui <- fillPage(

  leafletOutput("map", width = "100%", height = "100%")
)

server <- function(input, output) {

  output$map <- renderLeaflet({

    quality_icons <- awesomeIconList(
      good    = makeAwesomeIcon(icon= 'xmark', markerColor = 'green',  iconColor = 'black'),
      okay    = makeAwesomeIcon(icon= 'xmark', markerColor = 'orange', iconColor = 'black'),
      poor    = makeAwesomeIcon(icon= 'xmark', markerColor = 'red',    iconColor = 'black'),
      unknown = makeAwesomeIcon(icon= 'xmark', markerColor = 'lightgray',   iconColor = 'black'))


    mymap <- leaflet() |>
      addProviderTiles(provider = "Esri.WorldStreetMap") |>
      addAwesomeMarkers(data = loc,
                 layerId = ~title,
                 lng = ~longitude,
                 lat = ~latitude,
                 label = ~title,
                 icon = ~quality_icons[quality],
                 popup = ~sprintf("Navn: %s<br><br>Lokasjon: %s<br><br>Beskrivelse: %s<br><br><a href = '%s'> Google maps </a>",
                                  loc$title,
                                  loc$location,
                                  loc$description,
                                  loc$google_maps),
                 clusterOptions = markerClusterOptions(showCoverageOnHover = FALSE)) |>
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
