#!/usr/bin/env python3
import sys
import pandas as pd

# crido al script de la següent manera:
#* python df_denovo.py path_to_file_one path_to_file_index path_to_file_two

# definir directori pels outputs
output_dir="/home/vant/Escritorio/pid/argentina_yam/"

file_index = pd.read_csv(sys.argv[1], sep='\t', low_memory=False)
file_one = pd.read_csv(sys.argv[2], sep='\t', low_memory=False)
file_two = pd.read_csv(sys.argv[3], sep='\t', low_memory=False)

# df_final = pd.DataFrame(columns=['CHROM', 'POS', 'Gene_ID', 'AF', 'gnomAD_WG_AF'])

for idx, row in file_one.iterrows():
    same_row_f = file_index[((file_index['CHROM'] != row['CHROM']) & (file_index['POS'] != row['POS']))]
 
    df_final = pd.concat([same_row_f], ignore_index=True)
    # print(df_final)
    if idx == 0:
       break

for idx, row in file_two.iterrows():
    same_row_f = df_final[((df_final['CHROM'] != row['CHROM']) & (df_final['POS'] != row['POS']))]

    df_final = pd.concat([same_row_f], ignore_index=True)
    # print(df_final)
    if idx == 0:
       break

df_final.to_csv("denovo.tsv", sep="\t", header=True, index=False)