originalpath = 'C:\\Users\\lb\\Desktop\\point'
import numpy as np

for i in range(1,26):
    path = originalpath + '\\' + str(i) + '\in_param.txt'
    print(path)
    param = open(path)
    paramdata = param.readlines()
    year = int(paramdata[22][-7:-3])+10
    # print(year % 4)
    if year % 4 ==0:
        long = 8784
    else:
        long = 8760
    water = originalpath + '\\' + str(i) + '\waterbalance.txt'
    waterfile = np.loadtxt(water)
    et_sum =sum(waterfile[-(7+long):-7,5])

    moisture = originalpath + '\\' + str(i) + '\moisture.txt'
    moisturefile = np.loadtxt(moisture)
    moisture_mean =moisturefile[-(7+long):-7,2].mean()

    print(et_sum)
    print(moisture_mean)

