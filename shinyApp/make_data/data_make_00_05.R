#This Script will clean the water data

#
# #Source: http://pubs.usgs.gov/circ/1405/
#
# df <- read.csv(paste0(path,"/water_consum.csv"))

path <- "C:/Users/Athena/Desktop/project/raw_data" #Data location

df.2005 <- read.csv(file = paste0(path,"/ca_2005_dirty.csv"))
df.2000 <- read.csv(file = paste0(path,"/ca_2000_dirty.csv"))
df.county.index <- read.csv(file = paste0(path,"/ca_1995_dirty.csv"))[ ,c(4,5)]

names(df.2000)[3] = "CountyCode"
names(df.2005)[3] = "CountyCode"

#Merging the county names
df.2000 <- merge(df.2000, df.county.index, by = "CountyCode")
df.2005 <- merge(df.2005, df.county.index, by = "CountyCode")

#Cut out unnecessary data
var.names.2000 <- names(df.2000)
var.names.2005 <- names(df.2005)

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
# Total Withdrawn Fresh Water (Total)
# Domestic - Public Supply Fresh water (Do.PS)
      #Note:Water provided to Domestic by public supply


df.2000<- df.2000[ ,var.names.2000[c(5,grep("*wfrto", tolower(var.names.2000)),length(var.names.2000))]]
df.2005<- df.2005[ ,var.names.2005[c(5,grep("*wfrto", tolower(var.names.2005)),length(var.names.2005))]]


names(df.2000) <- c("County.Pop",
               "Public.Supply", "Domestic.Self", "Industry",
               "Irrigation", "Aquaculture",
               "Livestock", "Mining",
               "Thermoelectric", "T.E",
               "Total", "County")

names(df.2005) <- c("County.Pop",
                    "Public.Supply", "Domestic.Self", "Industry",
                    "Irrigation", "Irrigation.Crop", "Irrigation.Golf","Livestock", "Aquaculture",
                    "Mining",
                    "Thermoelectric", "T.O", "T.C",
                    "Total", "County")
#Numbers to but in the Map

#Percent of total water consumption by County
df.2000$Percent <- df.2000$Total/sum(df.2000$Total)
df.2005$Percent <- df.2005$Total/sum(df.2005$Total)

#Per Capita Water consumption by County
df.2000$Per.Cap <- df.2000$Total/df.2000$County.Pop
df.2005$Per.Cap <- df.2005$Total/df.2005$County.Pop


path.save <- "C:/Users/Athena/Desktop/project/shinyApp/clean_data"
write.csv(df.2000, file = paste0(path.save, "/ca_2000.csv")) #Save the data
write.csv(df.2005, file = paste0(path.save, "/ca_2005.csv")) #Save the data
