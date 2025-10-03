# URLs
PERU_ADM3_GEOJSON = 'https://data.humdata.org/dataset/54fc7f4d-f4c0-4892-91f6-2fe7c1ecf363/resource/63cc642a-2957-4f25-8a17-086c99d275e8/download/per_adm_ign_20200714_shp.zip'

# Paths (defined with respect to /code)
DATA_RAW       = '../data_raw'
DATA_PROCESSED = '../data_processed'
DATA_INTERMEDIATE = '../data_processed/intermediate'

# File names
ERA5_RAW        = '269c15be7865b6c32e03872748bb00d7.grib'
DISTRICTS_CLEAN = 'peru_districts.geojson'

# Globals
ERA5_GRID = 0.25 # grades of difference between grid points
N_CLOSEST = 4    # closest points to the district centroid we want to get
START = 2022     # start year of analysis
END = 2024       # end year
TEMP_ATTRIBUTE = 't2m'
headers = ['year', 'district', 'days_extreme']