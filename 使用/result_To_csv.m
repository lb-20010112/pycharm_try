clear;
list = {'Shrub'};%,'FDB','Shrub','Crop','Grass'};
NCyearnumber = 2000;
LCyearnumber = 2000;
NCyear = num2str(NCyearnumber);
NCyear_1 = num2str(NCyearnumber-1);
LCyear = num2str(LCyearnumber);
yearfile = [LCyear(end-1:end),NCyear(end-1:end)];
numWorkers = 2;    %并行池个数
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

    % 文件夹路径
    Path = strcat(runfile,'/',PFT);

    % 新的CSV文件路径
    newCsvFilePath = strcat(csvoutpath,'/',PFT,'out.csv');

    % 读取原始CSV文件
    originalData = readtable(originalCsvFilePath);

    % 获取文件夹数
    folderList = dir(Path);
    folderNames = dir(Path);
    folderNames = {folderNames([folderNames.isdir]).name};
    folderNames = folderNames(~ismember(folderNames, {'.', '..'}));

    list = zeros(1, numel(folderNames)); % 预分配数组大小
    % 循环遍历 folderNames

    for q = 1:numel(folderNames)
        % 使用 str2double 将每个元素转换为数值
        list(q) = str2double(folderNames{q});
    end
    list = sort(list);

    data = zeros(6, numel(folderNames));

    % 遍历CSV文件的每一行
    parfor lineNumber = 1:length(list)
        folderNameindex = list(lineNumber);
        folderName = num2str(folderNameindex);
        % 构建文件路径
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
    % 将 data 转换为表格
    dataTable = array2table(data, 'VariableNames', {'foldername', 'type', 'lon', 'lat', 'et', 'sm'});
    % 定义每一列的数字格式
    formatSpec = {'%d', '%d', '%.6f', '%.6f', '%.3f', '%.3f'};
    % 使用 writetable 函数写入 CSV 文件
    writetable(dataTable, newCsvFilePath, 'WriteVariableNames', true, 'Delimiter', ',');
    disp('操作完成');
end