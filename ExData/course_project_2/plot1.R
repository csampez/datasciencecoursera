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
sum_df<-data.frame(NEI %>%  
	 group_by(year,Pollutant) %>% 
	 summarise( tot_emi = sum (Emissions)))

#calling base plot system
plot(sum_df$year,sum_df$tot_emi, type="b", 
	main="Total PM25-PRI Emissions", xlab="Year", ylab="Total")

#saving to file
dev.copy(png, file="plot1.png", width=480, height=480)        
dev.off()