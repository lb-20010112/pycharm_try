%    读取原始nc数据，处理之后输出为新的nc数据
clear, clc;
year = 2020;        %%%%%%%%%%   要处理的年份
if mod(year,4)==0               %%%%%%闰年与非闰年二月日期不同
    day_numberlist=[31,29,31,30,31,30,31,31,30,31,30,31];
else
    day_numberlist=[31,28,31,30,31,30,31,31,30,31,30,31];
end

filepath = strcat('H:\Liubo\Point_iulai\data\ncdata\',num2str(year));     %指定nc数据年份路径
outputFolder = strcat('H:\Liubo\Point_iulai\data\ncdata\',num2str(year)); %指定输出文件夹路径
for i = 1:12
    filepath = strcat('H:\Liubo\Point_iulai\data\ncdata\',num2str(year),'\',num2str(year),num2str(i));      %每个月的nc数据路径
    filename = 'data.nc'; % 构建当前文件名
    file = fullfile(filepath, filename); % 构建每个月的nc数据完整的文件路径
    newfile = strcat('new',filename);

    targetFilePath = fullfile(filepath, newfile); % 新文件名和目标文件夹路径   模板nc文件
    copyfile(file, targetFilePath);
    
    nc_file = file;
    nc_file1 = targetFilePath;
    
    
    %读取计算所需的变量
    ds_ssrd = ncread(nc_file, 'ssrd');
    ds_t2m = ncread(nc_file, 't2m');
    ds_strd = ncread(nc_file, 'strd');
    ds_tp = ncread(nc_file, 'tp');
    ds_u10 = ncread(nc_file, 'u10');
    ds_v10 = ncread(nc_file, 'v10');
    ds_d2m = ncread(nc_file, 'd2m');
    data_ssrd = ncread(nc_file1, 'ssrd');
    data_strd = ncread(nc_file1, 'strd');
    data_tp = ncread(nc_file1, 'tp');
    data_u10 = ncread(nc_file1, 'u10');
    data_v10 = ncread(nc_file1, 'v10');
    data_d2m = ncread(nc_file1, 'd2m');
    
    time = ncread(nc_file, 'time');

    %Hourly calculations  参数的计算
    day_number = day_numberlist(i);
    for  j= 1:day_number*24     %j为每月时间步长
        if j<=2         %%%%每月的第一个值是上个月最后一天的累积值，因此不计算，二第二个值是本月第一天的第一个小时，其值就是该小时累计值。
            data_ssrd(:, :, j) = ds_ssrd(:, :, j) ./ 3600;  %除以秒数使用瞬时值
            data_strd(:, :, j) = ds_strd(:, :, j) ./ 3600;  %除以秒数使用瞬时值
            data_tp(:, :, j) = ds_tp(:, :, j).* 1000;       %单位m转换为mm
        elseif mod(j-2,24) == 0     %%%步长/24为整数的均为该月某天的首个小时，其值就是该小时累计值。
            data_ssrd(:, :, j) = ds_ssrd(:, :, j) ./ 3600;  %除以秒数使用瞬时值
            data_strd(:, :, j) = ds_strd(:, :, j) ./ 3600;  %除以秒数使用瞬时值
            data_tp(:, :, j) = ds_tp(:, :, j).* 1000;       %单位m转换为mm
        else    %%其他所有步长的小时值均为当前小时值减去上一小时值，使用模板nc数据，保证上方两个过程对当前以及后续无影响。
            data_ssrd(:, :, j) = (ds_ssrd(:, :, j) - ds_ssrd(:, :, j-1)) ./ 3600;  %辐射转小时值后除以秒数使用瞬时值
            data_strd(:, :, j) = (ds_strd(:, :, j) - ds_strd(:, :, j-1)) ./ 3600;
            data_tp(:, :, j) = (ds_tp(:, :, j) - ds_tp(:, :, j-1)).* 1000;         %降水累计值转小时值  
        end
        data_v10(:, :, j) = sqrt(ds_u10(:, :, j).^2 + ds_v10(:, :, j).^2);         %勾股定理计算风速
        data_d2m(:, :, j)= 0.6108 .* exp(17.27 .* (ds_d2m(:, :, j)-273.15)./ (ds_d2m(:, :, j)-273.15+237.3)).*10;%露点温度法计算ea
    end
    data_ssrd(:, :, 1) = data_ssrd(:, :, 2);  %首个值为累积至且无法计算，使用第二个值替代
    data_strd(:, :, 1) = data_strd(:, :, 2);
    data_tp(:, :, 1) = data_tp(:, :, 2);
    
    
    lon_G=ncread(nc_file, 'longitude');
    lat_G=ncread(nc_file, 'latitude');
    llon = length(lon_G);  %lon长度
    llat = length(lat_G);  %lat长度
    ltime = length(time);  %时间步长
    
    %创建新的NetCDF文件,将计算后的所需参数导入形成新的nc文件
    filename = sprintf('out%d_%d.nc',year, i);
    name = fullfile(outputFolder, filename);

    nccreate(name, 'lon', 'Dimensions', {'lon', llon}, 'Datatype', 'double', 'Format', 'classic');
    nccreate(name, 'lat', 'Dimensions', {'lat', llat}, 'Datatype', 'double', 'Format', 'classic');
    nccreate(name, 'time', 'Dimensions', {'time', ltime}, 'Datatype', 'double', 'Format', 'classic');
    nccreate(name, 'ssrd', 'Dimensions', {'lon', llon, 'lat', llat, 'time', ltime}, 'Datatype', 'double', 'Format', 'classic');
    nccreate(name, 'strd', 'Dimensions', {'lon', llon, 'lat', llat, 'time', ltime}, 'Datatype', 'double', 'Format', 'classic');
    nccreate(name, 'u', 'Dimensions', {'lon', llon, 'lat', llat, 'time', ltime}, 'Datatype', 'double', 'Format', 'classic');
    nccreate(name, 'tp', 'Dimensions', {'lon', llon, 'lat', llat, 'time', ltime}, 'Datatype', 'double', 'Format', 'classic');
    nccreate(name, 't2m', 'Dimensions', {'lon', llon, 'lat', llat, 'time', ltime}, 'Datatype', 'double', 'Format', 'classic');
    nccreate(name, 'ea', 'Dimensions', {'lon', llon, 'lat', llat, 'time', ltime}, 'Datatype', 'double', 'Format', 'classic');
    
    % 写入经度、纬度和时间数据
    ncwrite(name, 'lon', lon_G);
    ncwriteatt(name,'lon','long_name','longitude');   % ncwriteatt将属性写入netCDF文件
    ncwriteatt(name,'lon','unit','degree');  % name文件，lon变量，unit属性名称，degree属性值
    
    ncwrite(name, 'lat', lat_G);
    ncwriteatt(name,'lat','long_name','latitude'); 
    ncwriteatt(name,'lat','unit','degree'); 
    
    ncwrite(name, 'time', time);
    ncwriteatt(name,'time','name','time'); 
    % 写入计算的nc值(ssrd,strd,v10,tp,ea,t2m)
    ncwrite(name, 'ssrd', data_ssrd);
    ncwriteatt(name,'ssrd','long_name','Surface solar radiation downwards'); 
    ncwriteatt(name,'ssrd','unit','J m**-2');  
    ncwriteatt(name,'ssrd','standard_name','surface_downwelling_shortwave_flux_in_air');
    ncwrite(name, 'strd', data_strd);
    ncwriteatt(name,'strd','long_name','Surface thermal radiation downwards'); 
    ncwriteatt(name,'strd','unit','J m**-2');  
    ncwrite(name, 'u', data_v10);
    ncwriteatt(name,'u','long_name','10 metre wind component'); 
    ncwriteatt(name,'u','unit','m s**-1');
    ncwrite(name, 'tp', data_tp);
    ncwriteatt(name,'tp','long_name','Total precipitation'); 
    ncwriteatt(name,'tp','unit','mm');
    ncwrite(name, 't2m', ds_t2m);
    ncwriteatt(name,'t2m','long_name','2 metre temperature'); 
    ncwriteatt(name,'t2m','unit','K');
    ncwrite(name, 'ea', data_d2m);
    ncwriteatt(name,'ea','long_name','water vapor pressure'); 
    ncwriteatt(name,'ea','unit','hPa');
    fprintf('文件 %s 处理完成。\n', filename);
end
disp('处理完成')