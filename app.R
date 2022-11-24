
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
    footer = a("Send tips med nye sted/info", href="https://forms.gle/2i6M7EKbQK8D9oZK8"),
    easyClose = TRUE
  ))



  output$map <- renderLeaflet({

    mymap <- leaflet() |>
      addProviderTiles(provider = "Esri.WorldStreetMap") |>
      addMarkers(data = loc,
                 layerId = ~title,
                 lng = ~longitude,
                 lat = ~latitude,
                 label = ~title)

    mymap
  })

  observeEvent(input$map_marker_click, {
    id = input$map_marker_click$id
    showModal(modalDialog(
      title = loc$title[loc$title == id],
      HTML("<b>Lokasjon</b>",
           "<br>",
           loc$location[loc$title == id],
           "<br>","<br>",
           "<b>Beskrivelse</b>",
           "<br>",
           loc$description[loc$title == id]),
      footer = modalButton("Close"),
      easyClose = TRUE
    ))
  })

}

# Run the application
shinyApp(ui = ui, server = server)
