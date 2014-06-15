fetchNEIData <- function() {
  setwd("~")

  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile="NEI.zip")
  
  unzip("NEI.zip")
}

fetchNEIData()

emmissionsData <- readRDS("summarySCC_PM25.rds")
sourceClassifications <- readRDS("Source_Classification_Code.rds")
