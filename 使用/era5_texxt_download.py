import cdsapi

c = cdsapi.Client()

for p in range(1, 9):
    if p == 1:
        yearlist = [2006, 2007]
        zone = [36.9, 109.3, 36.6,109.4,]
    elif p == 2:
        yearlist = [2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020]
        zone = [37.8,101.2,37.5,101.5]
    elif p == 3:
        yearlist = [2017, 2018]
        zone = [39.6,111.8,39.4,120.0]
    elif p == 4:
        yearlist = [2016, 2017]
        zone = [35.1, 112.3, 34.9, 112.6]
    elif p == 5:
        yearlist = [2020, 2021]
        zone = [40.6, 116.5, 40.3, 116.8]
    elif p == 6:
        yearlist = [2019, 2020, 2021]
        zone = [35.8, 107.7, 35.5, 108.0]
    elif p == 7:
        yearlist = [2014, 2015, 2016]
        zone = [38, 114.5, 37.7, 114.8]
    elif p == 8:
        yearlist = [2015, 2016, 2017, 2018]
        zone = [41.8, 110.2, 41.5, 110.5]
    for year in yearlist:
        for month in range(1, 13):
            path = f'E:\\ET_Point_data\\nc_point\\{p}_{year}{str(month).zfill(2)}.zip'
            print(path)
            m28 = [
                '01', '02', '03',
                '04', '05', '06',
                '07', '08', '09',
                '10', '11', '12',
                '13', '14', '15',
                '16', '17', '18',
                '19', '20', '21',
                '22', '23', '24',
                '25', '26', '27',
                '28',
            ]
            m29 = [
                '01', '02', '03',
                '04', '05', '06',
                '07', '08', '09',
                '10', '11', '12',
                '13', '14', '15',
                '16', '17', '18',
                '19', '20', '21',
                '22', '23', '24',
                '25', '26', '27',
                '28', '29',
            ]
            m30 = [
                '01', '02', '03',
                '04', '05', '06',
                '07', '08', '09',
                '10', '11', '12',
                '13', '14', '15',
                '16', '17', '18',
                '19', '20', '21',
                '22', '23', '24',
                '25', '26', '27',
                '28', '29', '30',
            ]
            m31 = [
                '01', '02', '03',
                '04', '05', '06',
                '07', '08', '09',
                '10', '11', '12',
                '13', '14', '15',
                '16', '17', '18',
                '19', '20', '21',
                '22', '23', '24',
                '25', '26', '27',
                '28', '29', '30', '31',
            ]
            if year % 4 == 0 and month == 2:
                monthlist = m29
            elif year % 4 != 0 and month == 2:
                monthlist = m28
            elif month in [1, 3, 5, 7, 8, 10, 12]:
                monthlist = m31
            elif month in [4, 6, 9, 11]:
                monthlist = m30
            else:
                print('error')
            print(monthlist)
            c.retrieve(
                'reanalysis-era5-land',
                {
                    'variable': [
                        '10m_u_component_of_wind', '10m_v_component_of_wind', '2m_dewpoint_temperature',
                        '2m_temperature', 'surface_solar_radiation_downwards', 'surface_thermal_radiation_downwards',
                        'total_precipitation',
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
                    'area': zone,
                    'format': 'netcdf.zip',
                },
                path)
