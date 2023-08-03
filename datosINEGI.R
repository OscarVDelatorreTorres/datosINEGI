

library(httr)
library(jsonlite)
library(rjson)

tokenINEGI="5d0750aa-9434-f980-90bb-9559cb8dc581"
indicador=6207061409
#Llamado al API
url=paste0("https://www.inegi.org.mx/app/api/indicadores/desarrolladores/jsonxml/INDICATOR/",
       indicador,
       "/es/0700/false/BISE/2.0/",
       tokenINEGI,
       "?type=json")
respuesta<-GET(url)
datosGenerales<-content(respuesta,"text")
Datos<-paste(datosGenerales,collapse = " ")

#Obtención de la lista de observaciones 
Datos<-fromJSON(Datos)
Datos<-Datos $Series
Datos<-Datos[[1]] $OBSERVATIONS

datosOut=data.frame(date=matrix("",length(Datos),1),
                    value=matrix("",length(Datos),1))
for (a in 1:length(Datos)){
  datosOut$date[a]=Datos[[a]]$TIME_PERIOD
  datosOut$value[a]=Datos[[a]]$OBS_VALUE
}  

return(datosOut)