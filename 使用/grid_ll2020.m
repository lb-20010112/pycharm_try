% 
clear;
clc;
filename = './LC_ll/LC_ll2020/allll20.csv';              %%%坐标输出文件
filename0 = './LC_ll/LC_ll2020/grid_ll20.csv';                      %%%去除Lai=0/Nan后的坐标文件
LC = 'H:\Liubo\data\LandCover\ESAHH20.tif';     %%%LandCover数据文件
LAI = 'H:\Liubo\data\LP\MmaxLai_19_align.tif';

fid = fopen(filename, 'w');
fid0 = fopen(filename0, 'w');
fidFDB= fopen('./LC_ll/LC_ll2020/FDB.csv ','w');
fidFEN= fopen('./LC_ll/LC_ll2020/FEN.csv ','w');
fidS= fopen('./LC_ll/LC_ll2020/Shrub.csv ','w');
fidC= fopen('./LC_ll/LC_ll2020/Crop.csv ','w');
fidG= fopen('./LC_ll/LC_ll2020/Grass.csv ','w');
LCinfo = geotiffinfo(LC);
infoLai = geotiffinfo(LAI);
transform = LCinfo.RefMatrix;
Rlai = infoLai.RefMatrix;
Laidata = imread(LAI);
LCdata = imread(LC);
%%%LC数据的大小
[rows, cols] = size(LCdata); 
disp(rows);
disp(cols)
%%%%%%%%%%%%%%%%%%获取tif数据的栅格坐标值
[X, Y] = meshgrid(1:cols, 1:rows);
lon = transform(3, 1) + transform(2, 1) * X + transform(1, 1) * Y;
lat = transform(3, 2) + transform(2, 2) * X + transform(1, 2) * Y;
%%%%%%%%从中提取FDB，FEN,Shrub,Crop,Grass的坐标，只需要LC值为2,4,7,91,92
list = [2,4,7,91,92];

for i = 1:numel(lon)
    if ismember(LCdata(i),list)
        fprintf(fid, '%f,%f,%d\n', lon(i), lat(i),LCdata(i));
    end
end
fclose(fid);
disp(['文件写入完成', filename]);

%%%%%%%%%%%%%Lai/Fpar=0/NaN时，模型无法模拟，从所以栅格中去除 Lai为0的值
ll = csvread(filename);
longitudes = ll(:, 1); 
latitudes = ll(:, 2); 
type = ll(:,3);

for j = 1:length(longitudes)

    lon=longitudes(j);
    lat=latitudes(j);
    class = type(j);
    
    [y, x] = map2pix(Rlai, lon, lat);
    x = round(x);
    y = round(y);
    
    %读取Lai
    lai = Laidata(y, x, 1);
    if isnan(lai)
        fprintf(fid0, '%f,%f,%d\n', lon, lat,-999);
    else
        if class == 2
            fprintf(fidFDB, '%f,%f,%d\n', lon, lat,class);
        elseif class == 4
            fprintf(fidFEN, '%f,%f,%d\n', lon, lat,class);
        elseif class == 7
            fprintf(fidS, '%f,%f,%d\n', lon, lat,class);
        elseif class == 91
            fprintf(fidC, '%f,%f,%d\n', lon, lat,class);
        elseif class == 92
            fprintf(fidG, '%f,%f,%d\n', lon, lat,class);
        end
    end
end
fclose(fid0);
fclose(fidFEN);
fclose(fidFDB);
fclose(fidS);
fclose(fidC);
fclose(fidG);

disp(['文件写入完成', filename0]);