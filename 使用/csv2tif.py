from osgeo import gdal, osr
import numpy as np
import pandas as pd
# 读取模板TIFF文件
template_tiff = 'F:\\LiuBo\\run\\data\\soil\\bee.tif'
template_dataset = gdal.Open(template_tiff)
template_projection = template_dataset.GetProjection()
template_geo_transform = template_dataset.GetGeoTransform()

list1 = ['Shrub','FEN','FDB','Grass','Crop']
list2 = ['et','sm']
for i in list1:
    # 读取CSV文件
    csv_file = 'F:\\LiuBo\\run\\2020resultcsv\\'+i+'out.csv'
    print(csv_file)
    # data = np.loadtxt(csv_file)
    data = pd.read_csv(csv_file)

    # 提取经纬度和数值
    # values = data.iloc[:, 1]
    longitude = data.iloc[:, 2]
    latitude = data.iloc[:, 3]
    et = data.iloc[:, 4]
    sm = data.iloc[:, 5]

    # 获取经纬度范围
    min_lon, max_lon = min(longitude), max(longitude)
    min_lat, max_lat = min(latitude), max(latitude)
    for j in list2:
        # 创建新的TIFF文件
        output_tiff = 'F:\\LiuBo\\run\\2020resultcsv\\'+i+j+'.tif'
        num_cols = template_dataset.RasterXSize
        num_rows = template_dataset.RasterYSize
        new_values = np.full((num_rows, num_cols), np.nan, dtype=np.float32)
        if j == 'et':
            values = et
        elif j == 'sm':
            values = sm
        # 将数值填充到新的TIFF文件中
        for lon, lat, value in zip(longitude, latitude, values):
            col = int((lon - template_geo_transform[0]) / template_geo_transform[1])
            row = int((lat - template_geo_transform[3]) / template_geo_transform[5])
            new_values[row, col] = value

        # 写入新的TIFF文件
        driver = gdal.GetDriverByName('GTiff')
        output_dataset = driver.Create(output_tiff, num_cols, num_rows, 1, gdal.GDT_Float32)
        output_dataset.SetGeoTransform(template_geo_transform)
        output_dataset.SetProjection(template_projection)

        band = output_dataset.GetRasterBand(1)
        band.WriteArray(new_values)
        band.FlushCache()

        # 关闭文件
        output_dataset = None
template_dataset = None

print('TIFF文件已创建成功！')
