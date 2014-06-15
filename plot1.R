fetchNEIData <- function() {
  setwd("~")

  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile="NEI.zip")
  
  unzip("NEI.zip")
}

fetchNEIData()

emissionsData <- data.table(readRDS("summarySCC_PM25.rds"))
sourceClassifications <- data.table(readRDS("Source_Classification_Code.rds"))

emissionsSummedByYear <- emissionsData[,lapply(.SD, sum), by=year, .SDcols = c("Emissions")]

png(file="plot1.png")

plot(emissionsSummedByYear$year, emissionsSummedByYear$Emissions, type="l", ylab="Total Emissions in PM2.5", xlab="Year")

dev.off()