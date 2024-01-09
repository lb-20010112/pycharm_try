%% tm 空气温度，lst地表温度
% tm = 293;       % tm  空气温度 K
% lst = 295;      % lst 地表温度 K
% u = 0.5;        % u   风速     m/s
% tp = 0.00002;   % tp  降雨量   m
ncdata = strcat('C:\\Users\lb\Desktop/data.nc');
lst = ncread(ncdata, 'skt');
d2m = ncread(ncdata, 't2m');
u10 = ncread(ncdata, 'u10');
v10 = ncread(ncdata, 'v10');
tp = ncread(ncdata, 'tp');
%%%%%%%%%经纬度
lat = ncread(ncdata, 'latitude');
lon = ncread(ncdata, 'longitude');
%%  常数
rhoair = 1.255; %rhoair 空气密度
psur = 1000;    %psur   大气压强
cpair = 1010;   %cpair  空气比热

ll = csvread('E:\run\LC_ll\LC_ll2020\FEN.csv');   %城市点位经纬度
longitudes = ll(:, 1); % 第一列是经度
latitudes = ll(:, 2); % 第二列维度
% longitudes = 104;
% latitudes = 35;

for num = 1:length(longitudes)
    %%  地面初始水深度
    capac = 0;
    
    %%  为输出预分配内存
    output = zeros(length(lat),2);

    [~, latIndex] = min(abs(lat - latitudes(num)));
    [~, lonIndex] = min(abs(lon - longitudes(num)));
%     [~, latIndex] = min(abs(lat - latitudes));
%     [~, lonIndex] = min(abs(lon - longitudes));
    nearestlstValue = lst(lonIndex, latIndex,:);
    disp(nearestlstValue)
    nearestd2mValue = d2m(lonIndex, latIndex,:);
    nearesttpValue = tp(lonIndex, latIndex,:);
    nearestu10Value = u10(lonIndex, latIndex,:);
    nearestv10Value = v10(lonIndex, latIndex,:);
    

        %%   循环
    for i = 1:numel(nearestlstValue)       % function[et0,et] = etculout(tm,lst,u,tp)
        
    
        tm = nearestd2mValue(i);
        lst1 = nearestlstValue(i);
        tp1 = nearesttpValue(i);
        u1 = nearestu10Value(i);
        v1 = nearestv10Value(i);
        u2 = sqrt(u1^2 + v1^2); 
    
        water = tp1 + capac;           %降水+现有地面水  ，当小时地表总水量
        capac = min(0.0003,water);     %地表存储的水深度，不超过 1 mm，可用于蒸发的水量
        
        ea = exp( 21.18123 - 5418. / lst1 ) / .622;              %地面水汽压
        er = 6.108 .* exp(17.27 * (tm-273.15)/ (tm-273.15+237.3));%大气水汽压
                                                        % ra =90.909*(u^(-0.9036));          % 空气动力学阻力  裸地
        ra =((log(10000/1.37))^2 * 4.72)/(1 + 0.536 * u2);   %水面   将表面有水的不透水层视为水面
        
        hlat = (3150.19-2.378*tm)*1000;
        psy = (cpair*psur)/(0.622*hlat);
        et0 =  (ea-er)*cpair*rhoair/(hlat*ra*psy);
        %     et_day = ET*3600*24;
        et = min(et0,capac);         %实际蒸散发量
        capac = capac-et;            %蒸发后地表存水量，可用于下一步长蒸发
        output(i,1) = et0;
        output(i,2) = et;
    end
end