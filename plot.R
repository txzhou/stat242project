#This Script will make the ggplot wrapper
library(ggplot2)
library(reshape2)

rm(list=ls())

path <- "/Network/Servers/mars.ucdavis.edu/Volumes/UHome/Xtra/humber/STAT_242/Project"

df <- read.csv(paste0(path,"/clean_water_consum"))

#First I will subsample the data.  Some data is a double count.  For example Ir=Ir.C+Ir.G (i.e. Irrigation = Irrigation Crops + Irrigation Golf)
df <- df[ ,c("County", "PS", "Do.self","In", "Ir.C", "Ir.G", "L", "A", "M", "T")]

#To use ggplot, I need to reshape the data from wide to long.
df.long <- melt(df, id = "County")

names(df.long)[2:3] <- c("Source","Water")

#plot
gg.wrapper <- function(county.name){
plot.water <- ggplot(data=df.long[df$County==county.name,], aes(x=Source,y=Water, fill =Source ))+
                geom_bar(stat="identity")+
                theme_bw()+
                scale_y_continuous("Total Fresh Water Withdrawn (Mgal/day)")+
                scale_x_discrete("",labels=c("Public Supply", "Domestic-Self", "Industry", "Irrigation-Crop", "Irrigation-Golf", "Livestock", "Aquaculture", "Mining","Thermoelectric"))+
                coord_flip()+
                guides(fill=FALSE)+
                ggtitle(paste("Consumption of Water by Sector:",county.name))+
                theme(plot.title = element_text(size=18, face="bold"), #Don't adjust text size. If you increase it will cut off San Luis Obispo County
                      axis.text.y = element_text(size = 15),
                      axis.text.x = element_text(size = 12),
                      axis.title.x = element_text(size = 15))
return(plot.water)
}
