
clear;
numWorkers = 5;    %并行池
tic;
Outfolder = 'test_FDB\';%输出位置文件夹
data = csvread('C:\Users\DELL\Desktop\5类点\Final\FDB.csv');             %坐标点位文件
longitudes = data(:, 2); % 第一列是经度
latitudes = data(:, 1); % 第二列维度

SMM = 'H:\Liubo\soil_moisture\SM.1KM\2020\SM_2020.tif'; %%%%%%%%%土壤湿度
ET_Y = 'H:\Liubo\data\TEST\et2020y.tif';                %%%%%%%%%蒸散发
Lai19 = 'H:\Liubo\data\LP\MmaxLai_19_align.tif';        %%%%%%%%%19年植被动态
Fpar19 ='H:\Liubo\data\LP\MmaxFpar_19_align.tif';
Lai20 = 'H:\Liubo\data\LP\MmaxLai_20_align.tif';        %%%%%%%%%20年植被动态 
Fpar20 ='H:\Liubo\data\LP\MmaxFpar_20_align.tif';

%%%%%%%%%空间参考信息
info_SMM = geotiffinfo(SMM);
infoET = geotiffinfo(ET_Y);
infolai19 = geotiffinfo(Lai19);
Rsm =info_SMM.RefMatrix;
Ret = infoET.RefMatrix;
Rlai = infolai19.RefMatrix;
%%%%%%%%%tif数据读取
data_SMM = imread(SMM);
ETDATA = imread(ET_Y);
imageDatalai19 = imread(Lai19);
imageDatafpar19 = imread(Fpar19);
imageDatalai20 = imread(Lai20);
imageDatafpar20 = imread(Fpar20);


%%%%%%%%%气候数据
ncdata = 'H:\Liubo\data\cor_era5\2019_2020.nc';
ssrd = ncread(ncdata, 'ssrd');
strd = ncread(ncdata, 'strd');
ea = ncread(ncdata, 'ea');
t2m = ncread(ncdata, 't2m');
u = ncread(ncdata, 'u');
tp = ncread(ncdata, 'tp');
%%%%%%%%%经纬度
lat = ncread(ncdata, 'lat');
lon = ncread(ncdata, 'lon');
%%%%%%%%%时间
time = ncread(ncdata,'time');
time = double(time);
time = time/24 + datetime('1900-01-01 00:00:00'); 
beijingTime = time + hours(8);
time8 = datestr(beijingTime, 'yymmddHH');
timeout = string(time8);
timeout = str2double(timeout);
timeout = reshape(timeout, [ 1, length(ssrd)]);

numVar = 8;
numTimeSteps = 17544;
numLocations = length(latitudes);

data = zeros(numVar,numTimeSteps, numLocations);
num = numLocations;%有效经纬点位数
for i = 1:numLocations
    %%%%气候数据按照经纬度读取
    [~, latIndex] = min(abs(lat - latitudes(i)));
    [~, lonIndex] = min(abs(lon - longitudes(i)));
    nearestssrdValue = ssrd(lonIndex, latIndex,:);
    neareststrdValue = strd(lonIndex, latIndex,:);
    nearesteaValue = ea(lonIndex, latIndex,:);
    nearestt2mValue = t2m(lonIndex, latIndex,:);
    nearestuValue = u(lonIndex, latIndex,:);
    nearesttpValue = tp(lonIndex, latIndex,:);

    %%%%%%根据lai，et和sm排除不可用点位
    lontiff = longitudes(i);
    lattiff = latitudes(i);
    [y, x] = map2pix(Rlai, lontiff, lattiff);
    %读取2019年Lai_Fpar,生成年数据
    x = round(x);
    y = round(y);
    valuelai19 = imageDatalai19(y, x, :);
     %读取土壤湿度数据
    [y1, x1] = map2pix(Rsm, lontiff, lattiff);
    x1 = round(x1);
    y1 = round(y1);
    valueSMM = data_SMM(y1, x1, 1);
     %读取蒸散发数据
    [y2, x2] = map2pix(Ret, lontiff, lattiff);
    x2 = round(x2);
    y2 = round(y2);
    valueET = ETDATA(y2,x2);
    if isnan(valuelai19) | valueSMM<0 | isnan(valueET)
        data(:,:,i) = NaN;
        num = num-1;
    else
        repeatTimes = 732;
        %读取2019年Lai_Fpar,生成年数据
        valuefpar19 = imageDatafpar19(y, x, :);
        valuelai19 = valuelai19(:);
        valuefpar19 = valuefpar19(:);
        valuelai19 = repelem(valuelai19, repeatTimes);
        valuefpar19 = repelem(valuefpar19, repeatTimes);
        valuelai19 = valuelai19(1:8760);
        valuefpar19 = valuefpar19(1:8760);

        %读取2020年Lai_Fpar,生成年数据
        valuelai20 = imageDatalai20(y, x, :);
        valuefpar20 = imageDatafpar20(y, x, :);
        valuelai20 = valuelai20(:);
        valuefpar20 = valuefpar20(:);
        valuelai20 = repelem(valuelai20, repeatTimes);
        valuefpar20 = repelem(valuefpar20, repeatTimes);
        valuelai20 = valuelai20(1:8784);
        valuefpar20 = valuefpar20(1:8784);

        newlai = [valuelai19;valuelai20];
        newfpar = [valuefpar19;valuefpar20];

        if newlai(1) ==0
                newlai(1) = 0.1;
        end
        if newfpar(1) ==0
                newfpar(1) = 0.09;
        end

        for j = 2:length(newlai)        %lai和Fpar可能在所有时间为空值，在写入经纬度时排除

            if newlai(j) == 0 || isnan(newlai(j)) 
                newlai(j) = newlai(j-1);
            end
        end

        for j = 2:length(newfpar)
            if newfpar(j) == 0 || isnan(newfpar(j)) 
                newfpar(j) = newfpar(j-1);
            end
        end

        newlai = reshape(newlai, [1 1 17544]);
        newfpar = reshape(newfpar, [1 1 17544]);
        data(:,:,i) = [nearestssrdValue;neareststrdValue;nearesteaValue;nearestt2mValue;nearestuValue;nearesttpValue;newlai;newfpar];
    end
end
toc;

if isempty(gcp('nocreate')) 
    parpool('local', numWorkers);
end
tic;
printnum = 0;
parfor j = 1:numLocations
    outdata = data(:,:,j);
    if all(isnan(outdata))
        continue
    else
        outdata = [timeout;outdata]
        filename = strcat(Outfolder,num2str(j),'\in_forcing_day.txt');
        fileID = fopen(filename, 'w');
        fprintf(fileID, '%08.0f %.4f %.4f %.2f %.4f %.4f %f %.3f %.3f\r\n',outdata);
        fclose(fileID);
        printnum = printnum+1;
    end
end
toc;
c = printnum-num;
disp(c)