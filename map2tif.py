from osgeo import gdal
import pcraster as pcr
from osgeo import osr
gdal.UseExceptions()

# PCRaster地图文件路径
pcr_map_file = "ndvi.map"

# 模板TIFF文件路径，包含了需要的元数据
template_tiff_file = "p.tif"

# 输出的TIFF文件路径
tiff_file = "output.tif"

# 读取PCRaster地图
pcr_map = pcr.readmap(pcr_map_file)

# 打开模板TIFF文件以获取元数据
template_dataset = gdal.Open(template_tiff_file)
print(1)
print(template_dataset)
rows = template_dataset.RasterYSize
cols = template_dataset.RasterXSize
west, cell_size, _, north, _, neg_cell_size = template_dataset.GetGeoTransform()

# 创建一个新的TIFF文件
driver = gdal.GetDriverByName("GTiff")
dataset = driver.Create(tiff_file, cols, rows, 1, gdal.GDT_Float32)

# 设置地理坐标信息和投影信息
dataset.SetGeoTransform([west, cell_size, 0, north, 0, neg_cell_size])
srs = osr.SpatialReference()
srs.ImportFromEPSG(4326)  # 使用WGS 84坐标系，根据需要更改EPSG代码
dataset.SetProjection(srs.ExportToWkt())

# 写入PCRaster地图数据到TIFF文件
band = dataset.GetRasterBand(1)
band.WriteArray(pcr.pcr2numpy(pcr_map, -9999))

# 关闭文件
dataset = None

print("PCRaster地图已成功转换为TIFF文件.")
