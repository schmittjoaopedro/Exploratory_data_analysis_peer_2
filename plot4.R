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

# Filter who has Coal or coal in the name
SCCReduced <- SCC %>% filter(grepl("[Cc]oal", Short.Name)) %>% select(SCC)
NEIReduced <- NEI %>% 
  filter(SCC %in% SCCReduced$SCC) %>% 
  select(year, Emissions) %>% 
  group_by(year) %>% 
  summarise_each(funs(sum(Emissions)))

# Create labels
labels <- sapply(NEIReduced$Emissions, function (el) { paste(toString(as.integer(round(el))), " ton") })

# Draw the chart
g <- ggplot(NEIReduced, aes(year, Emissions / 1000))
g + geom_point(color = "blue", size = 2) + 
  geom_line(data = NEIReduced, color = "blue") +
  xlab("Year") + 
  ylab("Emissions ton/1000") + 
  geom_text(aes(label= labels), hjust=-.25, vjust=-.5) +
  ggtitle("Emissions from coal combustion in the United States") +
  xlim(1999,2010) + 
  ylim(350,650)

# Flush the PNG file
ggsave(file="plot4.png", width = 7, height = 5)
