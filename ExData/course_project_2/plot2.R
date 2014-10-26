library(plyr)
library(dplyr)

# fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
# download.file(fileUrl, destfile = "exdata_cp2.zip", method = "curl")
# unzip("./exdata_cp2.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

balt_df<-data.frame(NEI %>%  
	 group_by(year,Pollutant,fips) %>% 
	 summarise( tot_emi = sum (Emissions)) %>% filter(fips=="24510"))

plot(balt_df$year,balt_df$tot_emi, type="b", main="Baltimore City Emissions", xlab="Year", ylab="Total PM-25-PRI")

#saving to file
dev.copy(png, file="plot2.png", width=480, height=480)        
dev.off()

