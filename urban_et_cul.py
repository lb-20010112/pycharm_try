import numpy as np
from netCDF4 import Dataset

# File path to the NetCDF data
ncdata = 'C:\\Users\lb\Desktop/data.nc'

# Read NetCDF data
with Dataset(ncdata, 'r') as nc:
    lst = nc.variables['skt'][:]
    d2m = nc.variables['t2m'][:]
    u10 = nc.variables['u10'][:]
    v10 = nc.variables['v10'][:]
    tp = nc.variables['tp'][:]
    lat = nc.variables['latitude'][:]
    lon = nc.variables['longitude'][:]

# Constants
rhoair = 1.255  # 空气密度
psur = 1000      # 大气压强
cpair = 1010     # 空气比热

# Read CSV data
ll = np.loadtxt('E:/run/LC_ll/LC_ll2020/FEN.csv', delimiter=',')
longitudes = ll[:, 0]
latitudes = ll[:, 1]

# Initialize variables
capac = 0

# Loop over city locations
for num in range(len(longitudes)):

    # Find nearest grid cell indices
    # print(np.abs(lat - latitudes[num]))
    latIndex = np.argmin(np.abs(lat - latitudes[num]))
    lonIndex = np.argmin(np.abs(lon - longitudes[num]))
    print(latIndex)
    print(lonIndex)
    nearestlstValue = lst[:,latIndex,lonIndex,]
    print(lst.shape)
    print(nearestlstValue)
    nearestd2mValue = d2m[:,latIndex,lonIndex,]
    nearesttpValue = tp[:,latIndex,lonIndex,]
    nearestu10Value = u10[:,latIndex,lonIndex,]
    nearestv10Value = v10[:,latIndex,lonIndex,]
    # Output array initialization
    output = np.zeros((nearestd2mValue.size, 2))
    #Loop over time steps
    for i in range(nearestd2mValue.size):
        tm = nearestd2mValue[i]
        lst1 = nearestlstValue[i]
        tp1 = nearesttpValue[i]
        u1 = nearestu10Value[i]
        v1 = nearestv10Value[i]
        u2 = np.sqrt(u1**2 + v1**2)

        water = tp1 + capac
        capac = min(0.0003, water)

        ea = np.exp(21.18123 - 5418. / lst1) / 0.622
        er = 6.108 * np.exp(17.27 * (tm - 273.15) / (tm - 273.15 + 237.3))
        ra = ((np.log(10000 / 1.37))**2 * 4.72) / (1 + 0.536 * u2)

        hlat = (3150.19 - 2.378 * tm) * 1000
        psy = (cpair * psur) / (0.622 * hlat)
        et0 = (ea - er) * cpair * rhoair / (hlat * ra * psy)

        et = min(et0, capac)
        capac = capac - et

        output[i, 0] = et0
        output[i, 1] = et
print(output)