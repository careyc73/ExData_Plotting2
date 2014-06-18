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

coalRows <- grepl("Coal", sourceCodes$Short.Name) | grepl("Coal", sourceCodes$EI.Sector) | grepl("Coal", sourceCodes$SCC.Level.Four)
coalSourceCodes <- data.table(subset(sourceCodes, coalRows, c("SCC", "SCC.Level.Two")), key="SCC")
emissionsFromCoal <- emissionsData[coalSourceCodes]

coalEmissionTotals <- emissionsFromCoal[,lapply(.SD, sum), by=c("year","SCC.Level.Two"), .SDcols = c("Emissions")]
coalEmissionTotals <- coalEmissionTotals[complete.cases(coalEmissionTotals)]

png("plot4.png", width=1200, height=600)

smallerPanelFontSizes <- function(which.panel, factor.levels, ...) {
  panel.rect(0, 0, 1, 1, col = "yellow",border = 1)
  panel.text(x = 0.5, y = 0.5, font=1, fontSize=8, lab=factor.levels[which.panel])
}

latticePlot <- xyplot(coalEmissionTotals$Emissions ~ coalEmissionTotals$year | coalEmissionTotals$SCC.Level.Two, xlab="Year", ylab="Emissions in PM2.5", strip=smallerPanelFontSizes)

print(latticePlot)

dev.off()