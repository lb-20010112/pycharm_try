

import xarray as xr

for p in range(1, 9):
    if p == 1:
        yearlist = [2006, 2007]
    elif p == 2:
        yearlist = [2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020]
    elif p == 3:
        yearlist = [2017, 2018]
    elif p == 4:
        yearlist = [2016, 2017]
    elif p == 5:
        yearlist = [2020, 2021]
    elif p == 6:
        yearlist = [2019, 2020, 2021]
    elif p == 7:
        yearlist = [2014, 2015, 2016]
    elif p == 8:
        yearlist = [2015, 2016, 2017, 2018]
    for year in yearlist:
        outputfile = 'E:\ET_Point_data\\nc_point\\result\\{}_{}.nc'.format(p, year)
        ds_merged = None
        # 循环遍历每个文件夹
        for month in range(1,13):


            # 构建当前文件夹的路径
           #folder_path = os.path.join(parent_folder, f'folder{i}')

            # 读取NC文件
            file_path = r'E:\ET_Point_data\\nc_point\\out{}_{}{}.nc'.format(p,year,str(month).zfill(2))
            ds = xr.open_dataset(file_path)

            # 合并数据集
            if ds_merged is None:
                ds_merged = ds
            else:
                ds_merged = xr.concat([ds_merged, ds], dim='time')

            # 输出合并后的数据集信息
            print(ds_merged)

            # 输出合并后的数据集的时间维度大小
            print('时间维度大小:', ds_merged.time.size)
            ds_merged.to_netcdf(outputfile)
            print('合成完毕')

# import xarray as xr
# import pandas as pd
# nc_file = r"E:\data\ncdata\nc2000\out20008.nc" #输入文件路径
# ds = xr.open_dataset(nc_file)
# d2m = pd.DataFrame(ds["ea"].data[200:240,11,16])
# print('d2m:\t',d2m)

# import xarray as xr
# import pandas as pd
# # 文件路径
# file1 = r"H:\Liubo\Point_iulai\data\ncdata\2019\2019.nc"
# file2 = r"H:\Liubo\Point_iulai\data\ncdata\2020\2020.nc"
#
# outputFile = 'H:\Liubo\Point_iulai\data\\ncdata\\2019_2020.nc'
#
#
# ds1 = xr.open_dataset(file1)
# ds2 = xr.open_dataset(file2)
#
# #将两个文件按时间维度进行连接
# merged_ds = xr.concat([ds1,ds2], dim='time')
#
# #写入连接后的数据到新的 NetCDF 文件
# merged_ds.to_netcdf(outputFile)
#
# print('文件合并完成。')