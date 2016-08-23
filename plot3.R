# Libraries
library(dplyr)
library(ggplot2)

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

# Prepare the data
filtered <- NEI %>% 
  filter(fips == "24510") %>%
  mutate(type = as.factor(type), year = as.factor(year)) %>%
  select(year, type, Emissions)

# Plot the graphs
g <- ggplot(filtered, aes(x = year, y = log10(Emissions), fill = type))
g + facet_grid(. ~ type) + 
  geom_boxplot() + 
  xlab("Year") +
  ylab(expression(paste("Log"[10], " of Emissions PM"[2.5]))) +
  ggtitle('Emissions by Type in Baltimore City, Maryland') +
  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))

# Flush the PNG file
ggsave(file="plot3.png", width = 7, height = 5)