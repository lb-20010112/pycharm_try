% 定义文件夹路径，存储2020年每天的ET数据的TIFF文件
folderPath = 'H:\Liubo\ET\PML2.0_China\2020BiasCorrectedInputs';


%获取第一个TIFF文件的大小
firstTiffFileName = dir(fullfile(folderPath, '*.tif'));
firstTiffFilePath = fullfile(folderPath, firstTiffFileName(1).name);
Info = imfinfo(firstTiffFilePath);
dataSize = [Info.Height, Info.Width];

info = geotiffinfo(firstTiffFilePath);
R = info.RefMatrix;
data =  zeros(dataSize(1), dataSize(2), 12);
for month = 1:12

    
    % 初始化存储该月份所有天数的各波段数据矩阵
    Data = zeros(dataSize(1), dataSize(2),12);
    % 构建当前日期的文件名
    fileName = sprintf('Monthly_ET_Total_%04d%02d.tif', 2020, month);
    %读取每月总ET
    filePath = fullfile(folderPath,fileName);
    monthdata = imread(filePath);
    monthdata = monthdata(:,:,1);
    data(:,:,month) = monthdata;
    
end

yeardata = sum(data,3);
tiffFileName = sprintf('Yearly_ET_Total_%04d.tif', 2020);
    
tiffFilePath = fullfile(folderPath, tiffFileName);
geotiffwrite(tiffFilePath,yeardata,R);