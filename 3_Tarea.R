
# Descargar los microdatos históricos del Censo desde: https://drive.google.com/drive/u/0/folders/1HrWPOQeCAnJBPyrljyjb43Y7AUDdopEO 
# y la metadata desde: https://drive.google.com/drive/u/0/folders/1CaQ8vcQFlgxQxlg8MsKaXeLSTDCKgnGN

# Cargar el Censo 2017 en RStudio usando el comando readRDS()
# Instalar el paquete y cargar la librería tidyverse con install.packages() y library().
# Filtrar para obtener sólo observaciones de la región metropolitana (region == 13) y los jefes de hogar (p07 == 1).
# Guardar en formato csv usando el comando write_csv2()


# Luego, a partir del csv creado:
# Calcular el % de mujeres jefas de hogar sobre el total de jefes de hogar por Zona Censal (geocode) y otra base por comuna. 

# Pistas: 
# Crear una variable dummy para mujer y otra para hogar, usando mutate(hogar == 1) y mutate(mujer = if_else(sexo==2, 1, 0)
# Usar group_by() y summarise(). Dentro de summarise sumar total de hogar y total de mujeres usando sum().
# Luego usar mutate() para crear una nueva variable dividiendo mujer/hogar.
# Finalmente: guardar en formato csv usando el comando write_csv2()
                                                                                         