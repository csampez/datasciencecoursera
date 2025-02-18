# U.S. NOAA's storm analysis: events harmful for population health and with great economic consequences
Carlos S. Pérez  

## Synopsis

Storms and other severe weather events can cause both public health and economic problems for communities and municipalities. 
Many severe events can result in fatalities, injuries, and property damage, and preventing such outcomes to the extent possible is a key concern.

This project involves exploring the U.S. National Oceanic and Atmospheric Administration (NOAA) storm database. 
This database tracks characteristics of major storms and weather events in the United States, including when and where they occur, as well as estimates of any fatalities, injuries, and property damage

The data analysis shows up that the severe weather events such as Flood and Tornado have major harmful consequences respect to health and wealth population. 
The steps taken into the analysisis consists in the following processes : loading, cleansing, munging (basic stats) and ploting.

The key indicators for answering about impact in population health are total number of fatalities and total number of injuries. The key indicators for answering about greatest economic consequences are total of property damage and total of crop damage regarding population wealth


```r
library(reshape2)
library(ggplot2)
library(plyr)
library(dplyr)
require(gridExtra)
library(R.utils)

converter <- function(dataset, fieldName, newFieldName) {
    totalLen <- dim(dataset)[2]
    index <- which(colnames(dataset) == fieldName)
    dataset[, index] <- as.character(dataset[, index])
    logic <- !is.na(toupper(dataset[, index]))
    dataset[logic & toupper(dataset[, index]) == "B", index] <- "9"
    dataset[logic & toupper(dataset[, index]) == "M", index] <- "6"
    dataset[logic & toupper(dataset[, index]) == "K", index] <- "3"
    dataset[logic & toupper(dataset[, index]) == "H", index] <- "2"
    dataset[logic & toupper(dataset[, index]) == "", index] <- "0"
    dataset[, index] <- as.numeric(dataset[, index])
    dataset[is.na(dataset[, index]), index] <- 0
    dataset <- cbind(dataset, dataset[, index - 1] * 10^dataset[, index])
    names(dataset)[totalLen + 1] <- newFieldName
    return(dataset)
}
```

## Data Processing

The events in the database start in the year 1950 and end in November 2011. 
In the earlier years of the database there are generally fewer events recorded, most likely due to a lack of good records. More recent years should be considered more complete. 

The data for this assignment come in the form of a comma-separated-value file compressed via the bzip2 algorithm to reduce its size. 
You can download the file from the course [web site](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2)

There is also some documentation of the database available. Here you will find how some of the variables are constructed/defined.

+ [National Weather Service Storm Data Documentation](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf)

The following code loads the data, cleans the EVTYPE variable and shows a summary for the BGN_DATE variable.


```r
	if (!"stormData.csv.bz2" %in% dir()) {
	    print("Zip File not exists, downloading...")
	    download.file("http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2", destfile = "stormData.csv.bz2")
	    bunzip2("stormData.csv.bz2", overwrite=T, remove=F)
	}

    storm_data <-read.csv("repdata_data_StormData.csv")
    storm_data$EVTYPE = toupper(storm_data$EVTYPE)
    sdata <- storm_data[!grepl("Summary", storm_data$EVTYPE), ]
	summary(as.Date(sdata$BGN_DATE, format = "%m/%d/%Y"))
```

```
##         Min.      1st Qu.       Median         Mean      3rd Qu. 
## "1950-01-03" "1995-04-20" "2002-03-18" "1998-12-27" "2007-07-28" 
##         Max. 
## "2011-11-30"
```
The next chunk calculates some summary metrics for fatalities, injuries as indicator of impact on health population. 
Also calculates some summary metrics for exponential homologated property and crop damage as indicator of economic consequences.



```r
	sdata <- converter(sdata, "PROPDMGEXP", "PDMG")	
	sdata <- converter(sdata, "CROPDMGEXP", "CDMG")

	data_etype = ddply(sdata, .(EVTYPE), summarize, mean_fatalities = mean(FATALITIES), total_fatalities = sum(FATALITIES), 
    mean_injuries = mean(INJURIES), total_injuries = sum(INJURIES), mean_pdamage = mean(PDMG), 
    total_pdamage = sum(PDMG),
    mean_cdamage = mean(CDMG), 
    total_cdamage = sum(CDMG) )

	fatalities<-head(data_etype[order(-data_etype$total_fatalities),],20)
	injuries<-head(data_etype[order(-data_etype$total_injuries),],20)
	crop<-head(data_etype[order(-data_etype$total_cdamage),],20)
	prop<-head(data_etype[order(-data_etype$total_pdamage),],20)
```

## Results 

The next code chunks shows the top 15 event types respect to the indicators of total injuries, total fatalities, total property damage and total crop damage. 


```r
fatalities_plot <- qplot(EVTYPE, data = fatalities, weight = total_fatalities, geom = "bar", binwidth = 1) + 
    scale_y_continuous("Number of Fatalities") + 
    theme(axis.text.x = element_text(angle = 45, 
    hjust = 1)) + xlab("Severe Weather Type") + 
    ggtitle("Total Fatalities by Severe Weather\n Events in the U.S.\n from 1995 - 2011")

injuries_plot <- qplot(EVTYPE, data = injuries, weight = total_injuries, geom = "bar", binwidth = 1) + 
    scale_y_continuous("Number of Injuries") + 
    theme(axis.text.x = element_text(angle = 45, 
    hjust = 1)) + xlab("Severe Weather Type") + 
    ggtitle("Total Injuries by Severe Weather\n Events in the U.S.\n from 1995 - 2011")

prop_plot <- qplot(EVTYPE, data =prop, weight = total_pdamage, geom = "bar", binwidth = 1) + 
    scale_y_continuous("Total Property Damage") + 
    theme(axis.text.x = element_text(angle = 45, 
    hjust = 1)) + xlab("Severe Weather Type") + 
    ggtitle("Total Property Damage by Severe Weather\n Events in the U.S.\n from 1995 - 2011")

crop_plot <- qplot(EVTYPE, data =crop, weight = total_cdamage, geom = "bar", binwidth = 1) + 
    scale_y_continuous("Total Crop Damage") + 
    theme(axis.text.x = element_text(angle = 45, 
    hjust = 1)) + xlab("Severe Weather Type") + 
    ggtitle("Total Crop Damage by Severe Weather\n Events in the U.S.\n from 1995 - 2011")
```

### Health Impact

The next figure shows that **tornado** is the most dangeroues weather event in terms of total fatalities and total injuries, followed by heat, flood and lightinig weather events. 
 


```r
grid.arrange(fatalities_plot, injuries_plot, ncol = 2)
```

![](PA2_template_files/figure-html/unnamed-chunk-5-1.png) 

### Economic Impact 

The next figure shows that **flood** has the greatest property damage, followed by hurricane, storms and tornado. In terms of crop damage **drought** takes the lead, followed by flood, hail, ice storm and river flood.


```r
grid.arrange(crop_plot, prop_plot, ncol = 2)
```

![](PA2_template_files/figure-html/unnamed-chunk-6-1.png) 

From these analysis, it is shown that **tornado** and **heat** are the most harmful with respect to population health, while **flood** and **drought** have the greatest economic consequences.

