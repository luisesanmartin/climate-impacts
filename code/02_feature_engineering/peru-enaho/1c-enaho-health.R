library(haven)
library(dplyr)
library(stringr)
library(purrr)
library(here)

# Years
inicio <- 2022
fin    <- 2024

# Variables to keep initially
to_keep <- c("conglome", "vivienda", "hogar", "codperso",
             "p401", "p4191", "p4192", "p4193", "p4194",
             "p4195", "p4196", "p4197", "p4198")

# Function to process a single year
process_year_salud <- function(i) {
  
  file <- here("data_raw", "peru-enaho", paste0("enaho01a-", i, "-400.dta"))
  df <- read_dta(file) %>%
    select(any_of(to_keep)) %>%
    
    mutate(
      # Year
      anio = i,
      
      # IDs
      id_hogar   = str_c(as.character(anio), conglome, vivienda, hogar),
      id_persona = str_c(id_hogar, codperso),
      
      # Enfermedad o malestar crónico
      enfermedad = if_else(p401 == 1, 1,
                           if_else(p401 == 2, 0, NA_real_)),
      
      # Seguro de salud (any of the 8 == 1)
      seguro_de_salud = case_when(
        p4191 == 1 | p4192 == 1 | p4193 == 1 | p4194 == 1 |
          p4195 == 1 | p4196 == 1 | p4197 == 1 | p4198 == 1 ~ 1,
        p4191 == 2 & p4192 == 2 & p4193 == 2 & p4194 == 2 &
          p4195 == 2 & p4196 == 2 & p4197 == 2 & p4198 == 2 ~ 0,
        TRUE ~ NA_real_
      )
    ) %>%
    
    # Keep only final vars
    select(anio, id_hogar, id_persona, enfermedad, seguro_de_salud)
  
  return(df)
}

# Process all years and append
panel_salud <- map_dfr(inicio:fin, process_year_salud)

# Save as Stata file
saveRDS(panel_salud, here("data_processed", "intermediate", "modulo4-salud.rds"))
