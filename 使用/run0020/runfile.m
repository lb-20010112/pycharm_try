disp('why');
run('lon_latToallparamhun.m');
run('lon_lat_toNCvaluehun.m');
startmatlabpool(40);
run('multi_runhun.m');
closematlabpool;
