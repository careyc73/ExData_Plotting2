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
vehicleEmissionsInBaltOrLA <- subset(emissionsData[vehicleSourceCodes], fips == "24510" | fips == "06037")

totalByTypeAndLocation <- vehicleEmissionsInBaltOrLA[,lapply(.SD, sum), by=c("year","Data.Category","fips"), .SDcols = c("Emissions")]

#Little column name cleanup for clarity in the plot
totalByTypeAndLocation[fips == "06037"]$fips = "Los Angeles"
totalByTypeAndLocation[fips == "24510"]$fips = "Baltimore"
setnames(totalByTypeAndLocation, c("year", "Vehicle.Category", "Location", "Emissions"))

ggplot(totalByTypeAndLocation, 
       aes(x=year, y=Emissions, colour=Location, shape = Vehicle.Category,
       group=interaction(Location, Vehicle.Category))) + geom_point(size=2) + geom_line() +
       theme(text = element_text(size=5))

ggsave("plot6.png", width=4, height=2)