
# Setting the env--assume conda is installed
conda env create -f environment.yml -n climate-impacts-replication
conda activate climate-impacts

# Running the pipeline - Ingest and clean
python  01_ingest_clean/main_ingest.py
Rscript 01_ingest_clean/clean_districts.R

# Data wrangling
#Rscript 02_feature_engineering/district_population.R
#Rscript 02_feature_engineering/sinadef_collapse.R
#python  02_feature_engineering/1-extreme_weather.py
#Rscript 02_feature_engineering/2-append-extreme-weather-days.R
#Rscript 02_feature_engineering/peru-enaho/1a-enaho-households.R
#Rscript 02_feature_engineering/peru-enaho/1b-enaho-hh-members.R
#Rscript 02_feature_engineering/peru-enaho/1c-enaho-health.R
#Rscript 02_feature_engineering/peru-enaho/1d-enaho-sumaria.R
#Rscript 02_feature_engineering/peru-enaho/2-enaho-merge.R
#Rscript 02_feature_engineering/peru-enaho/3-enaho_indicators.R

# Analysis
Rscript 03_analysis/final_data.R
Rscript -e 'rmarkdown::render("03_analysis/analysis.Rmd")'
