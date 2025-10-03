#!/usr/bin/env python
# coding: utf-8

import xarray as xr
import geopandas as gpd
from itertools import product
import numpy as np
import multiprocessing

import sys
sys.path.insert(0, '99_utils')
import utils
import objects



def main():

    # # Grid (climate) data
    file = f'{objects.DATA_RAW}/{objects.ERA5_RAW}'
    ds = xr.open_dataset(file, engine='cfgrib')

    # # Geojson (district) data
    file = f'{objects.DATA_PROCESSED}/{objects.DISTRICTS_CLEAN}'
    gdf = gpd.read_file(file)
    gdf['centroid'] = gdf['geometry'].centroid

    # dict of districts with centroids
    centroids = {row['ubigeo']: (row['centroid'].x, row['centroid'].y) for _, row in gdf.iterrows()}

    # We divide the centroids dictionary in groups to parallelize processing
    groups = [
        {district: centroid for district, centroid in list(centroids.items())[:100]},
        {district: centroid for district, centroid in list(centroids.items())[100:200]},
        {district: centroid for district, centroid in list(centroids.items())[200:300]},
        {district: centroid for district, centroid in list(centroids.items())[300:400]},
        {district: centroid for district, centroid in list(centroids.items())[400:500]},
        {district: centroid for district, centroid in list(centroids.items())[500:600]},
        {district: centroid for district, centroid in list(centroids.items())[600:700]},
        {district: centroid for district, centroid in list(centroids.items())[700:800]},
        {district: centroid for district, centroid in list(centroids.items())[800:900]},
        {district: centroid for district, centroid in list(centroids.items())[900:1000]},
        {district: centroid for district, centroid in list(centroids.items())[1000:1100]},
        {district: centroid for district, centroid in list(centroids.items())[1100:1200]},
        {district: centroid for district, centroid in list(centroids.items())[1200:1300]},
        {district: centroid for district, centroid in list(centroids.items())[1300:1400]},
        {district: centroid for district, centroid in list(centroids.items())[1400:1500]},
        {district: centroid for district, centroid in list(centroids.items())[1500:1600]},
        {district: centroid for district, centroid in list(centroids.items())[1600:1700]},
        {district: centroid for district, centroid in list(centroids.items())[1700:1800]},
        {district: centroid for district, centroid in list(centroids.items())[1800:]},
    ]

    inputs = []
    for i, group in enumerate(groups):
        inputs.append([group, objects.N_CLOSEST, ds, i])

    with multiprocessing.Pool(processes=16) as pool:
        pool.starmap(utils.days_extreme_weather, inputs)

if __name__ == '__main__':
    main()