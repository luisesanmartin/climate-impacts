import cdsapi
import objects
import requests
import numpy as np
import csv

def download_save(url, path):

    response = requests.get(url)
    response.raise_for_status()
    print(response.status_code)

    file_name = url.split('/')[-1]
    full_path = f'{path}/{file_name}'

    with open(full_path, 'wb') as f:
        for chunk in response.iter_content(chunk_size=8192):
            f.write(chunk)

    return True

def era5_data():

    dataset = "reanalysis-era5-single-levels"
    request = {
    "product_type": ["reanalysis"],
    "variable": ["2m_temperature"],
    "year": ["2022", "2023", "2024"],
    "month": [
        "01", "02", "03",
        "04", "05", "06",
        "07", "08", "09",
        "10", "11", "12"
    ],
    "day": [
        "01", "02", "03",
        "04", "05", "06",
        "07", "08", "09",
        "10", "11", "12",
        "13", "14", "15",
        "16", "17", "18",
        "19", "20", "21",
        "22", "23", "24",
        "25", "26", "27",
        "28", "29", "30",
        "31"
    ],
    "time": ["00:00", "12:00"],
    "data_format": "grib",
    "download_format": "unarchived",
    "area": [-0.03860596799995619, -81.32823048999995, -18.35092773599996, -68.65227910299996]
}

    client = cdsapi.Client()
    client.retrieve(dataset, request).download()

def extract_by_closest_points_in_grid(coordinate, n, ds):

    lon, lat = coordinate
    
    # Compute distance to the target point for each grid point
    dist = np.sqrt((ds.latitude - lat)**2 + (ds.longitude - lon)**2)

    # Find indices of the n closest points
    closest_idx = np.unravel_index(np.argsort(dist.values, axis=None)[:n], dist.shape)

    # Select the closest points
    closest = ds.isel(latitude=closest_idx[0], longitude=closest_idx[1])

    return closest

def days_extreme_weather(
    centroids, 
    n_closest_points, 
    ds, 
    block = 1,
    year_start = objects.START,
    year_end = objects.END,
    folder = f'{objects.DATA_INTERMEDIATE}/extreme-weather-days'
    ):

    results = []

    for year in range(year_start, year_end+1):

        for district, coordinate in centroids.items():

            sub_ds = extract_by_closest_points_in_grid(coordinate, n_closest_points, ds)
            temp = sub_ds[objects.TEMP_ATTRIBUTE].sel(time=ds['time'].dt.year == year) - 270

            mean = temp.mean().item()
            sd   = temp.std().item()

            upper = mean + (3 * sd)
            lower = mean - (3 * sd)

            # Days with extreme weather
            above = int((temp > upper).sum().item())
            below = int((temp < lower).sum().item())

            results.append([year, district, above + below])

    filename = f'{folder}/extreme-weather{block}.csv'

    with open(filename, 'w', newline='') as f:

        writer = csv.writer(f)
        writer.writerow(objects.headers)
        writer.writerows(results)

    print(f'Finished geoprocessing of block {block}')

    return True