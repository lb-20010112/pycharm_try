year = 2020;

% 设置影像所在的文件夹
folder = strcat('H:\Liubo\soil_moisture\SM.1KM\',num2str(year)); 

modelTIF = 'H:\Liubo\soil_moisture\SM.1KM\2020\clipSM.1km.Month.202002.Global.v001.tif';
info = geotiffinfo(modelTIF);
R = info.RefMatrix;

mergedImage = [];

for month = 1:12
    % 构建影像文件名
    filename = sprintf('clipSM.1km.Month.%04d%02d.Global.v001.tif', year, month);
    % 读取影像
    currentImage = imread(fullfile(folder, filename));
    % 添加到合并影像中
    if isempty(mergedImage)
        % 如果是第一个影像，则初始化合并影像
        mergedImage = currentImage;
    else
        % 如果不是第一个影像，则将当前影像添加为一个新的波段
        mergedImage = cat(3, mergedImage, currentImage);
    end
end
mergedImage = double(mergedImage)./100;
filename = strcat(folder,'/SM_',num2str(year));
geotiffwrite(filename, mergedImage, R); % R是空间参考信息（可根据具体情况提供）
disp('文件合成完毕');