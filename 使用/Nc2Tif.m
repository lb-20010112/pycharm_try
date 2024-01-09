ncdata = 'H:\Liubo\C3S-LC-L4-LCCS-Map-300m-P1Y-2020-v2.1.1.nc';
info = ncinfo(ncdata);
Name = {info.Variables.Name};
disp(Name);

lc = ncread(ncdata,'lccs_class');
lon =ncread(ncdata,'lon');
lat=ncread(ncdata,'lat');

lc = rot90(lc,1);
lc = uint8(lc);
R= georasterref('RasterSize',size(lc),'Latlim',[double(min(lat)),double(max(lat))],'Lonlim',[double(min(lon)),double(max(lon))]);

tiff = 'H:\Liubo\ESACCI2020_4.tif';

geotiffwrite(tiff,lc,R);