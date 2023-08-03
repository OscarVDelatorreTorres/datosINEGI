

library(httr)
library(jsonlite)
library(rjson)

#token="5d0750aa-9434-f980-90bb-9559cb8dc581"
#indicator=c(6207061409,539260)

inegiData=function(token,indicator){

  for (b in 1:length(indicator)){
    
    url=paste0("https://www.inegi.org.mx/app/api/indicadores/desarrolladores/jsonxml/INDICATOR/",
               indicator[b],
               "/es/0700/false/BISE/2.0/",
               token,
               "?type=json")
      
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
  
  
  return(dataObject)
  
}
