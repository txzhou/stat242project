#This Script will make the ggplot wrapper
# rm(list=ls())  # ML: It seems very dangerous to me to source files with this command.

# We want to build this data.frame once, not on each call to gg.wrapper.
water.consum.data <- function (select.variables = NULL,
                               long,
                            
                               year=2010) {
  df <- read.csv(file = paste0("./clean_data/ca_",year,".csv"))

  
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

# debugonce(gg.wrapper)
# gg.wrapper("imperial", "2000")
#plot
gg.wrapper <- function(county.name, year.gg){
  
  theDF <- water.consum.data(
    select.variables = c("County", "Public.Supply", "Domestic.Self", "Industry",
                         "Irrigation", "Livestock",
                         "Aquaculture", "Mining","Thermoelectric"),
    long = TRUE,
    year = year.gg)
  
  plotDF = theDF[grep(pattern = county.name, x = tolower(theDF$County)),]
  plotDF$Water = plotDF$Water * .325851 * 365.25 # MGal/day -> AF/year
#  plotDF = plotDF[plotDF$Water > 0, ]
  plotDF$lab = sprintf("%1.0f", plotDF$Water)
  plotDF$Source = factor(plotDF$Source, 
                         levels = plotDF$Source[order(plotDF$Water)],
                         ordered = TRUE)
  #First I will subsample the data.  Some data is a double count.  For example Ir=Ir.C+Ir.G (i.e. Irrigation = Irrigation Crops + Irrigation Golf)
  col = brewer.pal(8, "Set1")
  names(col) = c("Public.Supply", "Domestic.Self", "Industry",
                 "Irrigation", "Livestock",
                 "Aquaculture", "Mining","Thermoelectric")
  
  plot.water <- ggplot(data = plotDF, aes(x=Source,y=Water, fill =Source ))+
    geom_bar(stat="identity")+
    theme_bw()+
#    scale_y_continuous("Total Fresh Water Withdrawn (Mgal/day)")+
#    scale_x_discrete("",labels=c("Public Supply", "Domestic-Self", "Industry", "Irrigation", "Livestock", "Aquaculture", "Mining","Thermoelectric"))+
    scale_y_log10("Fresh Water Withdrawn (acre-feet/year)") +
#                  limits = c(1, max(theDF$Water) + .05 * max(theDF$Water))) +
  scale_fill_manual(values = col) +
  geom_text(aes(label = lab, y = ifelse(Water < 2, 1, Water / 2))) +
    coord_flip()+
    guides(fill=FALSE)+
    ggtitle(paste("Consumption of Water by Sector for",
                  simpleCap(county.name), "County"))+
    theme(plot.title = element_text(size=18, face="bold"), #Don't adjust text size. If you increase it will cut off San Luis Obispo County
          axis.text.y = element_text(size = 15),
          axis.text.x = element_text(size = 12),
          axis.title.x = element_text(size = 15))
  return(plot.water)
}
