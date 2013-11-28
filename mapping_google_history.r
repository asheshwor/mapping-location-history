#Load packages
library(maps)
library(ggmap)
library(mapdata)
library(mapproj)
library(maptools)
library(RColorBrewer)
library(classInt)
library(rgdal)
library(scales)
#Setting up directory and file list
dirName <- "//ASH-desktop/Users/asheshwor/Documents/R_git/history_KML/"
fileList <- c(dir(dirName))
numFiles <- length(fileList)
#Reading coordinates from KML file downloaded
#  from google location history
lat <- numeric(0)
lon <- numeric(0)
tStart <- Sys.time() #track time
# WARNING!! takes a while to loop through
#took ~10 min for 191,355 sets in 12 months of history (4 gb ram win 7 64 bit)
#took 1.4 hrs for the same on my old toshiba (3 gb ram win 7 64 bit)
for (i in 1:numFiles) {
  dirTemp <- paste(dirName, fileList[i], sep="")
  hist <- getKMLcoordinates(dirTemp) #read KML file
  maxl <- length(hist)
  for (j in 1:maxl) {
    hist.0 <- hist[[j]]
    lat <- c(lat, hist.0[2])
    lon <- c(lon, hist.0[1])
  }
}
tFinish <- Sys.time()
difftime(tFinish, tStart) #calculating time it took to read
#convert to a dataframe
hist.df <- data.frame(lon, lat)
#Write extracted coordinates to a csv file
write.csv(hist.df, file="//ASH-desktop/Users/asheshwor/Documents/R_git/LocationHistory.csv")
#Reading coordinates
hist.df2 <- read.csv(file="//ASH-desktop/Users/asheshwor/Documents/R_git/LocationHistory.csv", header=TRUE)
hist.df2 <- hist.df2[,-1] #dropping first column
#rounding off data for density plots
hist.df3 <- hist.df2
hist.df3$lon <- round(hist.df3$lon, 4)
hist.df3$lat <- round(hist.df3$lat, 4)
#plotting the points
adl <- "Adelaide, South Australia" #create empty map
adl.city <- qmap(adl, zoom=14, maptype="roadmap", legend="topleft") #google roadmap
png("Sample01.png",720,720)
adl.city + geom_point(aes(x = lon, y = lat), 
                      data = hist.df2, 
                      color = couleur[8], alpha = 0.5)
dev.off()
adl.city <- qmap(adl, zoom=14, maptype="satellite", legend="topleft") #google satellite
png("Sample02.png",720,720)
adl.city + geom_point(aes(x = lon, y = lat), 
                      data = hist.df2, 
                      color = couleur[8], alpha = 0.5)
dev.off()
adl2 <- "Adelaide, South Australia"
adl2.city <- qmap(adl2, zoom=14, source = "stamen", maptype="toner", legend="topleft")
png("Sample03.png",720,720)
adl2.city + geom_point(aes(x = lon, y = lat), 
                       data = hist.df2, 
                       color = couleur[8], alpha = 0.5)
dev.off()
adl2.city <- qmap(adl2, zoom=14, source = "stamen", maptype="watercolor", legend="topleft")
png("Sample04.png",720,720)
adl2.city + geom_point(aes(x = lon, y = lat), 
                       data = hist.df2, 
                       color = couleur[8], alpha = 0.5)
dev.off()