import sys
import os
sys.path.insert(0, '99_utils')
import utils
import objects

data_raw_folder = objects.DATA_RAW
data_processed  = 
peru_adm3_url   = objects.PERU_ADM3_GEOJSON

def main():

    utils.download_save(peru_adm3_url, data_raw_folder)
    #utils.era5_data()
    #os.rename('269c15be7865b6c32e03872748bb00d7.grib', 
    #    f'{data_raw_folder}/269c15be7865b6c32e03872748bb00d7.grib')


if __name__ == '__main__':
    main()