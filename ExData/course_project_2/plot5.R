#library request
library(plyr)
library(dplyr)

#data_download
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile = "exdata_cp2.zip", method = "curl")
unzip("./exdata_cp2.zip")

#reading data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#transformation
motor_df<-NEI[NEI$SCC %in% SCC$SCC[grep("Vehicle",SCC$Short.Name)],]

motor_sum_df<-data.frame(motor_df %>% 
     filter(fips=="24510") %>%
	 group_by(year,Pollutant) %>% 
	 summarise( tot_emi = sum (Emissions)))

#calling base plot system
plot(motor_sum_df$year,motor_sum_df$tot_emi, type="b", main="Total Motor PM25-PRI Emissions in BC", xlab="Year", ylab="Total PM25-PRI emissions")

#saving to file
dev.copy(png, file="plot5.png", width=480, height=480)        
dev.off()