% 
clear;
clc;
filename = './LC_ll/LC_ll2020/allll20.csv';              %%%��������ļ�
filename0 = './LC_ll/LC_ll2020/grid_ll20.csv';                      %%%ȥ��Lai=0/Nan��������ļ�
LC = 'H:\Liubo\data\LandCover\ESAHH20.tif';     %%%LandCover�����ļ�
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
%%%LC���ݵĴ�С
[rows, cols] = size(LCdata); 
disp(rows);
disp(cols)
%%%%%%%%%%%%%%%%%%��ȡtif���ݵ�դ������ֵ
[X, Y] = meshgrid(1:cols, 1:rows);
lon = transform(3, 1) + transform(2, 1) * X + transform(1, 1) * Y;
lat = transform(3, 2) + transform(2, 2) * X + transform(1, 2) * Y;
%%%%%%%%������ȡFDB��FEN,Shrub,Crop,Grass�����ֻ꣬��ҪLCֵΪ2,4,7,91,92
list = [2,4,7,91,92];

for i = 1:numel(lon)
    if ismember(LCdata(i),list)
        fprintf(fid, '%f,%f,%d\n', lon(i), lat(i),LCdata(i));
    end
end
fclose(fid);
disp(['�ļ�д�����', filename]);

%%%%%%%%%%%%%Lai/Fpar=0/NaNʱ��ģ���޷�ģ�⣬������դ����ȥ�� LaiΪ0��ֵ
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
    
    %��ȡLai
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

disp(['�ļ�д�����', filename0]);