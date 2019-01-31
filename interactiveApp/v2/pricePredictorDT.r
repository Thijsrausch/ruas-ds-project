#install.packages("rpart")
#install.packages("shiny")
#install.packages("jsonlite")
#install.packages("purrr")
#install.packages("dplyr")

library("shiny")
library("jsonlite")
library("dplyr")
library("purrr")
library("rpart")

ui <- fluidPage(
  
  titlePanel("Airbnb Listing Price Predictor"),
  
  sidebarLayout(
    
    sidebarPanel(
      textInput("persons", "Persons", NULL),
      textInput("bedrooms", "Bedrooms", NULL ),
      textInput("bathrooms", "Bathrooms", NULL ),
      textInput("beds", "Beds", NULL ),
      
      checkboxInput("amenity42", "lock_on_bedroom_door", FALSE),
      checkboxInput("amenity5", "ac", FALSE),
      checkboxInput("amenity116", "bedroom_wide_doorway", FALSE),
      checkboxInput("amenity44", "hangers", FALSE),
      checkboxInput("amenity1", "tv", FALSE),
      checkboxInput("amenity37", "first_aid_kit", FALSE),
      checkboxInput("amenity25", "jacuzzi", FALSE),
      checkboxInput("amenity66", "childrens_books_and_toys", FALSE),
      checkboxInput("amenity113", "path_to_entrance_lit_at_night", FALSE),
      checkboxInput("amenity9", "free_parking", FALSE),
      checkboxInput("amenity33", "washer", FALSE),
      checkboxInput("amenity2", "cable", FALSE),
      
      actionButton("predictButton", "Predict")
    ),
    
    mainPanel(
      h5("Linear Model Output:"),
      textOutput(outputId = "listingPriceLinear"),
      h5("Decision Tree Output:"),
      textOutput(outputId = "listingPriceDT"),
      h5("Amenities Decision Tree Output:"),
      textOutput(outputId = "amenityPriceDT"),
      h4("ensemble predicion:"),
      textOutput(outputId = "ensemblePrice"),
      h5("naive distence:"),
      textOutput(outputId = "distancePrice")
    )
  )
)

scrape <- fromJSON("airbnb-scrape-1.json")
scrape_rotterdam <- scrape[!(scrape$city!="Rotterdam"),]
priceName <- c("<14", "14<52", "52<85", "85<125", "125<275", "275+")
priceNumber <- c(14, 33, 68.5, 105, 200, 275)


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


# ------ amenities model
amenities <- unique(flatten(scrape_rotterdam$amenity_ids))

amenities_scrape <- scrape_rotterdam %>% select(amenity_ids, priceClass)

for (row in 1:nrow(scrape_rotterdam)){
  amenities_list <- unlist(amenities_scrape[row,]$amenity_ids, use.names=FALSE)
  for (am in amenities) {
    amenities_scrape[row, paste("amenity", am, sep = "")] <- am %in% amenities_list
  }
  amenities_scrape
}

amenities_scrape <- amenities_scrape %>% select(priceClass, amenity42, amenity5, amenity116, amenity44, amenity1, amenity37, amenity25, amenity66, amenity113, amenity9, amenity33, amenity2)

amenitiesModelDT <- rpart(priceClass~., amenities_scrape, method="class")
rpart.plot(amenitiesModelDT, extra=101)


#---------- distance

distance_scrape <- scrape_rotterdam %>% select(bathrooms, bedrooms, beds, person_capacity, price)


# -------- output 
liniarPrediction <- function(input) {
  inputData <- data.frame("person_capacity" = as.integer(input$persons), "bedrooms" = as.integer(input$bedrooms), "bathrooms" = as.integer(input$bathrooms))
  predict(priceModelLinear, inputData)  
}

DTPrediction <- function(input) {
  inputData <- data.frame("person_capacity" = as.integer(input$persons), "bedrooms" = as.integer(input$bedrooms), "beds" = as.integer(input$beds), "bathrooms" = as.integer(input$bathrooms))
  predict(priceModelDT, inputData, type="class")
}

amenitiesPrediction <- function(input) {
  
  inputData <- data.frame(
    "amenity42" = input$amenity42,
    "amenity5" = input$amenity5,
    "amenity116" = input$amenity116,
    "amenity44" = input$amenity44,
    "amenity1" = input$amenity1,
    "amenity37" = input$amenity37,
    "amenity25" = input$amenity25,
    "amenity66" = input$amenity66,
    "amenity113" = input$amenity113,
    "amenity9" = input$amenity9,
    "amenity33" = input$amenity33,
    "amenity2" = input$amenity2
  )
  predict(amenitiesModelDT, inputData, type="class")
}

distancPredition <- function(input){
  for(row in 1:nrow(distance_scrape)){
    data <- distance_scrape[row,]
    distance_scrape[row, "distance"] <- abs(data$bathrooms - as.integer(input$bathrooms) + data$bedrooms - as.integer(input$bedrooms) + data$beds - as.integer(input$beds) + data$person_capacity - as.integer(input$persons))
  }
  distance_scrape[distance_scrape$distance == min(distance_scrape$distance, na.rm=T), ]
}

# ----- real output

ensemblePrediction <- function(input) {
  inputData <- data.frame("person_capacity" = as.integer(input$persons), "bedrooms" = as.integer(input$bedrooms), "beds" = as.integer(input$beds), "bathrooms" = as.integer(input$bathrooms))
  predict(priceModelDT, inputData, type="class")
}


server <- function(input, output){
  
  predictLinear <- eventReactive(input$predictButton, {
    liniarPrediction(input)
  })
  
  output$listingPriceLinear <- renderText(
    predictLinear()
  )
  
  
  #-------------
  

  predictDT <- eventReactive(input$predictButton, {
    prediction <- DTPrediction(input)
    index <- as.numeric(prediction)
    priceName[index]
  })
  
  output$listingPriceDT <- renderText(
    predictDT()
  )
  
  
  #-------------
  
  
  predictAmenitiesDT <- eventReactive(input$predictButton, {
    prediction <- amenitiesPrediction(input)
    index <- as.numeric(prediction)
    priceName[index]
  })
  
  output$amenityPriceDT <- renderText(
    predictAmenitiesDT()
  )
  
  #-------------
  
  predictEnsemble <- eventReactive(input$predictButton, {
    mean(c(    
      liniarPrediction(input),
      priceNumber[as.numeric(DTPrediction(input))],
      priceNumber[as.numeric(amenitiesPrediction(input))]
    ))
  })
  
  output$ensemblePrice <- renderText(
    predictEnsemble()
  )
  
  #-------------
  
  
  predictDistance <- eventReactive(input$predictButton, {
    prediction <- distancPredition(input)
    paste("found mean price:", mean(prediction[,'price'], na.rm = T), " with distance ", mean(prediction[,'distance'], na.rm = T), ". min: ", min(prediction[,'price'], na.rm = T), "  max: ", max(prediction[,'price'], na.rm = T), sep = "")
  })
  
  output$distancePrice <- renderText(
    predictDistance()
  )
  
}

shinyApp(ui, server)