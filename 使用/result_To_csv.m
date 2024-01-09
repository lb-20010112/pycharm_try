clear;
list = {'Shrub'};%,'FDB','Shrub','Crop','Grass'};
NCyearnumber = 2000;
LCyearnumber = 2000;
NCyear = num2str(NCyearnumber);
NCyear_1 = num2str(NCyearnumber-1);
LCyear = num2str(LCyearnumber);
yearfile = [LCyear(end-1:end),NCyear(end-1:end)];
numWorkers = 2;    %���гظ���
if isempty(gcp('nocreate')) 
    parpool('local', numWorkers);
end
csvpath = strcat('./LC_ll/LC_ll',LCyear); 
runfile = strcat('./',yearfile,'runfile/');
csvoutpath = strcat('./',yearfile,'resultcsv/');
if ~exist(csvoutpath, 'dir')
    mkdir(csvoutpath);
end
for class = 1:length(list)
    PFT = list{class};
    originalCsvFilePath = strcat(csvpath,'/',PFT,'.csv');

    % �ļ���·��
    Path = strcat(runfile,'/',PFT);

    % �µ�CSV�ļ�·��
    newCsvFilePath = strcat(csvoutpath,'/',PFT,'out.csv');

    % ��ȡԭʼCSV�ļ�
    originalData = readtable(originalCsvFilePath);

    % ��ȡ�ļ�����
    folderList = dir(Path);
    folderNames = dir(Path);
    folderNames = {folderNames([folderNames.isdir]).name};
    folderNames = folderNames(~ismember(folderNames, {'.', '..'}));

    list = zeros(1, numel(folderNames)); % Ԥ���������С
    % ѭ������ folderNames

    for q = 1:numel(folderNames)
        % ʹ�� str2double ��ÿ��Ԫ��ת��Ϊ��ֵ
        list(q) = str2double(folderNames{q});
    end
    list = sort(list);

    data = zeros(6, numel(folderNames));

    % ����CSV�ļ���ÿһ��
    parfor lineNumber = 1:length(list)
        folderNameindex = list(lineNumber);
        folderName = num2str(folderNameindex);
        % �����ļ�·��
        folderPath = fullfile(Path, folderName);
        water = strcat(folderPath,'/waterbalance.txt');
        moisture =strcat(folderPath,'/moisture.txt');
        waterdata = importdata(water);
        et = waterdata(8753:17536, 6);
        totalET = sum(et);
        moisturedata = importdata(moisture);  
        sm = moisturedata(8753:17536, 3);
        meansm = mean(sm);
        lltype = originalData(lineNumber,:);
        data(:,lineNumber) = [folderNameindex,lltype.Var3,lltype.Var1, lltype.Var2, totalET,meansm]
    end
    data = data';
    % �� data ת��Ϊ���
    dataTable = array2table(data, 'VariableNames', {'foldername', 'type', 'lon', 'lat', 'et', 'sm'});
    % ����ÿһ�е����ָ�ʽ
    formatSpec = {'%d', '%d', '%.6f', '%.6f', '%.3f', '%.3f'};
    % ʹ�� writetable ����д�� CSV �ļ�
    writetable(dataTable, newCsvFilePath, 'WriteVariableNames', true, 'Delimiter', ',');
    disp('�������');
end