library(dplyr)
library(survey)
library(tidyr)
library(here)
library(stringr)

# Load dataset
df <- readRDS(here("data_processed", "intermediate", "enaho_total.rds"))

# List of indicators
indicators <- c("piso_tierra", "agua_red_publica", "desague_red_publica",
                "electricidad", "cocina_lena", "poblacion_rural",
                "region_sierra", "region_selva", "mujer",
                "enfermedad", "seguro_de_salud", "edad_65_mas",
                "pobreza_total", "pobreza_extrema")

# Define survey design
# Assuming conglome = PSU, estrato = strata, facpob07 = weight
enaho_svy <- svydesign(
  ids = ~conglome,
  strata = ~estrato,
  weights = ~facpob07,
  data = df,
  nest = TRUE
)

# Aggregation by "anio_ubigeo"
# We'll compute weighted means for all indicators
results <- enaho_svy %>%
  # Split by anio_ubigeo
  svyby(
    formula = as.formula(paste("~", paste(indicators, collapse = "+"))),
    by = ~anio_ubigeo,
    design = .,
    FUN = svymean,
    keep.var = FALSE  # we won't calculate SE here, can add if needed
  ) %>%
  as.data.frame()

results <- results %>%
  rename_with(~str_remove(., "statistic."), .cols = starts_with("statistic.")) %>%
  mutate(anio   = as.numeric(substr(anio_ubigeo, 1, 4)),
         ubigeo = substr(anio_ubigeo, 5, 10))

# Save results in wide CSV format
saveRDS(results, here("data_processed", "analysis", "district-year-controls.rds"))
