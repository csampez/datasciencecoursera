#Data Loading and Transformation

cols<-c(rep("character",2), rep("numeric",7))
data<-read.table("./household_power_consumption.txt", colClasses=cols, header=TRUE, na.strings="?", sep=";") 
data$datetime<-paste(data$Date,data$Time,sep=" ")
data$datetime_s <- strptime(data$datetime, format="%d/%m/%Y %H:%M:%S")
days<-strptime(c("01/02/2007 00:00:00","03/02/2007 00:00:00"), format="%d/%m/%Y %H:%M:%S")

#extraction
progdata<-data[which((days[1]<data$datetime_s)&(data$datetime_s<days[2])),]

#plot params
plot(progdata$datetime_s,progdata$Sub_metering_1, type="l",  xlab="", ylab="Energy sub metering")
lines(progdata$datetime_s,progdata$Sub_metering_2,col="red")
lines(progdata$datetime_s,progdata$Sub_metering_3,col="blue")
legend( "topright", col=c("black","red","blue"), 
    	c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  "),
    	lty=c(1,1), lwd=c(1,1))

#save image to file 
dev.copy(png, file="plot3.png", width=480, height=480)        
dev.off()
