# Esta función se programó para descargar datos de INEGI conociendo el banco de información, los códigos
# así como si queremos descargar serie de tiempo o la observación más reciente

#V 1.0 Oscar De la Torre-Torres el 2 de agosto del 2023
#V 2.1 Oscar De la Torre-Torres el 5 de diciembre de 2023

# Verifica e instala las librerías necesarias
if (!require(httr)){install.packages("httr")} else {library(httr)}
if (!require(jsonlite)){install.packages("jsonlite")} else {library(jsonlite)}
if (!require(rjson)){install.packages("rjson")} else {library(rjson)}

# Ejemplo:
#token="5d0750aa-9434-f980-90bb-9559cb8dc581"
#id=c(741274,539260) estos son los códiigos del ITAE michoacano y de la UMA
#bancoDatos=c("BIE","BISE")
#serieTiempo=c(TRUE,FALSE)

#datos=inegiData(token,id,bancoDatos,serieTiempo)

# Código fuente de la función:

inegiData=function(token,indicator,bancoDatos,serieTiempo){

  for (b in 1:length(indicator)){
    cat("\f")
    print(paste0("Fecthing data from INEGI DB's for indicator ",b," of ",length(indicator),": ",indicator[b]))
    
    switch(bancoDatos[b],
           
          "BIE"={    
            
            if (isTRUE(serieTiempo[b])){
              url=paste0("https://www.inegi.org.mx/app/api/indicadores/desarrolladores/jsonxml/INDICATOR/",
                         indicator[b],
                         "/es/0700/false/BIE/2.0/",
                         token,
                         "?type=json")               
            } else {
              url=paste0("https://www.inegi.org.mx/app/api/indicadores/desarrolladores/jsonxml/INDICATOR/",
                         indicator[b],
                         "/es/0700/true/BIE/2.0/",
                         token,
                         "?type=json")               
            }
               
                    }     ,
           "BISE"={
             
             if (isTRUE(serieTiempo[b])){
               url=paste0("https://www.inegi.org.mx/app/api/indicadores/desarrolladores/jsonxml/INDICATOR/",
                          indicator[b],
                          "/es/0700/false/BISE/2.0/",
                          token,
                          "?type=json")               
             } else {
               url=paste0("https://www.inegi.org.mx/app/api/indicadores/desarrolladores/jsonxml/INDICATOR/",
                          indicator[b],
                          "/es/0700/true/BISE/2.0/",
                          token,
                          "?type=json")               
             }

           }
          )

      
    call<-GET(url)
    generalData<-content(call,"text")
    dataInegi<-paste(generalData,collapse = " ")
    
    dataInegi<-fromJSON(dataInegi)
    dataInegi<-dataInegi $Series
    dataInegi<-dataInegi[[1]] $OBSERVATIONS
    
    dataTable=data.frame(date=matrix("",length(dataInegi),1),
                         value=matrix(0,length(dataInegi),1))
    
    for (a in 1:length(dataInegi)){

      dataTable$date[a]=dataInegi[[a]]$TIME_PERIOD
      if (length(dataInegi[[a]]$OBS_VALUE)<1){
        dataTable$value[a]=NA        
      } else {
        dataTable$value[a]=dataInegi[[a]]$OBS_VALUE        
      }

    }  
    
    if (b<2){
     eval(parse(text=paste0("dataObject=list('",indicator[b],"'=dataTable)")))
    } else {
      eval(parse(text=paste0("dataObject$'",indicator[b],"'=dataTable"))) 
    }
    
  }
  
cat("\f")
print("Descarga de datos de INEGI realizada con éxito!!!") 
  return(dataObject)

}
