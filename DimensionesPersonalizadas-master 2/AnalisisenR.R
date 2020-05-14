################################librerias###########################################################################
#Cargamos todas la librerias de analytics#
##################################################################################################################
#Sacar los datos de Google Analytics#
pack <- c("tidyverse", "rvest", "httr", "dplyr", "ggplot2", "googleAnalyticsR")
lapply(pack, require, character.only = TRUE)

########################################################################################################################
#Variables#
##################################################################################################################
cuenta<- 200897542
fecha_inicio<-'2020-03-25'
fecha_fin<-'2020-03-31'
dimensionesHit<-"dimension9"
dimensionSesion<-"dimension10"
dimensionUsuario<-"dimension11"
dimensiones<-c("eventAction","eventLabel","pagePath")
metricas <- "totalEvents"

########################################eventos##########################################################################
#Descargar todos los eventos#
##################################################################################################################

analytics<-google_analytics(cuenta, date_range = c(fecha_inicio, fecha_fin),
                              metrics = c(metricas), 
                              dimensions = c(dimensiones,dimensionesHit, dimensionSesion,dimensionUsuario),
                              #segments = my_segment,
                              anti_sample = TRUE,
)

########################################eventos##########################################################################
#Descargar todos los eventos#
##################################################################################################################

EventosTotales<-google_analytics(cuenta, date_range = c(fecha_inicio, fecha_fin),
                              metrics = c('TotalEvents'), 
                              dimensions = c("eventAction","eventLabel","pagePath",dimensionesHit, dimensionSesion,dimensionUsuario),
                              #segments = my_segment,
                              anti_sample = TRUE,
)
########################################sesiones##########################################################################
#Descargar todas las sesiones#
##################################################################################################################

SesionesTotales<-google_analytics(cuenta, date_range = c(fecha_inicio, fecha_fin),
                            metrics = c('pageViews'), 
                            dimensions = c('pagePath',dimensionesHit, dimensionSesion,dimensionUsuario),
                            #segments = my_segment,
                            anti_sample = TRUE,
)
##################################################################################################################
#Sesiones que han evento de substep#
##################################################################################################################
pagina<-'(.*)restaurant(.*)'

#Sesiones que se han entrado en la pagina#
SePagList<-SesionesTotales %>% 
  filter(grepl(pagina, pagePath)) %>%
  arrange(dimension10, dimension9)
SePagList<-as.vector(t(unique(SePag$dimension10)))

#Eventos de las sesiones que han entrado en la pagina#
EvPag<-EventosTotales %>%
  filter(dimension10 %in% SePagList) %>%
  arrange(dimension10, dimension9)
SePag<-SesionesTotales %>%
  filter(dimension10 %in% SePagList) %>%
  filter(pageViews>0)%>%
  arrange(dimension10, dimension9)


##################################################################################################################
#Unir las dos bases#
##################################################################################################################
EvPag$tipo<-'Evento'
SePag$tipo<-'Pagina'
colnames(EvPag)[7]<-'pageViews'
SePag$eventAction<-'Página'
SePag$eventLabel<-'Página'
#colnames(EvPag)
#colnames(SePag)

ds=rbind(EvPag, SePag)
ds1<-ds %>% 
  arrange(dimension10, dimension9)

ds1 = ds1 [ , c(1,5,6,2,3,4)]

##################################################################################################################
#Seleccionar lo que queramos#
##################################################################################################################
ds1<-ds1 %>%
  select(eventAction,eventLabel,pagePath,pageViews,dimension9,dimension10,tipo) %>%
  filter(pageViews>0)%>%
  arrange(dimension10, dimension9)


##################################################################################################################
#identificar las páginas#
##################################################################################################################

ds1$dimension10=haz.cero.na(sesionesLead_substep$dimension10)
ds1$sesion=''

for (i in 1:(length(ds1$dimension10)-1)) {
  #print(paste0(i+(sesionesLead_substep$dimension10[i] == sesionesLead_substep$dimension10[i+1])))
  if (ds1$dimension10[i] == ds1$dimension10[i+1]) {
    ds1$sesion[i]="sigue"
  }else{
    ds1$sesion[i]="fin"
    ds1$sesion[i+1]="comienzo"
  }
}
for (i in 2:(length(ds1$dimension10)-1)) {
  #print(sesionesLead_substep$dimension10[i] != sesionesLead_substep$dimension10[i-1])
  if ((ds1$dimension10[i] != ds1$dimension10[i-1])) {
    ds1$sesion[i]="comienzo"
  }else{
    ds1$sesion[length(ds1$dimension10)]='fin'
    ds1$sesion[1]='comienzo'
  }
}

write.csv(ds1,"/Users/aritz/Downloads/ds1.csv", row.names = FALSE)

##################################################################################################################
#Sesiones dentro del funnel#
##################################################################################################################

PagSalida<-ds1 %>%
  filter(sesion=="fin")%>%
  filter(grepl(pagina, pagePath)) %>%
  arrange(dimension10, dimension9)
PagSalida_list<-as.vector(t(unique(PagSalida$dimension10)))


##################################################################################################################
#identificar página de salida#
##################################################################################################################
#Todas las sesiones#
PagSalida_list
#Sesiones que han entrdo en el funnel#
length(PagSalida_list)

