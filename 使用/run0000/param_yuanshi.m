%%%%%%%%%%%%%%%%涓嶅悓iv瀵瑰簲鐨勬ā鍨嬪弬鏁?
tc = 268.0;
tg = 270.0;
td = 270.0;
www1 = 0.25;
www2 = 0.25;
www3 = 0.25;

green = 0.7979;
gmudmu = 1;
dtt = 3600.0;
itrunk = 20;
ilw = 1;
time = 8.0;
month = 1;
day = 1;

%Type 1: time and biomes invariant parameters 
z0s_cst = 0.05;     %地面粗糙度长度
g4_cst = 11.785;    
dsfc_cst = 0.02; 
g1_cst = 1.449; 

%Type 2: time-invariant biomes dependent parameters
%Canopy-top height(m)   %冠层顶高度
z2_v(1) = 35.0; 
z2_v(2) = 20.0;
z2_v(3) = 20.0;
z2_v(4) = 17.0;
z2_v(5) = 17.0;
z2_v(6) = 1.0;
z2_v(7) = 0.5;
z2_v(8) = 0.6;
z2_v(91) = 1.0;
z2_v(92) = 1.0;
% Canopy-base height (m)
z1_v(1) = 1.0;       %冠层底高度
z1_v(2) = 11.5;
z1_v(3) = 10.0;
z1_v(4) = 8.5; 
z1_v(5) = 8.5; 
z1_v(6) = 0.1;
z1_v(7) = 0.1;
z1_v(8) = 0.1;
z1_v(91) = 0.1;
z1_v(92) = 0.1;
%Inflection height for leaf-area density (m)
zc_v(1) = 28.0;             %叶密度弯曲高度
zc_v(2) = 17.0;
zc_v(3) = 15.0;
zc_v(4) = 10.0;
zc_v(5) = 10.0;
zc_v(6) = 0.55;
zc_v(7) = 0.3;
zc_v(8) = 0.35;
zc_v(91) = 0.55;
zc_v(92) = 0.55;

vcover_v(1) = 1.0;                  %冠层覆盖比
vcover_v(2) = 1.0;
vcover_v(3) = 1.0;
vcover_v(4) = 1.0;
vcover_v(5) = 1.0;
vcover_v(6) = 1.0;
vcover_v(7) = 0.1;
vcover_v(8) = 1.0;
vcover_v(91) = 1.0;
vcover_v(92) = 1.0;
%Leaf area distribution factor      %叶面角分布因子
chil_v(1) = 0.1;
chil_v(2) = 0.25;
chil_v(3) = 0.125; 
chil_v(4) = 0.01;
chil_v(5) = 0.01;
chil_v(6) = -0.3;
chil_v(7) = 0.01;
chil_v(8) = 0.2;
chil_v(91) = -0.3; 
chil_v(92) = -0.3; 
%Leaf width (m)                     %叶宽
leafw_v(1) = 0.05; 
leafw_v(2) = 0.08; 
leafw_v(3) = 0.04; 
leafw_v(4) = 0.001; 
leafw_v(5) = 0.001;
leafw_v(6) = 0.01; 
leafw_v(7) = 0.003; 
leafw_v(8) = 0.01;
leafw_v(91) = 0.01;
leafw_v(92) = 0.01;
%Leaf length (m)                %叶长
leafl_v(1) = 0.1;   
leafl_v(2) = 0.15; 
leafl_v(3) = 0.1; 
leafl_v(4) = 0.055;
leafl_v(5) = 0.04;
leafl_v(6) = 0.3;
leafl_v(7) = 0.03;
leafl_v(8) = 0.3;
leafl_v(91) = 0.3;
leafl_v(92) = 0.3;
%Total depth of three moisture layers (m)   %土壤深度
sodep_v(1) = 3.5;
sodep_v(2) = 2.0;
sodep_v(3) = 2.0;
sodep_v(4) = 2.0;
sodep_v(5) = 2.0;
sodep_v(6) = 1.5;
sodep_v(7) = 1.5;
sodep_v(8) = 1.5;
sodep_v(91) = 1.5;
sodep_v(92) = 1.5;
%Rooting depth (m)              %根深
rootd_v(1) = 1.5; 
rootd_v(2) = 1.5;
rootd_v(3) = 1.5;
rootd_v(4) = 1.5;
rootd_v(5) = 1.5;
rootd_v(6) = 1.0;
rootd_v(7) = 1.0;
rootd_v(8) = 1.0;
rootd_v(91) = 1.0;
rootd_v(92) = 1.0;
%Optical properties

%Live leaf reflectance to visible       %活植物可见光反射率
reflv_v(1) = 0.1;
reflv_v(2) = 0.1;
reflv_v(3) = 0.07;
reflv_v(4) = 0.07;
reflv_v(5) = 0.07;
reflv_v(6) = 0.105;
reflv_v(7) = 0.1;
reflv_v(8) = 0.105;
reflv_v(91) = 0.105;
reflv_v(92) = 0.105;
%Dead leaf reflectance to visible    %死植物可见光反射率
refdv_v(1) = 0.16;
refdv_v(2) = 0.16;
refdv_v(3) = 0.16;
refdv_v(4) = 0.16;
refdv_v(5) = 0.16;
refdv_v(6) = 0.36;
refdv_v(7) = 0.16;
refdv_v(8) = 0.36;
refdv_v(91) = 0.36; 
refdv_v(92) = 0.36; 
%Live leaf reflectance to near IR       %活植物近红外反射率
refln_v(1) = 0.45;
refln_v(2) = 0.45;
refln_v(3) = 0.40;
refln_v(4) = 0.35;
refln_v(5) = 0.35;
refln_v(6) = 0.58;
refln_v(7) = 0.45;
refln_v(8) = 0.58;
refln_v(91) = 0.58; 
refln_v(92) = 0.58; 
%Dead leaf reflectance to near IR           %死植物近红外反射率
refdn_v(1) = 0.39;
refdn_v(2) = 0.39;
refdn_v(3) = 0.39;
refdn_v(4) = 0.39;
refdn_v(5) = 0.39;
refdn_v(6) = 0.58;
refdn_v(7) = 0.39;
refdn_v(8) = 0.58;
refdn_v(91) = 0.58;
refdn_v(92) = 0.58;
%Live leaf transmittance to visible         %活植物可见光透射率
tranlv_v(1) = 0.05;
tranlv_v(2) = 0.05;
tranlv_v(3) = 0.05;
tranlv_v(4) = 0.05;
tranlv_v(5) = 0.05;
tranlv_v(6) = 0.07;
tranlv_v(7) = 0.05;
tranlv_v(8) = 0.07;
tranlv_v(91) = 0.07;
tranlv_v(92) = 0.07;
%Dead leaf transmittance to visible         %死植物可见光透射率
trandv_v(1) = 0.001;
trandv_v(2) = 0.001;
trandv_v(3) = 0.001;
trandv_v(4) = 0.001;
trandv_v(5) = 0.001;
trandv_v(6) = 0.22;
trandv_v(7) = 0.001;
trandv_v(8) = 0.22;
trandv_v(91) = 0.22;
trandv_v(92) = 0.22;
%Live leaf transmittance to near IR          %活植物近红外透射率
tranln_v(1) = 0.25;
tranln_v(2) = 0.25;
tranln_v(3) = 0.15;
tranln_v(4) = 0.10;
tranln_v(5) = 0.10;
tranln_v(6) = 0.25;
tranln_v(7) = 0.25;
tranln_v(8) = 0.25;
tranln_v(91) = 0.25;
tranln_v(92) = 0.25;
%Dead leaf transmittance to near IR           %死植物近红外透射率
trandn_v(1) = 0.001;    
trandn_v(2) = 0.001;
trandn_v(3) = 0.001;
trandn_v(4) = 0.001;
trandn_v(5) = 0.001;
trandn_v(6) = 0.38;
trandn_v(7) = 0.001;
trandn_v(8) = 0.38;
trandn_v(91) = 0.38;
trandn_v(92) = 0.38;
%Soil reflectance to visible                %可见光土壤反射率
sorefv_v(1) = 0.11;
sorefv_v(2) = 0.11;
sorefv_v(3) = 0.11;
sorefv_v(4) = 0.11;
sorefv_v(5) = 0.11;

% Soil reflectance for grid cells designed as bare soil within biomes 6 and 7 
% should be specified according to ERBE. The following value is assumed

sorefv_v(6) = 0.11;
sorefv_v(7) = 0.11;
sorefv_v(8) = 0.11;
sorefv_v(91) = 0.10;
sorefv_v(92) = 0.10;
%Soil reflectance to near IR             %近红外土壤反射率
sorefn_v(1) = 0.225;
sorefn_v(2) = 0.225;
sorefn_v(3) = 0.225;
sorefn_v(4) = 0.225;
sorefn_v(5) = 0.225;

% Soil reflectance for grid cells designed as bare soil within biomes 6 and 7 
%should be specified according to ERBE. The following value is assumed

sorefn_v(6) = 0.225;
sorefn_v(7) = 0.225;
sorefn_v(8) = 0.225;
sorefn_v(91) = 0.150;
sorefn_v(92) = 0.150;

shti_cst=0.3;       %光合作用高温剪切因子
slti_cst=0.2;       %光合作用低温剪切因子
trda_cst=1.3;       %呼吸高温剪切因子S5
trdm_cst=328;       %呼吸高温剪切因子S6
trop_cst=298;           %未使用
btheta_cst = 0.95;  %光合作用耦合系数

%Type 2: time-invariant biomes dependent parameters

%Maximum rubsico capacity of top leaf (mol / m2 s)  %  光合作用rubsico催化速度
vmax0_v(1) = 1.0e-4;
vmax0_v(2) = 1.0e-4;
vmax0_v(3) = 8.0e-5;
vmax0_v(4) = 6.0e-5;
vmax0_v(5) = 1.0e-4;
vmax0_v(6) = 3.0e-5;
vmax0_v(7) = 6.0e-5;
vmax0_v(8) = 6.0e-5;
vmax0_v(91) = 1.0e-4;
vmax0_v(92) = 1.0e-4;
%Intrinsic quantum efficiency (mol / mol)           %内部量子效应参数
effcon_v(1)= 0.08; 
effcon_v(2)= 0.08;
effcon_v(3)= 0.08;
effcon_v(4)= 0.08;
effcon_v(5)= 0.08;
effcon_v(6)= 0.05;
effcon_v(7)= 0.08;
effcon_v(8)= 0.08;
effcon_v(91)= 0.08;
effcon_v(92)= 0.08;
%Conductance_photosynthesis slope parameter (mol / m2 s)    %气孔斜率因子
gradm_v(1) = 9.0;
gradm_v(2) = 9.0;
gradm_v(3) = 9.0;
gradm_v(4) = 9.0;
gradm_v(5) = 9.0;
gradm_v(6) = 4.0;
gradm_v(7) = 9.0;
gradm_v(8) = 9.0;
gradm_v(91) = 9.0;
gradm_v(92) = 9.0;
%Minimum stamotal conductance (i.e., Conductance_photosynthesis intercept)
%(mol / m2 s)                                   %气孔斜率因子最小气孔传导率
binter_v(1)= 0.01;          
binter_v(2)= 0.01;
binter_v(3)= 0.01;
binter_v(4)= 0.01;
binter_v(5)= 0.01;
binter_v(6)= 0.04;
binter_v(7)= 0.01;
binter_v(8)= 0.01;
binter_v(91)= 0.01;
binter_v(92)= 0.01;
%Photosynthesis coupling coeffiicent for wc and we
%Note: Photosynthesis coupling coeffiicent for wp,wc and we is independent
%of vegetation and thus is a constant, 
atheta_v(1)= 0.98;                          %光合作用耦合系数
atheta_v(2)= 0.98;
atheta_v(3)= 0.98;
atheta_v(4)= 0.98;
atheta_v(5)= 0.98;
atheta_v(6)= 0.80;
atheta_v(7)= 0.98;
atheta_v(8)= 0.98;
atheta_v(91)= 0.98;
atheta_v(92)= 0.98;
%One half point of high temperature inhibition function (K)
hhti_v(1)= 313;                             %光合作用高温剪切因子
hhti_v(2)= 311;
hhti_v(3)= 307;
hhti_v(4)= 303;
hhti_v(5)= 303;
hhti_v(6)= 313;
hhti_v(7)= 313;
hhti_v(8)= 303;
hhti_v(91)= 308;
hhti_v(92)= 308;
%One half point of low temperature inhibition function (K)
hlti_v(1)= 288;                             %光合作用低温剪切因子
hlti_v(2)= 283;
hlti_v(3)= 281;
hlti_v(4)= 278;
hlti_v(5)= 278;
hlti_v(6)= 288;
hlti_v(7)= 283;
hlti_v(8)= 278;
hlti_v(91)= 281;
hlti_v(92)= 281;
%One half critical leaf-water potential limit (m)
phc_v(1)= -200;                                 %半阻碍水势参数
phc_v(2)= -200;
phc_v(3)= -200;
phc_v(4)= -200;
phc_v(5)= -200;
phc_v(6)= -200;
phc_v(7)= -300;
phc_v(8)= -200;
phc_v(91)= -200;
phc_v(92)= -200;
%Leaf respiration fraction of vmax0     %叶呼吸作用影响因子
respcp_v(1)= 0.015;                             
respcp_v(2)= 0.015;
respcp_v(3)= 0.015;
respcp_v(4)= 0.015;
respcp_v(5)= 0.015;
respcp_v(6)= 0.025;
respcp_v(7)= 0.015;
respcp_v(8)= 0.015;
respcp_v(91)= 0.015;
respcp_v(92)= 0.015;