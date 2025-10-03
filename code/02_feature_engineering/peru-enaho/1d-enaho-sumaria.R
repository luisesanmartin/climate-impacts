library(haven)
library(dplyr)
library(stringr)
library(purrr)
library(here)

# Years
inicio <- 2022
fin    <- 2024

# Variables to keep initially
to_keep <- c("conglome", "vivienda", "hogar", "pobreza")

# Function to process a single year
process_year_sumaria <- function(i) {
  
  file <- here("data_raw", "peru-enaho", paste0("sumaria-", i, ".dta"))
  df <- read_dta(file) %>%
    select(any_of(to_keep)) %>%
    
    mutate(
      # Year
      anio = i,
      
      # Household ID
      id_hogar = str_c(as.character(anio), conglome, vivienda, hogar),
      
      # Poverty recodes
      pobreza_total = case_when(
        pobreza %in% c(1, 2) ~ 1,
        pobreza == 3          ~ 0,
        TRUE ~ NA_real_
      ),
      pobreza_extrema = case_when(
        pobreza == 1          ~ 1,
        pobreza %in% c(2, 3)  ~ 0,
        TRUE ~ NA_real_
      )
      
    ) %>%
    
    # Keep only final variables
    select(vivienda, hogar, anio, id_hogar,
           pobreza_total, pobreza_extrema) %>%
    relocate(anio, id_hogar)
  
  return(df)
}

# Process all years and append
panel_sumaria <- map_dfr(inicio:fin, process_year_sumaria)

# Save as Stata file
saveRDS(panel_sumaria, here("data_processed", "intermediate", "sumaria.rds"))
