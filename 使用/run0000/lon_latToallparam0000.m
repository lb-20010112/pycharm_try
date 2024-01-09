clear;
run('param.m')
numWorkers = 40;   %并行池个数
list = {'FDB','FEN','Shrub','Crop','Grass'};
NCyearnumber = 2000;
LCyearnumber = 2000;
NCyear = num2str(NCyearnumber);
LCyear = num2str(LCyearnumber);
yearfile = [LCyear(end-1:end),NCyear(end-1:end)];
readfolder = strcat('./LC_ll/LC_ll',LCyear);  
% readfolder = strcat('C:\Users\DELL\Desktop\5类点\Final');  
for n = 1:length(list)
    PFT = list{n};
    Outfolder = strcat('./',yearfile,'runfile/',PFT,'/');%输出位置文件夹
%     Outfolder = strcat('./',yearfile,'text/',PFT,'text/');%输出位置文件夹
    disp(Outfolder)
    data = csvread(strcat(readfolder,'/',PFT,'.csv'));   
    %%%%%%%%%%%%%%%%数据位置定义
    Lai = strcat('.\data\LP\MmaxLai_',NCyear(end-1:end),'_align.tif');
%     Lai = 'H:\Liubo\data\LP\MmaxLai_20_align.tif';%点位Lai=NaN的已去除，此处做一个验证，生成的文件夹应连续且与点位数相同
    tiffDatabee = '.\data\soil\bee.tif';
    tiffDataphsat = '.\data\soil\phsat.tif';
    tiffDatasatco = '.\data\soil\satco.tif';
    tiffDataporos = '.\data\soil\poros.tif';
    tiffDataslope = '.\data\Slope\slope.tif';
    % 经纬度信息读取
    longitudes = data(:, 1); % 
    latitudes = data(:, 2); % 
    type = data(:,3);
    disp(latitudes(1))
    disp(longitudes(1))
    %%%%%%%%%%%%%%%%%%%%%tif空间参考信息
    infoLai = geotiffinfo(Lai);
    infobee = geotiffinfo(tiffDatabee);
    infoslope = geotiffinfo(tiffDataslope);
    Rlai = infoLai.RefMatrix;
    Rsoil = infobee.RefMatrix;
    Rslope = infoslope.RefMatrix;
    %%%%%%%%%%%%%%tif数据读取
    imageDataLai = imread(Lai);
    beedata = imread(tiffDatabee);
    phsatdata = imread(tiffDataphsat);
    satcodata = imread(tiffDatasatco);
    porosdata = imread(tiffDataporos);
    slopedata = imread(tiffDataslope);

    year = NCyearnumber-1;


    numLocations = length(latitudes);
    h1 = zeros(1,numLocations);
    h2 = zeros(4,numLocations);
    h3 = zeros(2,numLocations);
    h4 = zeros(4,numLocations);
    h5 = zeros(4,numLocations);
    h6 = zeros(6,numLocations);
    h7 = zeros(7,numLocations);
    h8 = zeros(4,numLocations);
    h9 = zeros(5,numLocations);
    h10 = zeros(4,numLocations);
    h11 = zeros(3,numLocations);
    h12 = zeros(4,numLocations);
    h13 = zeros(3,numLocations);
    h14 = zeros(6,numLocations);
    h15 = zeros(3,numLocations);
    h16 = zeros(3,numLocations);
    for i = 1:numLocations
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        lontiff = longitudes(i);
        lattiff = latitudes(i);
        [y, x] = map2pix(Rlai, lontiff, lattiff);
        %读取2019年Lai_Fpar,生成年数据
        x = round(x);
        y = round(y);
        valueLai = imageDataLai(y, x, 1);

        if isnan(valueLai)
            continue
        else
            ivtype = type(i);

            z2 = z2_v(ivtype);
            z1 = z1_v(ivtype);
            vcover = vcover_v(ivtype);
            chil = chil_v(ivtype);

            rootd = rootd_v(ivtype);
            phc = phc_v(ivtype);

            tran1 = tranlv_v(ivtype);
            tran2 = tranln_v(ivtype);
            tran3 = trandv_v(ivtype);
            tran4 = trandn_v(ivtype);

            ref1 = reflv_v(ivtype);
            ref2 = refln_v(ivtype);
            ref3 = refdv_v(ivtype);
            ref4 = refdn_v(ivtype);

            effcon = effcon_v(ivtype);
            gradm = gradm_v(ivtype);
            binter = binter_v(ivtype);
            respcp = respcp_v(ivtype);
            atheta = atheta_v(ivtype);
            btheta = btheta_cst;  

            trda = trda_cst;  
            trdm = trdm_cst;  
            trop = trop_cst;  
            slti = slti_cst;  
            hlti = hlti_v(ivtype);
            shti = shti_cst;
            hhti = hhti_v(ivtype);



            sodep = sodep_v(ivtype);
            soref1= sorefv_v(ivtype);
            soref2= sorefn_v(ivtype);


            vmax0 = vmax0_v(ivtype);

            zs =z0s_cst;
            zc = zc_v(ivtype);
            leafw = leafw_v(ivtype);
            leafl = leafl_v(ivtype);

            if ivtype==1
                zwind = 45.0;
                zmet = 45.0;
            elseif ivtype>1 && ivtype<=3
                zwind = 30;
                zmet = 30;
            elseif ivtype>3 && ivtype<6
                zwind = 20;
                zmet = 20;
            elseif ivtype>=6 && ivtype<10
                zwind = 10.0;
                zmet = 2.0;
            end 

            [lon,lat] = deal(longitudes(i), latitudes(i));

            [yb1, xb1] = map2pix(Rsoil, lon, lat);

            xb1 = round(xb1);
            yb1 = round(yb1);

            bee = beedata(yb1,xb1);
            phsat = phsatdata(yb1,xb1);
            satco = satcodata(yb1,xb1);
            poros = porosdata(yb1,xb1);


            [ysl, xsl] = map2pix(Rslope, lon, lat);

            xsl = round(xsl);
            ysl = round(ysl);

            slope = slopedata(ysl,xsl);



            h1(:,i) = ivtype;
            h2(:,i) = [z2,z1,vcover,chil];
            h3(:,i) = [rootd,phc];
            h4(:,i) = [tran1,tran2,tran3,tran4];
            h5(:,i) = [ref1,ref2,ref3,ref4];
            h6(:,i) = [effcon,gradm,binter,respcp,atheta,btheta];
            h7(:,i) = [trda,trdm,trop,slti,hlti,shti,hhti];
            h8(:,i) = [99,sodep,soref1,soref2];
            h9(:,i) = [bee,phsat,satco,poros,slope];
            h10(:,i) = [zs,zc,leafw,leafl];
            h11(:,i) = [vmax0,gmudmu,green];
            h12(:,i) = [g1_cst,g4_cst,zwind,zmet];
            h13(:,i) = [dtt,itrunk,ilw];
            h14(:,i) = [latitudes(i),longitudes(i),time,month,day,year];
            h15(:,i) = [tc,tg,td];
            h16(:,i) = [www1,www2,www3];

        end
    end
    
    
    if isempty(gcp('nocreate')) 
        parpool('local', numWorkers);
    end
    tic;
    printnum = 0;
    
    parfor j = 1:numLocations
        data1 = h1(:,j);
        if ismember(data1,[91,92])
            data1 = 9
        end
        data2 = h2(:,j);
        data3 = h3(:,j);
        data4 = h4(:,j);
        data5 = h5(:,j);
        data6 = h6(:,j);
        data7 = h7(:,j);
        data8 = h8(:,j);
        data9 = h9(:,j);
        data10 = h10(:,j);
        data11 = h11(:,j);
        data12 = h12(:,j);
        data13 = h13(:,j);
        data14 = h14(:,j);
        data15 = h15(:,j);
        data16 = h16(:,j);
        
        if ~exist(strcat(Outfolder,num2str(j)), 'dir')
            mkdir(strcat(Outfolder,num2str(j)));
        end
        filename = strcat(Outfolder,num2str(j),'/in_param.txt');
        
        fileID = fopen(filename, 'w');
        fprintf(fileID,'  SIB 0-D PARAMETERS  FOR TEST RUNS OF SIB-2C ( VEGINC )\r\n');
        fprintf(fileID,'  VEGN. TYPE------------------------------------------------(I,J)\r\n');
        fprintf(fileID,'%d\r\n',data1);
        fprintf(fileID,'  VEGN. TYPE-DEPENDENT STATIC PARAMETERS--------------------(IVTYPE)\r\n');
        fprintf(fileID,'%.1f %.1f %.3f %.3f\r\n',data2);
        fprintf(fileID,'%.1f %.1f\r\n',data3);
        fprintf(fileID,'%.4f %.4f %.4f %.4f\r\n',data4);
        fprintf(fileID,'%.4f %.4f %.4f %.4f\r\n',data5);
        fprintf(fileID,'%.4f %.2f %.5f %.5f %.3f %.3f\r\n',data6);
        fprintf(fileID,'%.2f %.2f %.2f %.2f %.2f %.2f %.2f\r\n',data7);
        fprintf(fileID,'  SOIL TYPE, SOIL DEPTH, SOIL REFLECTANCES(VIS,NIR)---------(I,J)\r\n');
        fprintf(fileID,'%d %.2f %.4f %.3f\r\n',data8);
        fprintf(fileID,'SOIL TYPE-DEPENDENT STATIC PARAMETERS---------------------(ISTYPE)\r\n');
        fprintf(fileID,'%.3f %.3f %f %.4f %.4f\r\n',data9);
        fprintf(fileID,' VEGN. : PHENOLOGICALLY-VARYING APARC ( FROM NDVI )--------(I,J,T)\r\n');
        fprintf(fileID,'%.2f %.2f %.3f %.3f\r\n',data10);
        fprintf(fileID,'DERIVED OR SECONDARY PARAMETERS---------------------------(I,J,T)\r\n');
        fprintf(fileID,'%f %.1f %.4f\r\n',data11);
        fprintf(fileID,'  PARAMETERS REQUIRED FOR RASITE OPERATION ONLY\r\n');
        fprintf(fileID,'%.3f %.3f %.2f %.2f\r\n',data12); 
        fprintf(fileID,'  SITE LOCATION, NUMBER OF ITERATIONS, INITIAL CONDITIONS (NON-VEGINC)\r\n');
        fprintf(fileID,'%.1f %d %d\r\n',data13);
        fprintf(fileID, '%f %f %.1f %.1f %.1f %.1f\r\n',data14);
        fprintf(fileID,'%.1f %.1f %.1f\r\n',data15);
        fprintf(fileID,'%.4f %.4f %.4f\r\n',data16);
        fclose(fileID);
        printnum = printnum+1;
    end
    
end
toc;
