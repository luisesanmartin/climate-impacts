library(readr)
library(dplyr)
library(here)

df <- read_csv(here('data_raw', 'SINADEF_DATOS_ABIERTOS.csv')) %>%
  janitor::clean_names()

df2 <- df %>%
  filter(pais_domicilio == 'PERU' &
           cod_ubigeo_domicilio != 'SIN REGISTRO' &
           distrito_domicilio != 'SIN REGISTRO' &
           anio %in% 2022:2024) %>%
  select(anio,
         ubigeo = cod_ubigeo_domicilio) %>%
  mutate(death = 1,
         ubigeo = substr(ubigeo, 7, 14),
         ubigeo = gsub("-", "", ubigeo)) %>%
  group_by(anio, ubigeo) %>%
  summarize(deaths = sum(death)) %>%
  ungroup()

saveRDS(df2, file = here('data_processed', 'analysis', 'district-year-deaths.rds'))