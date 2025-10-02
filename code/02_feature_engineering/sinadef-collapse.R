library(readr)
library(dplyr)
library(here)

df <- read_csv(here('data_raw', 'SINADEF_DATOS_ABIERTOS.csv')) %>%
  janitor::clean_names()

df2 <- df %>%
  filter(pais_domicilio == 'PERU') %>%
  filter(cod_ubigeo_domicilio != 'SIN REGISTRO' &
           distrito_domicilio != 'SIN REGISTRO') %>%
  select(year = anio,
         ubigeo = cod_ubigeo_domicilio) %>%
  mutate(death = 1,
         ubigeo = substr(ubigeo, 7, 14),
         ubigeo = gsub("-", "", ubigeo)) %>%
  group_by(year, ubigeo) %>%
  summarize(deaths = sum(death)) %>%
  ungroup()

write.csv(df2, file = here('data_processed', 'peru_deaths.csv'))