# Nombre Programa:  2_LimpiezaDatos.R
# Ubicacion:      	GitHub/Clase5_AnalisisDatos
# Autor:        	  Monica Flores
# Fecha Creacion:   02/04/2019
# Proyecto:         Clase 5
# Objetivo:    	    Explorar herramientas de analisis y limpieza de datos usando datos censales
# Notas:

# Instalar paquetes y librerias - comentar install.packages quien los tenga instalados
# install.packages (c("tidyverse", "sf"))

library(tidyverse) 
library(sf)        

# Analisis de datos Censo 2017 a nivel de zona censal ---------------------
# Obtener un promedio de años de escolaridad por Zona Censal

# Setear directorio local - Cambiar el nombre a la ubicacion de la carpeta de trabajo personal
setwd("C:/Users/CEDEUS 18/Documents/GitHub/Clase5_AnalisisDatos/Data")

# Importar datos como dataframe - usar read.csv2 para data en formato español
escolaridad_csv <- read.csv2("Escolaridad_edad25mas.csv") ## Datos previamente filtrados mayores de 25 anos

# Explorar dataset (proveniente de REDATAM)
head(escolaridad_csv)

# Modificar: variables a minuscula, geocodigo a caracteres, extraer region y comuna del redcode 
escolaridad <- escolaridad_csv %>% 
  rename_all(tolower) %>% 
  mutate(
    geocode = as.character(redcode),
    region = str_sub(geocode, 1, 2) # Manipulacion texto - sustraer caracteres desde geocode en la posición 1 a la 2
  ) %>% 
  select(-redcode)

head(escolaridad)

# Revisar cuantas regiones tenemos
escolaridad %>% group_by(region) %>%  summarise(n = n())
# 1 region 2427 zonas censales

# Cambiar formato ancho a largo -------------------------------------------

## Los datos estan en formato ancho (wide), cada ano de escolaridad es una variable y cada dato el numero de personas
## Necesitamos transformarlo a formato largo (long) para calcular el promedio de anos de escolaridad por ZC

# Transformar a formato largo
escolaridad_long <- escolaridad %>%  
  gather(escolaridad_0:escolaridad_21,
         key="a_escolaridad", value = "n_personas"
  ) %>%
  # Extraer el numero de años del nombre de la variable
  mutate(
    a_escolaridad = str_replace(a_escolaridad, "escolaridad_", ""),
    a_escolaridad = as.numeric(a_escolaridad)
  ) %>% 
  # Ordenarlo por geocodigo
  arrange(geocode)

# Revisar datos
head(escolaridad_long)
str(escolaridad_long)


# Summarise para obtener años de escolaridad por ZC -----------------------

# Calcular promedio anos escolaridad por ZC
escolaridad_media_zc <- escolaridad_long %>% 
  group_by(geocode) %>% 
  summarise(
    total_pers = sum(n_personas),
    a_esc_media = sum(n_personas*a_escolaridad)/total_pers # promedio ponderado
  ) %>% 
  # Excluir NAs
  filter(!is.na(a_esc_media))

head(escolaridad_media_zc)



# Generalizar: obtener datos de escolaridad promedio por comuna -----------


# Desde el geocode obtenemos la comuna
escolaridad_comuna <- escolaridad_media_zc %>% 
  mutate(
    region = str_sub(geocode, 1, 2), # Manipulacion texto - sustraer caracteres desde geocode en la posición 1 a la 2
    comuna = str_sub(geocode, 1, 5)
  ) %>% 
  group_by(comuna) %>% 
  summarise(
    pers_comuna = sum(total_pers),
    a_esc_media_com = sum(total_pers*a_esc_media)/pers_comuna # promedio ponderado
  )

head(escolaridad_comuna)

# Revisar cuantas comunas tenemos en nuestra base
escolaridad_comuna %>% summarise(n = n())


# Guardar datos en csv ----------------------------------------------------

escolaridad_media_zc %>% write.csv2("escolaridad_media_zc.csv", row.names=FALSE)
escolaridad_comuna %>% write.csv2("escolaridad_comuna.csv", row.names=FALSE)


# Visualizar: Introduccion a ggplot2 --------------------------------------

# Tres partes de ggplot2: data, aesthetics, geometry
## Data - base de datos
## Aesthetics: Lo que quieres graficar (variables)
## Geometry: Como lo quieres graficar (grafico de barras, linea, mapa, etc)

# Plotear histograma
hist1 <- escolaridad_media %>% 
  ggplot(aes(a_esc_media)) + 
  geom_histogram()
hist1

# Agregar eqtiquetas y modificar colores y tamaños - mismo grafico
hist2 <- escolaridad_media %>% 
  ggplot(aes(a_esc_media)) + 
  geom_histogram(color = "grey", fill = "navy", lwd=0.1, binwidth = 0.05)
hist2 + labs(x = "Años de Escolaridad Media", y = "Frecuencia",
             title ="Histograma Escolaridad Promedio",
             subtitle = "por Zona Censal en el Gran Santiago",
             caption = NULL)
