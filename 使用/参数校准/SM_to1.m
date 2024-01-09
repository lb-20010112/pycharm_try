year = 2020;

% ����Ӱ�����ڵ��ļ���
folder = strcat('H:\Liubo\soil_moisture\SM.1KM\',num2str(year)); 

modelTIF = 'H:\Liubo\soil_moisture\SM.1KM\2020\clipSM.1km.Month.202002.Global.v001.tif';
info = geotiffinfo(modelTIF);
R = info.RefMatrix;

mergedImage = [];

for month = 1:12
    % ����Ӱ���ļ���
    filename = sprintf('clipSM.1km.Month.%04d%02d.Global.v001.tif', year, month);
    % ��ȡӰ��
    currentImage = imread(fullfile(folder, filename));
    % ��ӵ��ϲ�Ӱ����
    if isempty(mergedImage)
        % ����ǵ�һ��Ӱ�����ʼ���ϲ�Ӱ��
        mergedImage = currentImage;
    else
        % ������ǵ�һ��Ӱ���򽫵�ǰӰ�����Ϊһ���µĲ���
        mergedImage = cat(3, mergedImage, currentImage);
    end
end
mergedImage = double(mergedImage)./100;
filename = strcat(folder,'/SM_',num2str(year));
geotiffwrite(filename, mergedImage, R); % R�ǿռ�ο���Ϣ���ɸ��ݾ�������ṩ��
disp('�ļ��ϳ����');