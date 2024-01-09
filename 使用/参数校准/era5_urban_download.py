import cdsapi
from multiprocessing import Pool
c = cdsapi.Client()
numWorkers = 3  # 并行池个数
yearlist = [2000,2020]
monthrange = range(1,13)

inputlist = []

for i in yearlist:
    for j in  monthrange:
        tuple1 = (i,j)
        inputlist.append(tuple1)
# print(inputlist)
m29 = [str(i).zfill(2) for i in range(1, 30)]
m30 = [str(i).zfill(2) for i in range(1, 31)]
m31 = [str(i).zfill(2) for i in range(1, 32)]

def download_nc(list1):
    year = list1[0]
    month = list1[1]
    path = f'E:/run/urban/{str(year)}_{str(month)}.zip'
    print(path)
    if year % 4 == 0 and month == 2:
        monthlist = m29
    elif month in [1, 3, 5, 7, 8, 10, 12]:
        monthlist = m31
    elif month in [4, 6, 9, 11]:
        monthlist = m30
    else:
        print('error')
    c.retrieve(
        'reanalysis-era5-land',
        {
            'variable': [
                '10m_u_component_of_wind', '10m_v_component_of_wind', '2m_dewpoint_temperature',
                '2m_temperature', 'skin_temperature', 'total_precipitation',
            ],
            'year': str(year),
            'month': str(month).zfill(2),
            'day': monthlist,
            'time': [
                '00:00', '01:00', '02:00',
                '03:00', '04:00', '05:00',
                '06:00', '07:00', '08:00',
                '09:00', '10:00', '11:00',
                '12:00', '13:00', '14:00',
                '15:00', '16:00', '17:00',
                '18:00', '19:00', '20:00',
                '21:00', '22:00', '23:00',
            ],
            'area': [
                40.7, 103.9, 33.6,
                113.6,
            ],
            'format': 'netcdf.zip',
        },
        path)
if __name__ == "__main__":
    with Pool(numWorkers) as pool:
        pool.map(download_nc, inputlist)
    print('操作完成')