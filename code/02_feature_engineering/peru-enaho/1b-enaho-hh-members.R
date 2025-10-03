library(haven)
library(dplyr)
library(purrr)
library(here)

# Years
inicio <- 2022
fin    <- 2024

# Variables to keep initially
to_keep <- c("conglome", "vivienda", "hogar", "codperso", "p207", 
             "facpob07", "p204", "p208a", "p205", "p206")

# Function to process a single year

process_year_miembros <- function(year) {
  
  # Load dataset
  file <- here("data_raw", "peru-enaho", paste0("enaho01-", year, "-200.dta"))
  data <- read_dta(file) %>%
    
    # Keep selected variables
    select(any_of(to_keep)) %>%
    
    # Keep only household members
    filter(p204 == 1) %>%
    
    # Create indicators
    mutate(
      anio = year,
      id_hogar   = paste0(anio, conglome, vivienda, hogar),
      id_persona = paste0(id_hogar, codperso),
      
      # Dummy variables for sex
      hombre = if_else(p207 == 1, 1, 0),
      mujer  = if_else(p207 == 2, 1, 0),
      
      # Dummy variables for grupo_edad
      edad_0_18   = if_else(p208a >= 0 & p208a <= 18, 1, 0),
      edad_19_65  = if_else(p208a >= 19 & p208a <= 65, 1, 0),
      edad_65_mas = if_else(p208a >= 65, 1, 0),
      
    ) %>%
    
    # Keep final variables
    select(id_hogar, id_persona, hombre, mujer, facpob07, 
           anio, edad_0_18, edad_19_65, edad_65_mas) %>%
    arrange(anio, id_hogar, id_persona)
  
  return(data)
}

# Apply across years and stack results
miembros <- map_dfr(inicio:fin, process_year_miembros)

# Save final dataset
saveRDS(miembros, 
        here("data_processed", "intermediate", "modulo2-miembros_del_hogar.rds"))
