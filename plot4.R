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
## dividing the window
    par(mfrow=c(2,2), mar=c(5.1,4.1,4.1,2.1), oma=c(0,0,0,0))
############################################
############ plot1
    y<-datos01$Global_active_power
    plot(y, type="n", xaxt="n", ann=FALSE, cex=0.6)
## Adding lines
    lines(y, type="l" )
## Adding labels
    par(tcl= -0.4)
    x<-c("Thu", "Fri", "Sat")
    axis(1, at=seq(1, 2880, by=1420),labels=x,lwd=0,lwd.ticks=1,
    las=0, pos=0,cex.axis=0.6, cex.lab=0.3)
    mtext("Global Active Power", side=2, line=3, cex=0.7,las=0)
###########################################
############ plot2
    y<-datos01$Voltage
    plot (y, type="n", xaxt="n", ann=FALSE)
## Adding lines
    lines (y, type="l" )
## Adding labels
    par(tcl= -0.4)
    xx<-c("Thu", "Fri", "Sat")
    axis(1, at=seq(0, 2880, by=1440), labels=xx,lwd=1,lwd.ticks=1, cex=0.6, las=0,
    cex.lab=0.3)
    mtext("Voltage", side=2, line=3, cex=0.7,las=0)
    mtext("datetime", side=1, line=3, cex=0.6)
##########################################
############ plot3
    y<-datos01$Sub_metering_2
    w<-datos01$Sub_metering_1
    z<-datos01$Sub_metering_3
    plot(w, type="n", xaxt="n", ann=FALSE)
## Adding lines
    lines(w, type="l", col="black")
    lines(y, type="l", col="red")
    lines(z, type="l", col="blue")
## Adding labels
    par(tcl= -0.4)
    x<-c("Thu", "Fri", "Sat")
    axis(1, at=seq(1, 2880, by=1420),labels=x,lwd=0,lwd.ticks=1,
    las=0, pos=0,cex.axis=0.6, cex.lab=0.6)
    mtext("Energy sub metering", side=2, line=3, cex=0.7,las=0)
    legend("topright",  inset=0.1,
       c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), bty="n",
       , horiz=FALSE, cex=0.5, x.intersp = 0.5, y.intersp=0.4, 
       lty=c(1,1,1), # gives the legend appropriate symbols (lines)
       
       lwd=c(1.5,1.5,1.5),col=c("black","red","blue"), seg.len=1) 
# gives the legend lines the correct color and width
# add solid horizontal lines at y=1,5,7 
##########################################
############ plot4
    y<-datos01$Global_reactive_power
    plot(y, type="n", xaxt="n", yaxt="n", ann=FALSE)
## Adding lines
    lines(y, type="l" )
## Adding labels
    par(tcl= -0.4)
    x<-c("Thu", "Fri", "Sat")
    xxx<-c("0.0","0.1", "0.2", "0.3", "0.4", "0.5")
    axis(1, at=seq(1, 2880, by=1420),labels=x,lwd=0,lwd.ticks=1,
     las=0, pos=0,cex.axis=0.6, cex.lab=0.3)
    axis(2, at=seq(0, 0.5, by=0.1),labels=xxx,lwd=0,lwd.ticks=1,
     las=0, pos=1,cex.axis=0.6, cex.lab=0.3)
    mtext("Global Reactive Power", side=2, line=3, cex=0.7,las=0)
    mtext("datetime", side=1, line=2, cex=0.6)
#####################################
###########plotting in file png
    dev.copy(png, file= "./ExData_Plotting1/plot4.png")
    dev.off()