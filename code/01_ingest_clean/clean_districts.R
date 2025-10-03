library(sf)
library(here)

temp <- tempfile()

unzip(zipfile = here('data_raw', 'per_adm_ign_20200714_shp.zip'),
      exdir = temp)

df <- read_sf(temp, layer='per_admbnda_adm3_ign_20200714') %>%
  janitor::clean_names()

df2 <- df%>%
  select(ubigeo = adm3_pcode,
         dpto = adm1_es,
         prov = adm2_es,
         dist = adm3_es) %>%
  mutate(ubigeo = substr(ubigeo, 3, 8))

st_write(df2, 
         here('data_processed', 'intermediate', 'peru_districts.geojson'),
         append = FALSE)