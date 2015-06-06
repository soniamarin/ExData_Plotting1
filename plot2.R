library(data.table)
library(datasets)
library(dplyr)
library(plyr)
library(stringr)
##Reading the data
    unzip ("./data/exdata-data-household_power_consumption.zip", exdir="./data")
    datos01<-read.table("./data/household_power_consumption.txt", header=TRUE, 
    sep=";", fill=TRUE, skip = 66636, nrow=2880,
                    ##grep("1/2/2007", 
                    ##readLines("./data/household_power_consumption.txt")),
    col.names= c("Date", "Time","Global_active_power",
    "Global_reactive_power","Voltage",
    "Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3"),
    na.strings="?", colClasses = c("factor", "factor",
    "numeric","numeric","numeric","numeric","numeric","numeric",
    "numeric"))
    ##Creating new columns for graphics
        datos01$Date<-as.Date(datos01$Date, "%d/%m/%Y")
        datos01$Times<-strptime(datos01$Time,"%H:%M:%S")
        datos01<- mutate(datos01, weekday=weekdays(Date))
        datos01<- mutate(datos01, weekdaynum=as.numeric(substr(Date, 9,10)))
        datos01<- mutate(datos01, horas=substr(Time, 1, 2))
        datos01<- mutate(datos01, hora=as.numeric(horas))
        datos01<- mutate(datos01, horanew=(hora+24*(weekdaynum-1)) )
        datos01<- mutate(datos01, horanew=(horas[1:1440]))
        datos01<- mutate(datos01, timenew=paste(horanew,substr(Time,3,10), sep=""))
    ##write.table(datos01, "electricity.txt", row.names=FALSE)
    ##head(datos01)
    ##tail(datos01)
    ## Creating the plot without x axis and points
    ## class(datos01$Global_active_power)
     par(mfrow=c(1,1), mar=c(5.1,4.1,4.1,2.1), oma=c(0,0,0,0))
     y<-datos01$Global_active_power
     plot(y, type="n", xaxt="n", ann=FALSE)
    ## Adding lines
     lines(y, type="l" )
    ## Adding labels
      par(tcl= -0.4)
        x<-c("Thu", "Fri", "Sat")
        axis(1, at=seq(1, 2880, by=1420),labels=x,lwd=0,lwd.ticks=1,
             las=0, pos=0,cex.axis=0.8)
        mtext("Global Active Power (kilowatts)", side=2, line=3, cex=0.7,las=0)
         dev.copy(png, file= "./ExData_Plotting1/plot2.png")
        dev.off()