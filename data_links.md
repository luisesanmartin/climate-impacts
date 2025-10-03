# Datasets

## 1. SINADEF - Peru Deaths Information System

- **Source**: Ministry of Health of Peru
- **Method of access:** manual download
- **Direct URL**: https://files.minsa.gob.pe/s/Ae52gBAMf9aKEzK/download/SINADEF_DATOS_ABIERTOS.csv
- Data license is not mentioned in the website

## 2. District population

- **Source**: National Institute of Statistics of Peru
- **Method of access:** manual selection of variables and download
- **Instructions:** go to https://estadist.inei.gob.pe/report, under "Indice Tematico" select "Demografico" >> "Poblacion Proyectada" >> "Poblacion Total" >> "Poblacion Proyectada" and click the plus symbol. Once the data loads, click the download icon
- Data license is not mentioned in the website

## 3. ENAHO - National Household Survey

- **Source:** National Institute of Statistics of Peru
- **Method of access:** manual selection of survey modules and download
- **Instructions:** go to https://proyectos.inei.gob.pe/microdatos/ >> Consulta por Encuestas >> Select "ENAHO metodologia actualizada" >> Condiciones de vida y pobreza - ENAHO >> 2022 >> Anual (Ene-Dic). Download the zip file for "Características de la Vivienda y del Hogar", "Características de los Miembros del Hogar", and "Sumarias (Variables Calculadas)". Unzip the file to access the data. Repeat for years 2023 and 2024.
- Data license is not mentioned in the website

## 4. Peru ADM3 boundaries

- **Source:** Humanitarian Data Exchange
- **Method of access:** direct programmatic download with the script "main_ingest.py"
- **Data URL:** https://data.humdata.org/dataset/cod-ab-per
- **License:** Creative Commons Attribution 4.0 International license.

## 5. ERA5 hourly data on single levels from 1940 to present:

- **Source:** Copernicus Programme of the European Union
- **Method of access:** data was collected using the ERA5 download tool for API requests. Data requires an account and API key to be accessed this way.
- **Data selection:**
  - Product type: reanalysis
  - Variable: 2m temperature
  - Year: 2022, 2023, 2024
  - Month: all
  - Day: all
  - Time: 00:00, 12:00
  - sub-region extraction:
    - North: -0.03860596799995619
    - West: -81.32823048999995
    - East: -68.65227910299996
    - South: -18.35092773599996
- **License:** Creative Commons Attribution 4.0 International license.