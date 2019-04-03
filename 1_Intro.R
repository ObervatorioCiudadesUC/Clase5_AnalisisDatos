# Nombre Programa:  1_Intro.R
# Ubicacion:      	GitHub/Clase5_AnalisisDatos
# Autor:        	  Monica Flores
# Fecha Creacion:   02/04/2019
# Proyecto:         Clase 5
# Objetivo:    	    Introduccion al uso de R con los paquetes Tidyverse 
# Notas:

# Instalar paquetes y librerias - comentar install.packages quien los tenga instalados
install.packages (c("tidyverse", "sf"))

library(tidyverse) # Limpieza y visualizacion de datos (dplyr + stringr + ggplot2 + tidyr + readr + purrr)
library(sf)        # Simple Feautures: manipular datos vectoriales espaciales

# Introduccion a R y Limpieza de datos con Dplyr  -------------------------

# Correr comandos: seleccionar + ctrl + enter
2 + 2 

# Asignar informacion a una variable
cuatro <- 2 + 2
cuatro

# Crear un vector
mi_vector <- c(1, 2, 3, 4, 5, 6) # Vector numerico
mi_vector2 <- 1:6 # Uso : para indicar rango
mi_vector3 <- c(1:6, 10, 15, 20)
mi_vector4 <- c("uno", "dos", "tres", "cuatro", "cinco", "seis") # Vector de caracteres
mi_vector5 <- c(TRUE, FALSE, TRUE, TRUE, FALSE, TRUE) # Vector logico

#Seleccionar elementos dentro del vector
mi_vector4[6]
mi_vector5[c(1, 3, 5)]

# Operaciones con vectores y variables
mi_vector * 4
mi_vector * cuatro
mi_vector3[8]*2 

# Limpieza de datos con Dplyr  --------------------------------------------

## Paquete para manipulacion de datos dentro de tidyverse
## permite filtrar, seleccionar, agrupar y calcular de forma simple

# Crear un dataframe
df <- data.frame(mi_vector4, mi_vector, mi_vector5)
# Explorar nuestros datos
head(df)
summary(df)

# Nueva variable a partir de nuestros datos - uso signo $
df$cuadrado <- df$mi_vector^2
# Operaciones con variables
mean(df$mi_vector)
mean(df$cuadrado)

# Los 5 verbos de Dyplr: Select, filter, arrange, mutate, summarise 

select(df, mi_vector, cuadrado)

filter(df, mi_vector5==TRUE)

arrange(df, desc(mi_vector))

mutate(df, cubo = mi_vector^3)

summarise(df,
          media_mv = mean(mi_vector),
          media_cuadrado = mean(cuadrado)
          )

# Operaciones con Pipa %>% ctrl + shft + M  
df %>% summarise(
  media_mv = mean(mi_vector),
  media_cuadrado = mean(cuadrado)
)

# Asignar modificaciones a un nuevo dataframe
df2 <- df %>% 
  mutate(
    year = 2017, 
    var1 = cuadrado 
  ) %>% 
  select(-cuadrado) # Select negativo, sacar variable

# Verbo transmute (mutate + select)
df3 <- df %>% 
  transmute(
    year = 2017, 
    var1 = cuadrado 
  )

# Uso de condicionales
df4 <- df3 %>% 
  mutate(
    es_par = if_else(var1 %% 2 == 0, TRUE, FALSE), # Uso if_else, función condicional: ¿es var1 divisible por 2?
    mayor_10 = if_else(var1 > 10, 1, 0), # Función condicional: ¿es var1 mayor a 10?
    # Uso case_when - funcion condicional re-clasificación
    categoria = case_when(
      var1 < 10 ~ "Menor a 10",
      var1 >= 10 & var1 < 20 ~ "Entre 10 y 20",
      var1 >= 20 ~ "Mayor a 20",
      TRUE ~ NA_character_ # Especificar qué pasa si no cumple ninguna condición
    )
  )

# Aplicacion de filter - selccionar solo pares
df5 <- df4 %>% filter(es_par == TRUE) 
# O bien
df6 <- df4 %>% filter(es_par != FALSE) 

# Filtrar los datos que no sea NA
vector_a <- c(1, 2, NA, 4) # Creamos una base con un dato NA
vector_b <- c(TRUE, FALSE, FALSE, TRUE) # Vector logico
df7 <- data_frame(vector_a, vector_b)

df7 %>% filter(!is.na(vector_a))


# Uso de group_by() -------------------------------------------------------

# group_by agrupa los datos de acuerdo a cierta variable, 
# Resulta muy útil combinado con summarise o mutate

# Combinar group_by + mutate
df4_rank <- df4 %>% 
  group_by(es_par) %>% 
  mutate(
    ranking = rank(var1)
  ) %>% 
  arrange(es_par, ranking) # Ordenar datos según variable(s)

# Ejemplo uso rank sin group_by
df4 %>% mutate(ranking=rank(var1))

# Combinar group_by + summarise
df4_summ <- df4 %>% 
  group_by(es_par) %>% 
  summarise(
    promedio = mean(var1),
    std = sd(var1)
  )
