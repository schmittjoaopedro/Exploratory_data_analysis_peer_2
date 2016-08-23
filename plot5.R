# Libraries
library(dplyr)
library(ggplot2)
library(reshape2)

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

# Organize the data
NEI <- NEI %>% mutate(type = as.factor(type), year = as.factor(year))

#Filter the data
filtered <- NEI %>%
    filter(fips == "24510" & type == "ON-ROAD") %>% 
    select(year, Emissions)
dmelt <- melt(filtered, c("year"))
data <- dcast(dmelt, year ~ variable, sum)

g <- ggplot(data, aes(x = factor(year), y = Emissions))
g + geom_bar(stat = "identity") + 
    xlab("Year") + 
    ylab(expression(paste("Emission of PM"[2.5], " in ton"))) +
    ggtitle(expression(paste("Emission of PM"[2.5]," in Baltimore City, Maryland by Motor Vehicle")))

ggsave(filename = "plot5.png", width = 8, height = 6)