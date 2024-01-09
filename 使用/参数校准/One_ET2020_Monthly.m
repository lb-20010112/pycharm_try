% �����ļ���·�����洢2020��ÿ���ET���ݵ�TIFF�ļ�
folderPath = 'H:\Liubo\ET\PML2.0_China\2020BiasCorrectedInputs';

% ����ÿ���µ�����
daysPerMonth = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

% ����ÿ�����ε�����������ʵ����������޸ģ�
esBandIndex = 3; 
ecBandIndex = 2; 
eiBandIndex = 4; 
%��ȡ��һ��TIFF�ļ��Ĵ�С
firstTiffFileName = dir(fullfile(folderPath, '*.tif'));
firstTiffFilePath = fullfile(folderPath, firstTiffFileName(1).name);
Info = imfinfo(firstTiffFilePath);
dataSize = [Info.Height, Info.Width];

info = geotiffinfo(firstTiffFilePath);
R = info.RefMatrix;

monthETData = zeros(dataSize(1), dataSize(2), 12);

for month = 1:12
    % ������·ݵ�������
    totalDays = daysPerMonth(month);
    
    % ��ʼ���洢���·����������ĸ��������ݾ���
    monthEiData = zeros(dataSize(1), dataSize(2), totalDays);
    monthEsData = zeros(dataSize(1), dataSize(2), totalDays);
    monthEcData = zeros(dataSize(1), dataSize(2), totalDays);
    
    % ѭ����ȡ���·ݵ�ÿ������
    for day = 1:totalDays
        % ������ǰ���ڵ��ļ���
        fileName = sprintf('clip%04d-%02d-%02d.tif', 2020, month, day);
        
        % ��ȡTIFF�ļ��еĸ���������
        filePath = fullfile(folderPath, fileName);
        data = imread(filePath);
        eiData = data(:,:,eiBandIndex); % ��ȡ Ei ��������
        ecData = data(:,:,ecBandIndex); % ��ȡ Ec ��������
        esData = data(:,:,esBandIndex); % ��ȡ Es ��������
        
        % ��������ӵ����������ݾ�����
        monthEiData(:,:,day) = eiData;
        monthEsData(:,:,day) = esData;
        monthEcData(:,:,day) = ecData;
    end
    
    % ��ÿ���������ݽ��мӺ�
    eiTotal = sum(monthEiData, 3);
    esTotal = sum(monthEsData, 3);
    ecTotal = sum(monthEcData, 3);
  
  
    % ����ÿ���·ݵ�ET��ֵ��Ȼ�󵼳�ΪTIFF�ļ�
    monthlyTotal = 0.01*(eiTotal + esTotal + ecTotal);
    
    monthETData(:,:,month) =monthlyTotal;
end
tiffFileName = sprintf('Monthly_ET_Total_%04d.tif', 2020);
tiffFilePath = fullfile(folderPath, tiffFileName);
geotiffwrite(tiffFilePath,monthETData,R);
