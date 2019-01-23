library(shiny)
library(jsonlite)

ui <- fluidPage(
  
  titlePanel("Airbnb Listing Price Predictor"),
  
  sidebarLayout(
    
    sidebarPanel(
      textInput("persons", "Persons", NULL),
      textInput("bedrooms", "Bedrooms", NULL ),
      textInput("bathrooms", "Bathrooms", NULL ),
      
      actionButton("predictButton", "Predict")
    ),
    
    mainPanel(
      textOutput(outputId = "listingPrice")
    )
  )
)

scrape <- fromJSON("airbnb-scrape-1.json")
scrape_rotterdam <- scrape[!(scrape$city!="Rotterdam"),]

priceModel <- lm(price~bedrooms+bathrooms+person_capacity, scrape_rotterdam)

server <- function(input, output){

  predictPrice <- eventReactive(input$predictButton, {
    inputData <- data.frame("person_capacity" = as.integer(input$persons), "bedrooms" = as.integer(input$bedrooms), "bathrooms" = as.integer(input$bathrooms))
    predict(priceModel, inputData)  
  })
  
  output$listingPrice <- renderText(
    predictPrice()
  )
}

shinyApp(ui, server)