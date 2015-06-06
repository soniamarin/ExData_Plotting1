library(data.table)
library(datasets)
unzip ("./data/exdata-data-household_power_consumption.zip", exdir="./data")
datos01<-read.table("./data/household_power_consumption.txt", header=TRUE, sep=";", 
          fill=TRUE, skip = 66636, nrow=2880,
          ##grep("1/2/2007", 
          ##readLines("./data/household_power_consumption.txt")),
          col.names= c("Date", "Time","Global_active_power",
          "Global_reactive_power","Voltage",
          "Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3"),
          na.strings="?", colClasses = c("factor", "factor",
          "numeric","numeric","numeric","numeric","numeric","numeric",
          "numeric"))
      datos01$Date<-as.Date(datos01$Date, "%d/%m/%Y")
      par(mfrow=c(1,1), mar=c(5.1,4.1,4.1,2.1), oma=c(0,0,0,0))
      hist(datos01$Global_active_power, main="Global Active Power", 
      xlab = "Global Active Power (kilowatts)", ylab = "Frequency", col="red")
      dev.copy(png, file= "./ExData_Plotting1/plot1.png")
      dev.off()

