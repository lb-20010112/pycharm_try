clear;
list = {'Shrub','FEN','FDB','Crop','Grass'};
NCyearnumber = 2000;
LCyearnumber = 2020;
NCyear = num2str(NCyearnumber);
NCyear_1 = num2str(NCyearnumber-1);
LCyear = num2str(LCyearnumber);
LCyear_1 = num2str(LCyearnumber-1);
yearfile = [LCyear(end-1:end),NCyear(end-1:end)];
readfolder = strcat('./LC_ll/LC_ll',LCyear);  
% readfolder = strcat('C:\Users\DELL\Desktop\5���\Final');  
numWorkers = 40;    %���гظ���
if isempty(gcp('nocreate')) 
    parpool('local', numWorkers);
end
tic;
Lai19 = strcat('.\data\LP\MmaxLai_',LCyear_1(end-1:end),'_align.tif'); %%%%%%%%%19��ֲ����̬
Fpar19 =strcat('.\data\LP\MmaxFpar_',LCyear_1(end-1:end),'_align.tif');
Lai20 = strcat('.\data\LP\MmaxLai_',LCyear(end-1:end),'_align.tif');        %%%%%%%%%20��ֲ����̬ 
Fpar20 =strcat('.\data\LP\MmaxFpar_',LCyear(end-1:end),'_align.tif');
%%%%%%%%%��������
ncdata = strcat('.\data\cor_era5\',NCyear_1,'_',NCyear,'.nc');
disp(ncdata)
disp(Lai19)
disp(Lai20)
disp(Fpar20)
disp(Lai20)
ssrd = ncread(ncdata, 'ssrd');
strd = ncread(ncdata, 'strd');
ea = ncread(ncdata, 'ea');
t2m = ncread(ncdata, 't2m');
u = ncread(ncdata, 'u');
tp = ncread(ncdata, 'tp');
%%%%%%%%%��γ��
lat = ncread(ncdata, 'lat');
lon = ncread(ncdata, 'lon');
%%%%%%%%%ʱ��
time = ncread(ncdata,'time');
time = double(time);
time = time/24 + datetime('1900-01-01 00:00:00'); 
beijingTime = time + hours(8);
time8 = datestr(beijingTime, 'yymmddHH');
timeout = string(time8);
timeout = str2double(timeout);
timeout = reshape(timeout, [ 1, length(ssrd)]);
numVar = 8;
numTimeSteps = 17544;
%%%%%%%%%�ռ�ο���Ϣ
infolai19 = geotiffinfo(Lai19);
Rlai = infolai19.RefMatrix;
%%%%%%%%%tif���ݶ�ȡ
imageDatalai19 = imread(Lai19);
imageDatafpar19 = imread(Fpar19);
imageDatalai20 = imread(Lai20);
imageDatafpar20 = imread(Fpar20);
for n = 1:length(list)
    PFT = list{n};
    Outfolder = strcat('./',yearfile,'runfile1/',PFT,'/');%���λ���ļ���
%     Outfolder = strcat('./',yearfile,'text/',PFT,'text/');%���λ���ļ���
    lldata = csvread(strcat(readfolder,'/',PFT,'.csv')); 
    long = lldata(:, 1); % ��һ���Ǿ���
%     latitudes = data(:, 2); % �ڶ���ά��
    numpoint = 5000;   %ÿ��ѭ�����еĵ�λ����
    num_iterations = ceil(length(long) / numpoint); %��Ҫѭ���Ĵ���
    for m = 1:num_iterations
        start_index = (m - 1) * numpoint + 1;
        end_index = min(m * numpoint,length(long));
        
        current_data = lldata(start_index:end_index, :);
        longitudes = current_data(:, 1); % ��һ���Ǿ���
	    latitudes = current_data(:, 2); % �ڶ���ά��
        
        numLocations = length(longitudes);
        data = zeros(numVar,numTimeSteps, numLocations);
        num = numLocations;%��Ч��γ��λ��
        for i = 1:numLocations
            %%%%�������ݰ��վ�γ�ȶ�ȡ

            [~, latIndex] = min(abs(lat - latitudes(i)));
            [~, lonIndex] = min(abs(lon - longitudes(i)));
            nearestssrdValue = ssrd(lonIndex, latIndex,:);
            neareststrdValue = strd(lonIndex, latIndex,:);
            nearesteaValue = ea(lonIndex, latIndex,:);
            nearestt2mValue = t2m(lonIndex, latIndex,:);
            nearestuValue = u(lonIndex, latIndex,:);
            nearesttpValue = tp(lonIndex, latIndex,:);

            %%%%%%����lai��et��sm�ų������õ�λ
            lontiff = longitudes(i);
            lattiff = latitudes(i);
            [y, x] = map2pix(Rlai, lontiff, lattiff);
            %��ȡ2019��Lai_Fpar,����������
            x = round(x);
            y = round(y);
            valuelai19 = imageDatalai19(y, x, :);
            if isnan(valuelai19) 
                data(:,:,i) = NaN;
                num = num-1;
            else
                repeatTimes = 732;
                %��ȡ2019��Lai_Fpar,����������
                valuefpar19 = imageDatafpar19(y, x, :);
                valuelai19 = valuelai19(:);
                valuefpar19 = valuefpar19(:);
                valuelai19 = repelem(valuelai19, repeatTimes);
                valuefpar19 = repelem(valuefpar19, repeatTimes);
                valuelai19 = valuelai19(1:8760);
                valuefpar19 = valuefpar19(1:8760);

                %��ȡ2020��Lai_Fpar,����������
                valuelai20 = imageDatalai20(y, x, :);
                valuefpar20 = imageDatafpar20(y, x, :);
                valuelai20 = valuelai20(:);
                valuefpar20 = valuefpar20(:);
                valuelai20 = repelem(valuelai20, repeatTimes);
                valuefpar20 = repelem(valuefpar20, repeatTimes);
                valuelai20 = valuelai20(1:8784);
                valuefpar20 = valuefpar20(1:8784);

                newlai = [valuelai19;valuelai20];
                newfpar = [valuefpar19;valuefpar20];

                if newlai(1) ==0
                    newlai(1) = 0.1;
                elseif newlai(1) >6
                    newlai(1) = 0.1;
                end
                
                if newfpar(1) ==0
                    newfpar(1) = 0.09;
                elseif newfpar(1) >1 
                    newfpar(1) = 0.09;
                end

                for j = 2:length(newlai)        %lai��Fpar����������ʱ��Ϊ��ֵ����д�뾭γ��ʱ�ų�

                    if newlai(j) == 0 || isnan(newlai(j)) 
                        newlai(j) = newlai(j-1);
                    elseif newlai(j) > 6
                        newlai(j) = 1;
                    end
                end

                for j = 2:length(newfpar)
                    if newfpar(j) == 0 || isnan(newfpar(j)) 
                        newfpar(j) = newfpar(j-1);
                    elseif newfpar(j)>1
                        newfpar(j) = 0.4;
                    end
                end

                newlai = reshape(newlai, [1 1 17544]);
                newfpar = reshape(newfpar, [1 1 17544]);
                data(:,:,i) = [nearestssrdValue;neareststrdValue;nearesteaValue;nearestt2mValue;nearestuValue;nearesttpValue;newlai;newfpar];
            end
        end


%         if isempty(gcp('nocreate')) 
%             parpool('local', numWorkers);
%         end

        printnum = 0;
        parfor j = 1:numLocations
            outdata = data(:,:,j);
            if all(isnan(outdata))
                continue
            else
                outdata = [timeout;outdata]
                fileindex = (m-1)* numpoint +j;
                disp(fileindex)
                filename = strcat(Outfolder,num2str(fileindex),'\in_forcing_day.txt');
                fileID = fopen(filename, 'w');
                fprintf(fileID, '%08.0f %.4f %.4f %.2f %.4f %.4f %f %.3f %.3f\r\n',outdata);
                fclose(fileID);
                printnum = printnum+1;
            end
        end

        c = printnum-num;
        disp(c)
    end
end
toc;
clear;