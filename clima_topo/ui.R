library(shiny)


shinyUI(fluidPage(
  
  
  titlePanel("Topography & temperature transects"),
  
  
  sidebarLayout(
    sidebarPanel(
      h5("This application displays land surface temperature and elevation data along a user-defined transect."),
      div(style="display:inline-block",selectInput("clim_var", "Variable:", 
                  choices=c("Min temp","Max temp"),selected ="Max temp",width='140px')),
      div(style="display:inline-block",selectInput("month", "Month:", 
                  choices=c("January","February","March","April","May","June","July","August","September","October","November","December"),selected ="July",width='100px')),
       sliderInput("lat_1",
                   "Latitude 1:",
                   min = -90,
                   max = 90,
                   value = 35),
       sliderInput("lat_2",
                   "Latitude 2:",
                   min = -90,
                   max = 90,
                   value = 50),
       sliderInput("lon",
                   "Longitude:",
                   min = -180,
                   max = 180,
                   value = 9),
      hr(),
      helpText( "Data sources:",
                br(),
                a("WorldClim 2.0 (Beta version 1)", href="http://worldclim.org",target="_blank"),
                br(),
                a("ETOPO5 World digital elevation model", href="https://www.eea.europa.eu/data-and-maps/data/world-digital-elevation-model-etopo5",target="_blank"),
                br(),
                br(),
                "Contact:",
                br(),
                "mzanon[at]gshdl.uni-kiel.de")
      ),
    
    
    mainPanel(
       plotOutput("distPlot")
    )
  )
))
