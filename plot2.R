fetchNEIData <- function() {
  setwd("~")

  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile="NEI.zip")
  
  unzip("NEI.zip")
}

library("data.table")

fetchNEIData()

emissionsData <- subset(data.table(readRDS("summarySCC_PM25.rds")), fips=="24510", c("Emissions", "year"))

emissionsSummedByYear <- emissionsData[,lapply(.SD, sum), by=year, .SDcols = c("Emissions")]

png(file="plot2.png")

plot(emissionsSummedByYear$year, emissionsSummedByYear$Emissions, type="l", ylab="Total Emissions in PM2.5 (Baltimore)", xlab="Year")

dev.off()