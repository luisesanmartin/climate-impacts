library(haven)
library(dplyr)
library(stringr)
library(here)
library(purrr)

# Years
inicio <- 2022
fin    <- 2024

# Variables to keep initially
to_keep <- c("conglome", "vivienda", "hogar", "ubigeo", "dominio", "estrato", "result",
             "p103", "p110", "p111a", "p1121", "p1136", "p1137", "factor07")

# Function to process a single year
process_year <- function(i) {
  
  file <- here('data_raw', 'peru-enaho', paste0('enaho01-', i, '-100.dta'))
  df <- read_dta(file) %>%
    select(any_of(to_keep)) %>%
    
    # Keep only complete surveys
    filter(result %in% c(1, 2)) %>%
    
    # Indicators
    mutate(
      piso_tierra        = if_else(p103 %in% 6:7, 1, 0, missing = 0),
      agua_red_publica   = if_else(p110 %in% 1:2, 1, 0, missing = 0),
      desague_red_publica= if_else(p111a %in% 1:2, 1, 0, missing = 0),
      electricidad       = p1121,
      cocina_lena        = case_when(
        p1136 == 1 | p1137 == 1 ~ 1,
        p1136 == 0 & p1137 == 0 ~ 0,
        TRUE ~ NA_real_
      ),
      anio = i,
      
      # ID hogar
      id_hogar = str_c(as.character(anio), conglome, vivienda, hogar),
      
      # Dummy variables for region
      region_costa  = if_else(dominio %in% c(1,2,3,8), 1, 0),
      region_sierra = if_else(dominio %in% c(4,5,6), 1, 0),
      region_selva  = if_else(dominio == 7, 1, 0),
      
      # Departamento
      dpto = as.integer(str_sub(ubigeo, 1, 2)),
      
      # Ambito urbano/rural
      area = case_when(
        estrato %in% 1:5 ~ "Urbano",
        estrato %in% 6:8 ~ "Rural",
        TRUE ~ NA_character_
      ),
      
      # Urban/rural populations
      poblacion_rural  = if_else(area == "Rural", 1, 0, missing = 0),
      poblacion_urbana = if_else(area == "Urbano", 1, 0, missing = 0),
      
      # Removing haven_lbll types
      conglome = haven::as_factor(conglome),
      estrato  = haven::as_factor(estrato)
    ) %>%
    
    # Keep only final variables
    select(dominio, piso_tierra, agua_red_publica, desague_red_publica, electricidad,
           cocina_lena, anio, id_hogar, dpto, area, factor07,
           result, estrato, conglome, poblacion_urbana, poblacion_rural, ubigeo,
           region_costa, region_sierra, region_selva) %>%
    relocate(anio, id_hogar, ubigeo)
  
  return(df)
}

# Process all years and append
panel <- map_dfr(inicio:fin, process_year)

# Save as Stata file
saveRDS(panel,
        here('data_processed', 'intermediate', 'modulo1-hogar.rds'))