import sys
import os
sys.path.insert(0, '99_utils')
import utils
import objects

data_raw_folder = objects.DATA_RAW 
peru_adm3_url   = objects.PERU_ADM3_GEOJSON
era5_raw        = objects.ERA5_RAW

def main():

    utils.download_save(peru_adm3_url, data_raw_folder)
    #utils.era5_data()
    #os.rename(era5_raw, f'{data_raw_folder}/{era5_raw}')


if __name__ == '__main__':
    main()