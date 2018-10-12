//Test data from insideairbnb.com/get-the-data.html
jsonData <- read.csv(file = "listingsSep18.csv", header = TRUE, sep = ",")
str(jsonData)
uniqueValues <- unique(jsonData$neighbourhood)