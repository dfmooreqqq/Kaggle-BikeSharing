## Load data
packages <- c("gdata")
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
    filestr = paste(j, sep="_")
    assign(filestr,read.csv(paste(datadir,j, sep="\\")))
}