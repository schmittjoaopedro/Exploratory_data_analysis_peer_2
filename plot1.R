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

plot(
  filtered$year, 
  log10(filtered$Emissions), 
  xlab = "Year", 
  ylab = "Emissions in TON (total)", 
  pch = 19, col = "blue", 
  main = "Log10 ammount of emission by Year.",
  cex = 1.5,
  ylim = c(6.5,7.5))
text(
  filtered$year + 0.1, 
  log10(filtered$Emissions) + 0.1, 
  labels = filtered$year)
