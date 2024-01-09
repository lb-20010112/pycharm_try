% �����ļ���·�����洢2020��ÿ���ET���ݵ�TIFF�ļ�
folderPath = 'H:\Liubo\ET\PML2.0_China\2020BiasCorrectedInputs';


%��ȡ��һ��TIFF�ļ��Ĵ�С
firstTiffFileName = dir(fullfile(folderPath, '*.tif'));
firstTiffFilePath = fullfile(folderPath, firstTiffFileName(1).name);
Info = imfinfo(firstTiffFilePath);
dataSize = [Info.Height, Info.Width];

info = geotiffinfo(firstTiffFilePath);
R = info.RefMatrix;
data =  zeros(dataSize(1), dataSize(2), 12);
for month = 1:12

    
    % ��ʼ���洢���·����������ĸ��������ݾ���
    Data = zeros(dataSize(1), dataSize(2),12);
    % ������ǰ���ڵ��ļ���
    fileName = sprintf('Monthly_ET_Total_%04d%02d.tif', 2020, month);
    %��ȡÿ����ET
    filePath = fullfile(folderPath,fileName);
    monthdata = imread(filePath);
    monthdata = monthdata(:,:,1);
    data(:,:,month) = monthdata;
    
end

yeardata = sum(data,3);
tiffFileName = sprintf('Yearly_ET_Total_%04d.tif', 2020);
    
tiffFilePath = fullfile(folderPath, tiffFileName);
geotiffwrite(tiffFilePath,yeardata,R);