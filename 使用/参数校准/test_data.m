ll = csvread('C:\Users\DELL\Desktop\5���\Final\FDB.csv');

longitudes = ll(:, 2); % ��һ���Ǿ���
latitudes = ll(:, 1); % �ڶ���ά��

infoET_M = geotiffinfo('H:\Liubo\Clibrate_Forest_9 _text - ����\data\TEST\et2020M.tif');
R = infoET_M.RefMatrix;
dataET_M = imread('H:\Liubo\Clibrate_Forest_9 _text - ����\data\TEST\et2020M.tif');
dataET_Y = imread('H:\Liubo\Clibrate_Forest_9 _text - ����\data\TEST\et2020y.tif');

info_SMM = geotiffinfo('H:\Liubo\soil_moisture\SM.1KM\2020\SM_2020.tif');
R1 =info_SMM.RefMatrix;
data_SMM = imread('H:\Liubo\soil_moisture\SM.1KM\2020\SM_2020.tif');
%%%%%%%%%%%%%%
Lai19 = 'H:\Liubo\Clibrate_Forest_9 _text_year\data\LP\MmaxLai_19.tif';
infolai19 = geotiffinfo(Lai19);
imageDatalai19 = imread(Lai19);
R2 = infolai19.RefMatrix;

printdata = [];
for i = 1:length(latitudes)


    [lontiff,lattiff] = deal(longitudes(i), latitudes(i));
    [y, x] = map2pix(R, lontiff, lattiff);

    x = round(x);
    y = round(y);
    
    %��ȡ��ɢ������
    valueET_M = dataET_M(y, x, :);  %1,4,7,10�·�
    valueET_Y = dataET_Y(y, x, :);  %��
    valueET_M = reshape(valueET_M,[1,4]);
    %ETdata = [valueET_M,valueET_Y];
    ETdata = valueET_Y;
    
    [y1, x1] = map2pix(R1, lontiff, lattiff);

    x1 = round(x1);
    y1 = round(y1);
    [y2, x2] = map2pix(R2, lontiff, lattiff);

    x2 = round(x2);
    y2 = round(y2);
    
    valuelai19 = imageDatalai19(y2, x2, 1);
    %��ȡ����ʪ������
    valueSMM = data_SMM(y1, x1, :);
    valueSMM = mean(valueSMM,3);
    
    if isnan(valuelai19) || valueSMM(1)<0
        continue
    else
    
    
        testdata= [ETdata,valueSMM];
        printdata = [printdata;testdata];
    end
end
filename = 'testdataFDB.csv';
csvwrite(filename,printdata);
disp('�ļ�д�����');