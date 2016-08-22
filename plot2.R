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

# Filter the data
filtered <- NEI %>% 
  filter(fips == "24510") %>%
  select(year, Emissions) %>% 
  group_by(year) %>% 
  summarise_each(funs(sum(Emissions)))

# Create the PNG device
png(filename = "plot2.png", width = 480, height = 480)

# Plot the graphs
bp <- barplot(
  filtered$Emissions, 
  names.arg = filtered$year, 
  xlab = "Year", 
  ylab = expression(paste("PM"[2.5]," in ton")),
  ylim = c(0, 4000),
  main = expression(paste("Total emissions of ", "PM"[2.5], " in Baltimore City, Maryland")))
labels <- sapply(filtered$Emissions, function (el) { paste(toString(as.integer(round(el))), " ton") })
text(bp, 0, labels, cex = 1, pos = 3)

# Flush the PNG file
dev.off()