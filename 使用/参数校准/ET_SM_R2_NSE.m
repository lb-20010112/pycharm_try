clear;

classlist = ["FDB","FEN","Shrub","Crop","Grass"];
Folder = 'H:\Liubo\Clibrate_Forest_9 _text_year\Test_Point';
%%%%%%%%%tif����
ETY = 'H:\Liubo\data\TEST\et2020y.tif';
ETM = 'H:\Liubo\data\TEST\et2020M.tif';
SMM = 'H:\Liubo\soil_moisture\SM.1KM\2020\SM_2020.tif';
Lai19 =  'H:\Liubo\data\LP\MmaxLai_19_align.tif';
%%%%%%%%%%�ռ�ο���Ϣ
infoET_y = geotiffinfo(ETY);
info_SMM = geotiffinfo(SMM);
infolai19 = geotiffinfo(Lai19);
Ret = infoET_y.RefMatrix;
Rsm =info_SMM.RefMatrix;
Rlai = infolai19.RefMatrix;
%%%%%%%%tif���ݶ�ȡ
dataET_M = imread(ETM);
dataET_Y = imread(ETY);
dataSM_M = imread(SMM);
imageDatalai19 = imread(Lai19);

for c = 1:5
    classname = classlist(c);
    class = char(classname);
    
    disp(class)
    parentFolder = strcat(Folder,'\',class);
    disp(parentFolder)
    folderNames = dir(parentFolder);
    folderNames = {folderNames([folderNames.isdir]).name};
    folderNames = folderNames(~ismember(folderNames, {'.', '..'}));


    list = [];

    for i = 1:numel(folderNames)
        Name = str2num(folderNames{i});
        list = [list,Name];
    end
    list = sort(list);

    name = strcat('C:\Users\DELL\Desktop\5���\Final','\',class,'.csv');
    disp(name)
    ll = csvread(name);
    longitudes = ll(:, 2); % ��һ���Ǿ���
    latitudes = ll(:, 1); % �ڶ���ά��


    ETSiB2_1 = [];
    ETSiB2_4 = [];
    ETSiB2_7 = [];
    ETSiB2_10 = [];
    ETSiB2_Y = [];
    ETDATA1 = [];
    ETDATA4 = [];
    ETDATA7 = [];
    ETDATA10 = [];
    ETDATA = [];

%     SM1 = [];
%     SM4 = [];
%     SM7 = [];
%     SM10 = [];
    SMSiB2_Y = [];
%     SMDATA1 = [];
%     SMDATA4 = [];
%     SMDATA7 = [];
%     SMDATA10 = [];
    SMDATA = [];

    for i = 1:length(list)
        folderName = num2str(list(i));

        folderPath = fullfile(parentFolder, folderName);

        txtFilePath = fullfile(folderPath, 'waterbalance.txt');
        txtFilePath1 = fullfile(folderPath, 'moisture.txt'); 
        exeFilePath = fullfile(folderPath, 'tutorial1.exe'); 


        data = readtable(txtFilePath);
        data1 = readtable(txtFilePath1);

        column3 = data1(8753:17536, 3);
        totalSM = mean(column3{:,:});   
        SMSiB2_Y = [SMSiB2_Y,totalSM];


        et1 = data(8753:9496, 6);
        et4 = data(10937:11656, 6);
        et7 = data(13121:13864, 6);
        et10 = data(15329:16072, 6);

        totalET1 = sum(et1{:,:});
        totalET4 = sum(et4{:,:});
        totalET7 = sum(et7{:,:});
        totalET10 = sum(et10{:,:});

        column6 = data(8753:17536, 6);
        totalET = sum(column6{:,:});     

        ETSiB2_1 = [ETSiB2_1,totalET1];
        ETSiB2_4 = [ETSiB2_4,totalET4];
        ETSiB2_7 = [ETSiB2_7,totalET7];
        ETSiB2_10 = [ETSiB2_10,totalET10];
        ETSiB2_Y = [ETSiB2_Y,totalET];
    end


    %��ɢ������Ʒ
    for j = 1:length(latitudes)


        [lontiff,lattiff] = deal(longitudes(j), latitudes(j));
        [y, x] = map2pix(Ret, lontiff, lattiff);

        x = round(x);
        y = round(y);
        %��ȡ��ɢ������
        valueET_M = dataET_M(y, x, :);  %1,4,7,10�·�
        valueET_Y = dataET_Y(y, x, :);  %��
        valueET_M = reshape(valueET_M,[1,4]);
        ETdata = [valueET_M,valueET_Y];

        [y1, x1] = map2pix(Rsm, lontiff, lattiff);
        x1 = round(x1);
        y1 = round(y1);
        [y2, x2] = map2pix(Rlai, lontiff, lattiff);

        x2 = round(x2);
        y2 = round(y2);

        valuelai19 = imageDatalai19(y2, x2, 1);
        %��ȡ����ʪ������
        valueSM_M = dataSM_M(y1, x1, :);  %1-12��
        valueSM_Y = mean(valueSM_M,3);  %���


        if isnan(valuelai19) || valueSM_M(1)<0 || isnan(valueET_Y)
            continue
        else
            ETD1 = ETdata(1);
            ETD4 = ETdata(2);
            ETD7 = ETdata(3);
            ETD10 = ETdata(4);
            ETD = ETdata(5);

            SMy = valueSM_Y;
        end
        ETDATA1 = [ETDATA1,ETD1];
        ETDATA4 = [ETDATA4,ETD4];
        ETDATA7 = [ETDATA7,ETD7];
        ETDATA10 = [ETDATA10,ETD10];
        ETDATA = [ETDATA,ETD];

        SMDATA = [SMDATA,SMy];
    end
    result = [ETSiB2_1;ETDATA1;ETSiB2_4;ETDATA4;ETSiB2_7;ETDATA7;ETSiB2_10;ETDATA10;ETSiB2_Y;ETDATA;SMSiB2_Y;SMDATA];
    outdata = transpose(result);
    outputCSVPath = strcat(Folder, '\ET_SM_Contrast\','ET_SM_',class,'.csv');
    csvwrite(outputCSVPath,outdata);
   
end

disp('�ļ�д�����');


%%%%%%%%%%%    ����5��ֲ����6��R2
testFolder = strcat(Folder, '\ET_SM_Contrast\');
r2list = [];
nselist = [];
for r = 1:5
    classname = classlist(r);
    class = char(classname);
    
    csvfile = strcat(Folder, '\ET_SM_Contrast\','ET_SM_',class,'.csv');

    r2Values = zeros(1, 6); %R
    nseValues = zeros(1, 6); % NSE
    csvdata = csvread(csvfile);
    
    figure;
    set(gcf, 'Position', [100, 100, 1200, 800]);  % ����ͼ�δ�С
    columnNames = {'ETSiB2_1', 'ETSiB2_4', 'ETSiB2_7', 'ETSiB2_10', 'ETSiB2_Y', 'SM'};
    % ѭ������Rֵ�ͻ���ɢ��ͼ
    for l = 1:2:11  
       
        dataSubset = csvdata(:, l:l+1);
        correlationMatrix = corrcoef(dataSubset);

        % ��ȡRֵ���洢
        rSquared = correlationMatrix(1, 2);
        rSquaredValues((l+1)/2) = rSquared;
        
        % ����NSEֵ���洢
        observed = dataSubset(:, 2);
        simulated = dataSubset(:, 1);
        numerator = sum((observed - simulated).^2);
        denominator = sum((observed - mean(observed)).^2);
        nse = 1 - (numerator / denominator);
        nseValues((l+1)/2) = nse;
        
        % ��ͼ�������һ����ͼ
        subplot(2, 3, (l+1)/2);  
        scatter(observed, simulated);
        xlabel('�۲�ֵ');
        ylabel('ģ��ֵ');
        title(columnNames{(l+1)/2});
        
        % ����ͼ�����R2ֵ
        txt = sprintf('Rlai = %.4f', rSquared);
        text(0.5, 0.9, txt, 'FontSize', 12, 'HorizontalAlignment', 'center', 'Units', 'normalized');
    end

    % ����ܱ���
    suptitle(strcat(class, ' ɢ��ͼ'));
    
    % ��ʾ�����Rֵ
    printname = strcat(class,'�����Rֵ��');
    disp(printname);
    disp(rSquaredValues);
    printname1 = strcat(class,'�����NSEֵ��');
    disp(printname1);
    disp(nseValues);
    r2list = [r2list;rSquaredValues];
    nselist = [nselist;nseValues];
    
    % ���浱ǰͼ��Ϊͼ���ļ�
    figname = strcat(class, '_ɢ��ͼ��Rֵ.png');
    saveas(gcf, fullfile(testFolder, figname));
end    

  
%r2list = r2list;
tableclassname = {'FDB', 'FEN', 'Shrub', 'Crop', 'Grass'};
tableclassname = transpose(tableclassname);
Tname = cell2table(tableclassname);

T1 = array2table(r2list);
T2 = array2table(nselist);
T = horzcat(Tname,T1,T2);

columnNames = {'T','RET1', 'RET4', 'RET7', 'RET10', 'RET','RSM','NSEET1', 'NSEET4', 'NSEET7', 'NSEET10', 'NSEET','NSESM'};
% Ϊ���������������
T.Properties.VariableNames = columnNames;
csvFilePath = strcat(Folder, '\ET_SM_Contrast\R_NSE.csv');

writetable(T, csvFilePath, 'WriteRowNames', true); 
