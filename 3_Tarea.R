# Nombre Programa:  3_Tarea.R
# Ubicacion:      	
# Autor:        	  
# Fecha Creacion:   03/04/2019
# Proyecto:         Tarea Clase 5
# Objetivo:    	    Aplicar herramientas de analisis y limpieza de datos usando datos censales
# Notas:


# INSTRUCCIONES -----------------------------------------------------------


# TAREA: Calcular el % de mujeres jefas de hogar sobre el total de jefes de hogar por Zona Censal (geocode) y por comuna. 

# DATA: 
# Descargar los microdatos del Censo 2017 desde el Drive del curso (carpeta Censo)
# Revisar la metadata, descargable de la misma carpeta

# PROCESO: 
# Cargar los datos con readRDS()
# Crear una variable dummy para mujer y otra para hogar, usando mutate(hogar == 1) y mutate(mujer = if_else(sexo==2, 1, 0)
# Usar group_by() y summarise(). Dentro de summarise sumar total de hogar y total de mujeres usando sum().
# Luego usar mutate() para crear una nueva variable dividiendo mujer/hogar.

# Finalmente: guardar en formato csv usando el comando write_csv2()


# TAREA PARA LA CASA: Cálculo % población y jefes de hogar por rango etario, por comuna.
# Instrucciones en el punto 5.


# 0. instalar paquetes y definir directorio -------------------------------


# Instalar el paquete y cargar la librería tidyverse con install.packages() y library().
install.packages ("-----")
library(-----) 

# Definir directorio
setwd("--------") 

# 1. Cargar RDS datos censo 2017 RM ------------------------------------------

# Cargar el Censo 2017 en RStudio usando el comando readRDS()

data <- readRDS("Censo2017_Persona_RM.Rds") 

# Revisar contenido
head(---)
str(---)

# 2. Filtros y mutate---------------------------------------------------------

# Y Filtrar para obtener sólo observaciones de la región metropolitana (region == 13) y los jefes de hogar (p07 == 1).
data <- data %>% 
  filter(region == ---- & p07 == -----)

# Crear una variable dummy para mujer y otra para hogar, usando mutate(hogar == 1) y mutate(mujer = if_else(sexo==2, 1, 0)
data <- data %>% 
  mutate(
    hogar = -----,
    mujer = if_else(sexo == ----, ---, ----)
  )

# 3. Summarise ---------------------------------------------------------------

# Summarise por zona censal (geocode)
zona <- data %>% 
  group_by(----) %>% 
  summarise(
    n_mujeres_jh = sum(----),
    n_hogares = sum(----)
  ) %>% 
  mutate(
    mujeres_jh = -----/-----
  )


# Summarise por comuna
comuna <- data %>% 
  group_by(----) %>% 
  summarise(
    ----
  ) %>% 
  mutate(
    ----
  )

# 4. Guardar en csv -------------------------------------------------------


# Guardar ambas tablas en formato csv usando el comando write_csv2()
comuna %>% ----

zona %>%  ----

  
# 5. Tarea para la casa ---------------------------------------------------

# Clasificar a cada persona según los siguientes 5 rangos de edad (0-18, 19-29, 30-44, 45-59, 60+)
# Calcular el % de población por rango etario en cada comuna
# Calcular el % de jefes de hogar por rango etario por comuna  

# Entregable:
# A. Script (se evaluará orden, indentación, comentarios)
# B. 2 tablas en csv (una de población y otra de jefes de hogar)
# C. Seleccionar dos comunas y hacer histogramas comparativos en ggplot2
# ***Bonus: Que los dos histogramas esten en la misma lámina usando + facet_grid(. ~ comuna)

                                                                                         