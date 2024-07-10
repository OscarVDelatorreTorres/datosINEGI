# Función datosINEGI()

Esta función está diseñada para analistas y académicos hispanoparlantes que requieren descargar datos de las bases de datos del BIE o el BISE de INEGI en R.

Para poder correr la función es necesario crgarla de manera remota con esta instrucción

```{r}
source("https://raw.githubusercontent.com/OscarVDelatorreTorres/datosINEGI/main/datosINEGI.R")
```
Para poder utilizarla es necesario crear un token o clave personal de acceso a los servidoers de INEGI [en esta liga](https://www.inegi.org.mx/app/desarrolladores/generatoken/Usuarios/token_Verify)

Una vez creado, se puede utilizar el mismo con la siguiente función

```{r}
# Se crea un objeto llamado token con el toekn (código alfa numérico) que obtuvo de la liga de INEGI:
token="[su token entre estas comillas]"
id=c(741274,539260) estos son los códiigos del ITAE michoacano y de la UMA
bancoDatos=c("BIE","BISE")
serieTiempo=c(TRUE,FALSE)
```

La función `datosIngegi()` es la encargada de extraer los datos de las bases de datos de INEGI. Solo hay que especificar el Id del indicador (encontrado en el BIE o el BISE), las siglas de la bace de datos (BIE o BISE) y si desea extraer la serie de tiempo del indicador o la observación más reciente. El siguiente ejemplo extrae los datos del ITAE de Michoacán (ID 741274 en el BIE) y la observación más reciente de la UMA (Id 539260 en el BISE):

```{r}
id=c(741274,539260) estos son los códigos del ITAE michoacano y de la UMA
bancoDatos=c("BIE","BISE")
serieTiempo=c(TRUE,FALSE)
# Se ejecuta la función con los objetos de token, vector de Id de datos, los banco de datos y si deseamos, en cada uno, extraer la srie de tiempo o la observación más reciente:
datos=datosINEGI(token,id,bancoDatos,serieTiempo)
```

**NOTA:** Es importante que los objetos `id`, `bancoDatos`, `serieTiempo` tengan la misma longitud. Es decir, sean vectores con la misma cantidad de elementos o filas.

Esta función está en desarrollo por lo que es una versión beta.
