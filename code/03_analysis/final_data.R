library(here)
library(dplyr)

# Reading data
path <- here('data_processed', 'analysis')
deaths   <- readRDS(here(path, 'district-year-deaths.rds'))
pop      <- readRDS(here(path, 'district-year-population.rds'))
heat     <- readRDS(here(path, 'district-year-extreme-days.rds'))
controls <- readRDS(here(path, 'district-year-controls.rds'))

# Merging all data
df <- deaths %>%
  full_join(pop, by = c('anio', 'ubigeo')) %>%
  replace_na(list(deaths = 0)) %>%
  filter(!is.na(poblacion)) %>%
  mutate(poblacion = as.numeric(poblacion),
         deaths_per_1000 = deaths / poblacion * 1000) %>%
  full_join(heat, by = c('anio', 'ubigeo')) %>%
  filter(!is.na(days_extreme)) %>%
  full_join(controls, by = c('anio', 'ubigeo')) %>%
  filter(!is.na(anio_ubigeo)) %>%
  mutate(anio = factor(anio)) %>%
  arrange(ubigeo, anio)

saveRDS(df, file = here('data_processed', 'data_final.rds'))