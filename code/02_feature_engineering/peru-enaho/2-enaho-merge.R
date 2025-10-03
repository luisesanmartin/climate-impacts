library(dplyr)
library(here)

# Load datasets
path     <- here("data_processed", "intermediate")
hogar    <- readRDS(here(path, "modulo1-hogar.rds"))
salud    <- readRDS(here(path, "modulo4-salud.rds"))
sumaria  <- readRDS(here(path, "sumaria.rds"))
miembros <- readRDS(here(path, "modulo2-miembros_del_hogar.rds"))

# Merge datasets
df <- hogar %>%
  left_join(miembros, by = c("anio", "id_hogar")) %>%
  left_join(salud,    by = c("anio", "id_hogar", "id_persona")) %>%
  left_join(sumaria,  by = c("anio", "id_hogar")) %>%
  mutate(anio_ubigeo = paste0(anio, ubigeo)) %>%
  relocate(anio, id_hogar, id_persona, anio_ubigeo)

# Save final dataset
saveRDS(df, here("data_processed", "intermediate", "enaho_total.rds"))