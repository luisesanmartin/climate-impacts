import cdsapi
import objects
import requests

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
