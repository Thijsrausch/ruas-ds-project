#install.packages("rpart")
#install.packages("shiny")
#install.packages("jsonlite")


library("shiny")
library("jsonlite")
library("rpart")

ui <- fluidPage(
  
  titlePanel("Airbnb Listing Price Predictor"),
  
  sidebarLayout(
    
    sidebarPanel(
      textInput("persons", "Persons", NULL),
      textInput("bedrooms", "Bedrooms", NULL ),
      textInput("bathrooms", "Bathrooms", NULL ),
      textInput("beds", "Beds", NULL ),
      
      actionButton("predictButton", "Predict")
    ),
    
    mainPanel(
      h5("Linear Model Output:"),
      textOutput(outputId = "listingPriceLinear"),
      h5("Decision Tree Output:"),
      textOutput(outputId = "listingPriceDT")
    )
  )
)

scrape <- fromJSON("airbnb-scrape-1.json")
scrape_rotterdam <- scrape[!(scrape$city!="Rotterdam"),]

priceName <- c("<14", "14<52", "52<85", "85<125", "125<275", "275+")

# ------ Linear model
priceModelLinear <- lm(price~bedrooms+bathrooms+person_capacity, scrape_rotterdam)


# ------ dt model
set.seed(43)
determineClass <- function(price) {
  if (price < 14)
  {1}
  else if (14 <= price && price < 52)
  {2}
  else if (52 <= price && price < 85)
  {3}
  else if (85 <= price && price < 125)
  {4}
  else if (125 <= price && price < 275)
  {5}
  else
  {6}  
}

for(row in 1:nrow(scrape_rotterdam)){
  scrape_rotterdam[row, "priceClass"] <- determineClass(scrape_rotterdam[row, "price"])
}

priceModelDT <- rpart(priceClass~person_capacity+bedrooms+bathrooms+beds, scrape_rotterdam, method="class")





server <- function(input, output){
  
  predictLinear <- eventReactive(input$predictButton, {
    inputData <- data.frame("person_capacity" = as.integer(input$persons), "bedrooms" = as.integer(input$bedrooms), "bathrooms" = as.integer(input$bathrooms))
    predict(priceModelLinear, inputData)  
  })
  
  output$listingPriceLinear <- renderText(
    predictLinear()
  )

  predictDT <- eventReactive(input$predictButton, {
    inputData <- data.frame("person_capacity" = as.integer(input$persons), "bedrooms" = as.integer(input$bedrooms), "beds" = as.integer(input$beds), "bathrooms" = as.integer(input$bathrooms))
    prediction <- predict(priceModelDT, inputData, type="class")
    index <- as.numeric(prediction)-1
    priceName[index]
  })
  
  output$listingPriceDT <- renderText(
    predictDT()
  )
}

shinyApp(ui, server)