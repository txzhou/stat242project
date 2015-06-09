#This Script will clean the water data

#
# #Source: http://pubs.usgs.gov/circ/1405/
#
# df <- read.csv(paste0(path,"/water_consum.csv"))

path <- "C:/Users/Athena/Desktop/project/raw_data" #Data location

df <- read.csv(file = paste0(path,"/usa_2010_dirty.csv"))
df <- df[df$STATE=="CA", ]

#Cut out unnecessary data
var.names <- names(df)

# Relevant variables.  All letters in parentheses represent the name I will give the data:
# State
# County
# County Pop.State in Thousands
# Public Supply (PS) Total Withdrawn Fresh Water
      #Note: Public supply represent water distributed by the public sector.  In general this is water distributed to Domesitic and Industrial users.
      #Note: All units are in Mgal/d (Million Gallons per Day)
# Domestic - Self supplied (Do.self) Total Withdrawn Fresh Water
      #Note:Self supplied means that is was not provided by the Public Supply
# Industry (In) Total Withdrawn Fresh Water
      #Note: Above is Self Supplied.
# Irrigation (Ir) Total Withdrawn Fresh Water
# Irrigation (Ir.C)- Crops Total Withdrawn Fresh Water
# Irrigation (Ir.G)- Golf Total Withdrawn Fresh Water
# Livestock (L) Total Withdrawn Fresh Water
# Aquaculture (A) Total Withdrawn Fresh Water
# Mining (M) Total Withdrawn Fresh Water
# Theromoelectic (T) Total Withdrawn Fresh Water
# Theromoelectic - Once Through (T.O) Total Withdrawn Fresh Water
# Theromoelectic - RecirculationTotal (T.R) Withdrawn Fresh Water
# Total Withdrawn Fresh Water (Total)
# Domestic - Public Supply Fresh water (Do.PS)
      #Note:Water provided to Domestic by public supply


df<- df[ ,var.names[c(1,3,7,grep("*wfrto", tolower(var.names)))]]

names(df) <- c("State", "County", "County.Pop",
               "Public.Supply", "Domestic.Self", "Industry",
               "Irrigation", "Irrigation.Crop", "Irrigation.Golf",
               "Livestock", "Aquaculture", "Mining",
               "Thermoelectric", "T.O", "T.R",
               "Total")


#Numbers to but in the Map

#Percent of total water consumption by County
df$Percent <- df$Total/sum(df$Total)

#Per Capita Water consumption by County
df$Per.Cap <- df$Total/df$County.Pop

path.save <- "C:/Users/Athena/Desktop/project/shinyApp/clean_data"
write.csv(df, file = paste0(path.save, "ca_2010")) #Save the data
