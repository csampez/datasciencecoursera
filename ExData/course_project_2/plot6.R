library(ggplot2)
library(plyr)
library(dplyr)

# fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
# download.file(fileUrl, destfile = "exdata_cp2.zip", method = "curl")
# unzip("./exdata_cp2.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

motor_df<-NEI[NEI$SCC %in% SCC$SCC[grep("Vehicle",SCC$Short.Name)],]

motor_sum_df<-data.frame(motor_df %>%
	 group_by(year,Pollutant,fips) %>% 
	 filter(fips %in% c("24510","06037")) %>%
	 summarise( tot_emi = sum (Emissions)))

ggplot(motor_sum_df, aes(x=year, y=tot_emi, group=fips))+ geom_line(aes(colour=fips)) +
ggtitle("Vehicle sources comparison BC vs LA") + labs(x = "Years", y="Total PM25-PRI emissions") +
scale_colour_manual (values=c("blue","red"), labels=c("Los Angeles County","Baltimore City"))

#saving to file
dev.copy(png, file="./plot6.png", width=480, height=480)        
dev.off()