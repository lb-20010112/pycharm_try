clear;
tic; 
ExePath = '.\data\iulai.exe'; 
originalExePath = fullfile(pwd,ExePath);
numWorkers = 40; 
% list = {'Shrub','FEN','FDB','Crop','Grass'};
list = {'Crop','Grass'};
% list = {'FDB','Crop','Grass'};
NCyearnumber = 2000;        %运行2020-2020  2000-2000  2000-2020
LCyearnumber = 2020;
NCyear = num2str(NCyearnumber);
LCyear = num2str(LCyearnumber);
yearfile = [LCyear(end-1:end),NCyear(end-1:end)];
% if isempty(gcp('nocreate')) 
%     parpool('local', numWorkers);
% end
for n = 1:length(list)
    PFT = list{n};
%     parentFolder = strcat('H:\Liubo\run\2020runfile\',PFT);%
    relative_path = strcat('./',yearfile,'runfile1/',PFT);
    parentFolder = fullfile(pwd,relative_path);
    folderNames = dir(parentFolder);
    folderNames = {folderNames([folderNames.isdir]).name};
    folderNames = folderNames(~ismember(folderNames, {'.', '..'}));
    if isempty(gcp('nocreate')) 
        parpool('local', numWorkers);
    end
    parfor i = 1:numel(folderNames)
        folderName = folderNames{i};
        folderPath = fullfile(parentFolder, folderName);
%         disp(folderPath)
        newExePath = fullfile(folderPath, 'try1.exe');
%         disp(newExePath)
        cd(folderPath);
        disp('runfile:');
        disp(folderPath);
        if ~exist(newExePath, 'file') && exist('waterbalance.txt','file')
            delete('in_forcing_day.txt')
            fprintf('文件夹%s已运行', folderName);
        else
            copyfile(originalExePath, newExePath);
            system(newExePath);
            delete(newExePath);
            delete('in_forcing_day.txt');  
            delete('energy.txt');
            delete('physiology.txt');
            delete('temperature.txt');
        end
    end

    delete(gcp);

end
toc;
elapsedTime = toc;
fprintf('运行时间%.2f秒', elapsedTime);
clear;