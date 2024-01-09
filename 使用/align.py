import os

folder_path = "C:\\Users\lb\Desktop\SEBSModis\\add"  # 用你实际文件夹的路径替换这里

# 使用os.listdir()函数列出文件夹内的所有文件和子文件夹
files_in_folder = os.listdir(folder_path)

# 筛选出只有文件而不包括子文件夹的名称
file_names = [file for file in files_in_folder if os.path.isfile(os.path.join(folder_path, file))]

# # 打印文件名称列表
# for file_name in file_names:
#     print(file_name)

print(file_names)
modeltif = 'C:\\Users\lb\Desktop\SEBSEra5\\demm.tif'
import arcpy
for i in file_names:
    inputtif = folder_path + '\\'+i
    print(inputtif)
    out = 'C:\\Users\lb\Desktop\output'+ '\\'+i
    print(out)

    with arcpy.EnvManager(
            cellSizeProjectionMethod="CENTER_OF_EXTENT",#"PRESERVE_RESOLUTION",
            snapRaster=modeltif,
            cellSize=modeltif,
            mask=modeltif):
        out_raster = arcpy.sa.ExtractByMask(
            inputtif,
            modeltif,
            "INSIDE",
            '100.499022410871 31.499425437651 115.000526042413 41.5001898326968 GEOGCS["GCS_WGS_1984",DATUM["D_WGS_1984",SPHEROID["WGS_1984",6378137.0,298.257223563]],PRIMEM["Greenwich",0.0],UNIT["Degree",0.0174532925199433]]');
        out_raster.save(out)

    print('tif文件对齐完成')