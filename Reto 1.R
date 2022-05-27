install.packages("DBI")
install.packages("RMySQL")

library(DBI)
library(RMySQL)

MyDataBase <- dbConnect(
  drv = RMySQL::MySQL(),
  dbname = "shinydemo",
  host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
  username = "guest",
  password = "guest")

dbListTables(MyDataBase)#PARA VER LAS TABLAS EXITENTES
dbListFields(MyDataBase, 'City')#PARA VER LOS CAMPOS DE LA TABLA
DataDB <- dbGetQuery(MyDataBase, "select * from City")#HACER CONSULTAS

#Una vez hecha la conexión a la BDD, generar una busqueda con dplyr 
#que devuelva el porcentaje de personas que hablan español en todos 
#los países

dbListFields(MyDataBase, 'CountryLanguage')

DataDB <- dbGetQuery(MyDataBase, "select * from CountryLanguage")
names(DataDB)

SP <- DataDB %>% filter(Language == "Spanish")
SP.df <- as.data.frame(SP) 
class(SP.df)

#Realizar una gráfica con ggplot que represente este porcentaje 
#de tal modo que en el eje de las Y aparezca el país y en X el 
#porcentaje, y que diferencíe entre aquellos que es su lengua oficial 
#y los que no con diferente color (puedes utilizar la geom_bin2d() y 
#coord_flip())

install.packages("ggplot")

SP.df %>% ggplot(aes( x = CountryCode, y=Percentage, fill = IsOfficial )) + 
  geom_bin2d() +
  coord_flip()

