import os
import pandas as pd
from multiprocessing import Pool

classlist = ['Shrub', 'Crop', 'FEN', 'FDB', 'Grass']
NCyearnumber = 2000
LCyearnumber = 2000
NCyear = str(NCyearnumber)
NCyear_1 = str(NCyearnumber - 1)
LCyear = str(LCyearnumber)
yearfile = LCyear[-2:] + NCyear[-2:]
numWorkers = 40  # 并行池个数

csvpath = f'./LC_ll/LC_ll{LCyear}'
runfile = f'./{yearfile}runfile/'
csvoutpath = f'./{yearfile}resultcsv/'

if not os.path.exists(csvoutpath):
    os.makedirs(csvoutpath)

def process_data(class_name):
    original_csv_file_path = f'{csvpath}/{class_name}.csv'
    original_data = pd.read_csv(original_csv_file_path)

    data = []
    for folder_name in os.listdir(f'{runfile}/{class_name}'):
        folder_path = os.path.join(runfile, class_name, folder_name)
        water_path = os.path.join(folder_path, 'waterbalance.txt')
        moisture_path = os.path.join(folder_path, 'moisture.txt')

        if os.path.exists(water_path) and os.path.exists(moisture_path):
            water_data = pd.read_csv(water_path, sep='\s+', header=None)
            et = water_data.iloc[8752:17535, 5].sum()

            moisture_data = pd.read_csv(moisture_path, sep='\s+', header=None)
            sm = moisture_data.iloc[8752:17535, 2].mean()

            data.append([int(folder_name), original_data.iloc[int(folder_name) - 1, 2],
                         original_data.iloc[int(folder_name) - 1, 0],
                         original_data.iloc[int(folder_name) - 1, 1], et, sm])
            data[-1] = [round(val, 6) if isinstance(val, float) else val for val in data[-1]]
        else:
            data.append([int(folder_name), original_data.iloc[int(folder_name) - 1, 2],
                         original_data.iloc[int(folder_name) - 1, 0],
                         original_data.iloc[int(folder_name) - 1, 1], -999, -999])
            print(f'水平衡文件或湿度文件不存在。 文件夹：{folder_path}')

    data_table = pd.DataFrame(data, columns=['foldername', 'type', 'lon', 'lat', 'et', 'sm'])
    data_table.to_csv(f'{csvoutpath}/{class_name}out.csv', index=False)

if __name__ == "__main__":
    with Pool(numWorkers) as pool:
        pool.map(process_data, classlist)
    print('操作完成')
