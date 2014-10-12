#Data Loading and Transformation 

cols<-c(rep("character",2), rep("numeric",7))
data<-read.table("./household_power_consumption.txt", colClasses=cols, header=TRUE, na.strings="?", sep=";") 
data$datetime<-paste(data$Date,data$Time,sep=" ")
data$datetime_s <- strptime(data$datetime, format="%d/%m/%Y %H:%M:%S")
days<-strptime(c("01/02/2007 00:00:00","03/02/2007 00:00:00"), format="%d/%m/%Y %H:%M:%S")

#extraction
progdata<-data[which((days[1]<data$datetime_s)&(data$datetime_s<days[2])),]

#plot params
hist(progdata$Global_active_power, freq=TRUE, 
									xlab="Global Active Power (kilowatts)", 
									ylab="Frequency", 
									main="Global Active Power" ,
								 	col="Red")
#saving to file
dev.copy(png, file="./plot1.png", width=480, height=480)        
dev.off()
