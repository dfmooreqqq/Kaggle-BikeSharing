# You are provided hourly rental data spanning two years. For this competition,
# the training set is comprised of the first 19 days of each month, while the
# test set is the 20th to the end of the month. You must predict the total count
# of bikes rented during each hour covered by the test set, using only
# information available prior to the rental period.
# 
# Data Fields
# 
# datetime - hourly date + timestamp  
# season -  1 = spring, 2 = summer, 3 = fall, 4 = winter 
# holiday - whether the day is considered a holiday
# workingday - whether the day is neither a weekend nor holiday
# weather -
#   1: Clear, Few clouds, Partly cloudy, Partly cloudy 
#   2: Mist + Cloudy, Mist + Broken clouds, Mist + Few clouds, Mist 
#   3: Light Snow, Light Rain + Thunderstorm + Scattered clouds, Light Rain + Scattered clouds 
#   4: Heavy Rain + Ice Pallets + Thunderstorm + Mist, Snow + Fog 
# temp - temperature in Celsius
# atemp - "feels like" temperature in Celsius
# humidity - relative humidity
# windspeed - wind speed
# casual - number of non-registered user rentals initiated
# registered - number of registered user rentals initiated
# count - number of total rentals



## Load data
packages <- c("gdata", "ggplot2", "data.table", "lattice", "lubridate", "reshape2", "rms", "lasso")
packages <- lapply(packages, FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
        install.packages(x)
        library(x, character.only = TRUE)
    }
})

# Set working directory
workingdir<-paste("C:\\Users", Sys.getenv("USERNAME"), "Documents\\GitHub\\Kaggle-BikeSharing", sep = "\\")
setwd(workingdir)


datadir = "./data/"
patternfilestoread = ".csv"

k=0

for (j in list.files(path = datadir, pattern=patternfilestoread)){
    k<-k+1
    #filestr = paste(j, sep="_")
    filestr = strsplit(j,".csv")
    filestr = filestr[[1]]
    assign(filestr,read.csv(paste(datadir,j, sep="\\")))
}


## class changes for factors
train$datetime<-as.POSIXct(train$datetime)
train$season<-as.factor(train$season)
train$holiday<-as.factor(train$holiday)
train$workingday<-as.factor(train$workingday)
train$weather<-as.factor(train$weather)

train$hour<-hour(train$datetime)
train$month<-month(train$datetime)
train$day<-day(train$datetime)
train$year<-year(train$datetime)

train$casual<-NULL
train$registered<-NULL
train$datetime<-NULL

#Initial plotting
qplot(datetime, count, data = train)

traindt<-as.data.table(train)
fit<-glm(count~.^2, data = traindt)


## class changes for factors
test$datetime<-as.POSIXct(test$datetime)
test$season<-as.factor(test$season)
test$holiday<-as.factor(test$holiday)
test$workingday<-as.factor(test$workingday)
test$weather<-as.factor(test$weather)

test$hour<-hour(test$datetime)
test$month<-month(test$datetime)
test$day<-day(test$datetime)



#predict
