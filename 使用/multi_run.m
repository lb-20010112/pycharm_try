clear;
tic; 
originalExePath = 'H:\Liubo\Clibrate_Forest_9 _text_year\iulai.exe'; 
parentFolder = 'H:\Liubo\Clibrate_Forest_9 _text_year\Test_Point\FEN';

folderNames = dir(parentFolder);
folderNames = {folderNames([folderNames.isdir]).name};
folderNames = folderNames(~ismember(folderNames, {'.', '..'}));

numWorkers = 5; 
if isempty(gcp('nocreate')) 
    parpool('local', numWorkers);
end

parfor i = 1:numel(folderNames)
    folderName = folderNames{i};
    
    folderPath = fullfile(parentFolder, folderName);
    
    newExePath = fullfile(folderPath, 'tutorial1.exe');
    
 
    if ~exist(newExePath, 'file')

        copyfile(originalExePath, newExePath);
        
        cd(folderPath);
        tic;
        system(newExePath);
        toc
        delete(newExePath);
    else
        fprintf('文件夹%s已存在程序', folderName);
    end
end

delete(gcp);
elapsedTime = toc;
fprintf('运行时间%.2f秒', elapsedTime);