library(ggplot2)
library(plyr)
library(dplyr)

# fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
# download.file(fileUrl, destfile = "exdata_cp2.zip", method = "curl")
# unzip("./exdata_cp2.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

balt_df<-data.frame(NEI %>%  
	 group_by(year,Pollutant,fips,type) %>% 
	 summarise( tot_emi = sum (Emissions)) %>% filter(fips=="24510"))


ggplot(balt_df, aes(x=factor(year),y=tot_emi,group=type)) + geom_line(aes(colour=type)) +
ggtitle("Baltimore City Emissions") + labs(x = "Year", y="Total PM25-PRI")

#saving to file
dev.copy(png, file="plot3.png", width=480, height=480)        
dev.off()

