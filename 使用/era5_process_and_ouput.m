%    ��ȡԭʼnc���ݣ�����֮�����Ϊ�µ�nc����
clear, clc;
year = 2020;        %%%%%%%%%%   Ҫ��������
if mod(year,4)==0               %%%%%%�����������������ڲ�ͬ
    day_numberlist=[31,29,31,30,31,30,31,31,30,31,30,31];
else
    day_numberlist=[31,28,31,30,31,30,31,31,30,31,30,31];
end

filepath = strcat('H:\Liubo\Point_iulai\data\ncdata\',num2str(year));     %ָ��nc�������·��
outputFolder = strcat('H:\Liubo\Point_iulai\data\ncdata\',num2str(year)); %ָ������ļ���·��
for i = 1:12
    filepath = strcat('H:\Liubo\Point_iulai\data\ncdata\',num2str(year),'\',num2str(year),num2str(i));      %ÿ���µ�nc����·��
    filename = 'data.nc'; % ������ǰ�ļ���
    file = fullfile(filepath, filename); % ����ÿ���µ�nc�����������ļ�·��
    newfile = strcat('new',filename);

    targetFilePath = fullfile(filepath, newfile); % ���ļ�����Ŀ���ļ���·��   ģ��nc�ļ�
    copyfile(file, targetFilePath);
    
    nc_file = file;
    nc_file1 = targetFilePath;
    
    
    %��ȡ��������ı���
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

    %Hourly calculations  �����ļ���
    day_number = day_numberlist(i);
    for  j= 1:day_number*24     %jΪÿ��ʱ�䲽��
        if j<=2         %%%%ÿ�µĵ�һ��ֵ���ϸ������һ����ۻ�ֵ����˲����㣬���ڶ���ֵ�Ǳ��µ�һ��ĵ�һ��Сʱ����ֵ���Ǹ�Сʱ�ۼ�ֵ��
            data_ssrd(:, :, j) = ds_ssrd(:, :, j) ./ 3600;  %��������ʹ��˲ʱֵ
            data_strd(:, :, j) = ds_strd(:, :, j) ./ 3600;  %��������ʹ��˲ʱֵ
            data_tp(:, :, j) = ds_tp(:, :, j).* 1000;       %��λmת��Ϊmm
        elseif mod(j-2,24) == 0     %%%����/24Ϊ�����ľ�Ϊ����ĳ����׸�Сʱ����ֵ���Ǹ�Сʱ�ۼ�ֵ��
            data_ssrd(:, :, j) = ds_ssrd(:, :, j) ./ 3600;  %��������ʹ��˲ʱֵ
            data_strd(:, :, j) = ds_strd(:, :, j) ./ 3600;  %��������ʹ��˲ʱֵ
            data_tp(:, :, j) = ds_tp(:, :, j).* 1000;       %��λmת��Ϊmm
        else    %%�������в�����Сʱֵ��Ϊ��ǰСʱֵ��ȥ��һСʱֵ��ʹ��ģ��nc���ݣ���֤�Ϸ��������̶Ե�ǰ�Լ�������Ӱ�졣
            data_ssrd(:, :, j) = (ds_ssrd(:, :, j) - ds_ssrd(:, :, j-1)) ./ 3600;  %����תСʱֵ���������ʹ��˲ʱֵ
            data_strd(:, :, j) = (ds_strd(:, :, j) - ds_strd(:, :, j-1)) ./ 3600;
            data_tp(:, :, j) = (ds_tp(:, :, j) - ds_tp(:, :, j-1)).* 1000;         %��ˮ�ۼ�ֵתСʱֵ  
        end
        data_v10(:, :, j) = sqrt(ds_u10(:, :, j).^2 + ds_v10(:, :, j).^2);         %���ɶ���������
        data_d2m(:, :, j)= 0.6108 .* exp(17.27 .* (ds_d2m(:, :, j)-273.15)./ (ds_d2m(:, :, j)-273.15+237.3)).*10;%¶���¶ȷ�����ea
    end
    data_ssrd(:, :, 1) = data_ssrd(:, :, 2);  %�׸�ֵΪ�ۻ������޷����㣬ʹ�õڶ���ֵ���
    data_strd(:, :, 1) = data_strd(:, :, 2);
    data_tp(:, :, 1) = data_tp(:, :, 2);
    
    
    lon_G=ncread(nc_file, 'longitude');
    lat_G=ncread(nc_file, 'latitude');
    llon = length(lon_G);  %lon����
    llat = length(lat_G);  %lat����
    ltime = length(time);  %ʱ�䲽��
    
    %�����µ�NetCDF�ļ�,��������������������γ��µ�nc�ļ�
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
    
    % д�뾭�ȡ�γ�Ⱥ�ʱ������
    ncwrite(name, 'lon', lon_G);
    ncwriteatt(name,'lon','long_name','longitude');   % ncwriteatt������д��netCDF�ļ�
    ncwriteatt(name,'lon','unit','degree');  % name�ļ���lon������unit�������ƣ�degree����ֵ
    
    ncwrite(name, 'lat', lat_G);
    ncwriteatt(name,'lat','long_name','latitude'); 
    ncwriteatt(name,'lat','unit','degree'); 
    
    ncwrite(name, 'time', time);
    ncwriteatt(name,'time','name','time'); 
    % д������ncֵ(ssrd,strd,v10,tp,ea,t2m)
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
    fprintf('�ļ� %s ������ɡ�\n', filename);
end
disp('�������')