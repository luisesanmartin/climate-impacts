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