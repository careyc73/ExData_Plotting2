fetchNEIData <- function() {
  setwd("~")

  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile="NEI.zip")
  
  unzip("NEI.zip")
}

library("data.table")
library("lattice")

fetchNEIData()

emissionsData <- data.table(readRDS("summarySCC_PM25.rds"), key="SCC")
sourceCodes <- data.table(readRDS("Source_Classification_Code.rds"), key="SCC")

motorVehiclesLogicalVector <- grepl("Onroad", sourceCodes$Data.Category) | grepl("Nonroad", sourceCodes$Data.Category)
vehicleSourceCodes <- data.table(subset(sourceCodes, motorVehiclesLogicalVector, c("SCC", "Data.Category")), key="SCC")
vehicleEmissionsInBaltimore <- subset(emissionsData[vehicleSourceCodes], fips == "24510")

baltimoreVehicleTotals <- vehicleEmissionsInBaltimore[,lapply(.SD, sum), by=c("year","Data.Category"), .SDcols = c("Emissions")]

qplot(year, Emissions, data=baltimoreVehicleTotals, color=Data.Category, geom="line")

ggsave("plot5.png")