# Libraries
library(dplyr)

# Common files and URI's
urlFile <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
zipFile <- "data.zip"
sourceFile <- "Source_Classification_Code.rds"
summaryFile <- "summarySCC_PM25.rds"

# Obtain the data in the files
if(!file.exists(zipFile)) {
  download.file(urlFile, destfile = zipFile)
}
if(!file.exists(sourceFile) | !file.exists(summaryFile)) {
  unzip(zipFile) 
}

# Read the files
NEI <- readRDS(summaryFile)
SCC <- readRDS(sourceFile)

filtered <- NEI %>% select(year, Emissions) %>% group_by(year) %>% summarise_each(funs(sum(Emissions)))

bp <- barplot(
  filtered$Emissions / 1000, 
  names.arg = filtered$year, 
  xlab = "Year", 
  ylab = expression(paste("Emissions","PM"[2.5],"in (ton/1000)")))
text(bp, 0, paste(filtered$Emissions, " ton"), cex = 1, pos = 3)