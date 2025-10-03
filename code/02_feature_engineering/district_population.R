library(here)
library(readxl)
library(dplyr)
library(tidyr)

file <- here('data_raw', 'reporte_estadist.xlsx')
df <- read_excel(file) %>% 
  janitor::clean_names() %>%
  filter(!is.na(ubigeo)) %>%
  select(ubigeo,
         poblacion2022 = x11,
         poblacion2023 = x12,
         poblacion2024 = x13) %>%
  pivot_longer(
    cols = starts_with("poblacion"),
    names_to = "anio",
    values_to = "poblacion"
  ) %>%
  mutate(anio = gsub("poblacion", "", anio),
         anio = as.integer(anio))

saveRDS(df, file = here('data_processed', 'analysis', 'district-year-population.rds'))