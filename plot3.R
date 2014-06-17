fetchNEIData <- function() {
  setwd("~")

  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile="NEI.zip")
  
  unzip("NEI.zip")
}

library("data.table")
library("ggplot2")

fetchNEIData()

emissionsData <- data.table(readRDS("summarySCC_PM25.rds"))

emissionsByYearAndType <- emissionsData[,lapply(.SD, sum), by=c("year","type"), .SDcols = c("Emissions")]

# I prefer just a line geom here because the data is "chunky", so attaching a smooth line to it
# feels as though it's giving more precisions than the shrunk down data set really has.
qplot(year, Emissions, data=emissionsByYearAndType, color=type, geom="line")

ggsave("plot3.png")