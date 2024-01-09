% 定义文件夹路径，存储2020年每天的ET数据的TIFF文件
folderPath = 'H:\Liubo\ET\PML2.0_China\2020BiasCorrectedInputs';

% 定义每个月的天数
daysPerMonth = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

% 定义每个波段的索引（根据实际情况进行修改）
esBandIndex = 3; 
ecBandIndex = 2; 
eiBandIndex = 4; 
%获取第一个TIFF文件的大小
firstTiffFileName = dir(fullfile(folderPath, '*.tif'));
firstTiffFilePath = fullfile(folderPath, firstTiffFileName(1).name);
Info = imfinfo(firstTiffFilePath);
dataSize = [Info.Height, Info.Width];

info = geotiffinfo(firstTiffFilePath);
R = info.RefMatrix;

monthETData = zeros(dataSize(1), dataSize(2), 12);

for month = 1:12
    % 计算该月份的总天数
    totalDays = daysPerMonth(month);
    
    % 初始化存储该月份所有天数的各波段数据矩阵
    monthEiData = zeros(dataSize(1), dataSize(2), totalDays);
    monthEsData = zeros(dataSize(1), dataSize(2), totalDays);
    monthEcData = zeros(dataSize(1), dataSize(2), totalDays);
    
    % 循环读取该月份的每天数据
    for day = 1:totalDays
        % 构建当前日期的文件名
        fileName = sprintf('clip%04d-%02d-%02d.tif', 2020, month, day);
        
        % 读取TIFF文件中的各波段数据
        filePath = fullfile(folderPath, fileName);
        data = imread(filePath);
        eiData = data(:,:,eiBandIndex); % 读取 Ei 波段数据
        ecData = data(:,:,ecBandIndex); % 读取 Ec 波段数据
        esData = data(:,:,esBandIndex); % 读取 Es 波段数据
        
        % 将数据添加到各波段数据矩阵中
        monthEiData(:,:,day) = eiData;
        monthEsData(:,:,day) = esData;
        monthEcData(:,:,day) = ecData;
    end
    
    % 对每个波段数据进行加和
    eiTotal = sum(monthEiData, 3);
    esTotal = sum(monthEsData, 3);
    ecTotal = sum(monthEcData, 3);
  
  
    % 计算每个月份的ET总值，然后导出为TIFF文件
    monthlyTotal = 0.01*(eiTotal + esTotal + ecTotal);
    
    monthETData(:,:,month) =monthlyTotal;
end
tiffFileName = sprintf('Monthly_ET_Total_%04d.tif', 2020);
tiffFilePath = fullfile(folderPath, tiffFileName);
geotiffwrite(tiffFilePath,monthETData,R);
