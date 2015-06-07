#This Script will make the ggplot wrapper
# rm(list=ls())  # ML: It seems very dangerous to me to source files with this command.

# We want to build this data.frame once, not on each call to gg.wrapper.
water.consum.data <- function (select.variables = NULL,
                               long) {
  df <- read.csv(file = "./clean_data/clean_water_consum.csv")

  if (!is.null(select.variables))
    df <- df[ , select.variables]

  #To use ggplot, I need to reshape the data from wide to long.
  if (long) {
    df.long <- melt(df, id = "County")
    names(df.long)[2:3] <- c("Source","Water")
    return(df.long)
  } else {
    return (df)
  }
}

df.long <- water.consum.data(
  select.variables = c("County", "Public.Supply", "Domestic.Self", "Industry",
                       "Irrigation.Crop", "Irrigation.Golf", "Livestock",
                       "Aquaculture", "Mining","Thermoelectric"),
  long = TRUE)

#plot
gg.wrapper <- function(county.name, theDF = df.long){
  #First I will subsample the data.  Some data is a double count.  For example Ir=Ir.C+Ir.G (i.e. Irrigation = Irrigation Crops + Irrigation Golf)
  
  plot.water <- ggplot(data=theDF[grep(pattern = county.name, x = tolower(theDF$County)),], aes(x=Source,y=Water, fill =Source ))+
    geom_bar(stat="identity")+
    theme_bw()+
    scale_y_continuous("Total Fresh Water Withdrawn (Mgal/day)")+
    scale_x_discrete("",labels=c("Public Supply", "Domestic-Self", "Industry", "Irrigation-Crop", "Irrigation-Golf", "Livestock", "Aquaculture", "Mining","Thermoelectric"))+
    coord_flip()+
    guides(fill=FALSE)+
    ggtitle(paste("Consumption of Water by Sector:", simpleCap(county.name)))+
    theme(plot.title = element_text(size=18, face="bold"), #Don't adjust text size. If you increase it will cut off San Luis Obispo County
          axis.text.y = element_text(size = 15),
          axis.text.x = element_text(size = 12),
          axis.title.x = element_text(size = 15))
  return(plot.water)
}
