library(dplyr)
library(readr)
library(here)

path <- here('data_processed', 'intermediate', 'extreme-weather-days')
df <- list.files(path, pattern = "\\.csv$", full.names = TRUE) %>%
  lapply(read_csv) %>%
  bind_rows() %>%
  rename(ubigeo = district) %>%
  arrange(ubigeo, year) %>%
  rename(anio = year)

saveRDS(df, file = here('data_processed', 'analysis', 'district-year-extreme-days.rds'))