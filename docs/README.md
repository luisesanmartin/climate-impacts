# README - Exploring the Effect of Extreme Weather on Total Deaths

This replication package reproduces the data pipeline and results for the analysis "Exploring the Effect of Extreme Weather on Total Deaths".

All data sources and access are detailed in "data_links.md". The replication package includes intermediate data that reproduces the main regression of the analysis.

## Running the code

1. Open a terminal with conda activated
2. Navigate to the folder "code"
3. Run "bash run.sh"

This will recreate the conda environment used and run all the scripts for the analysis. The script has some lines deactivated for when the scripts sourced used raw data that the user might not have collected. Once all data are collected following the access of "data_links.md", all lines in "run.sh" can be activated and run.

This replication package is also available here: https://github.com/luisesanmartin/climate-impacts/