#!/usr/bin/env python3
import sys
import pandas as pd

# crido al script de la següent manera:
#* python df_compound_het.py path_to_file_one path_to_file_index path_to_file_two

# definir directori pels outputs
output_dir="/home/vant/Escritorio/pid/argentina_yam/"

file_index = pd.read_csv(sys.argv[1], sep='\t', low_memory=False)
file_one = pd.read_csv(sys.argv[2], sep='\t', low_memory=False)
file_two = pd.read_csv(sys.argv[3], sep='\t', low_memory=False)

df_final = pd.DataFrame(columns=['CHROM', 'POS', 'Gene_ID', 'AF_index', 'AF_m', 'AF_f', 'gnomAD_WG_AF'])

for idx, row in file_index.iterrows():
    af_padre = 'NA'
    af_madre = 'NA'

    same_row_f = file_one[((file_one['CHROM'] == row['CHROM']) & (file_one['POS']== row['POS']) & (file_one['Gene_ID']== row['Gene_ID']))]
    if not same_row_f.empty:
        af_padre = same_row_f['AF'].iloc[0]


    same_row_m = file_two[((file_two['CHROM'] == row['CHROM']) & (file_two['POS']== row['POS']) & (file_two['Gene_ID']== row['Gene_ID']))]
    if not same_row_m.empty:
        af_madre = same_row_m['AF'].iloc[0]

    new_row = pd.DataFrame({'CHROM': row['CHROM'], 'POS': row['POS'], 'Gene_ID':row['Gene_ID'], 'AF_index': row['AF'], 'AF_m': af_madre, 'AF_f': af_padre, 'gnomAD_WG_AF': row['gnomAD_WG_AF']}, index=[0])
    df_final = pd.concat([df_final, new_row], ignore_index=True)
    #if idx > 5000:
     #   break

df_final = df_final.loc[~((df_final['AF_m'] == 'NA') & (df_final['AF_f'] == 'NA') & (df_final['AF_index'] != 'NA')),:]
df_final = df_final[df_final.duplicated('Gene_ID', keep=False) == True]
df_final.to_csv("comhet.tsv", sep="\t", header=True, index=False)

df_unique = pd.DataFrame(pd.unique(df_final['Gene_ID']))
df_unique.to_csv("comhet.unique.tsv", sep="\t", header=False, index=False)
# print(df_unique)


# for row in file_index.itertuples():
#     af_padre = 'NA'
#     af_madre = 'NA'

#     same_row_f = file_one[((file_one['CHROM'] == row.CHROM) & (file_one['POS']== row.POS))]
#     if not same_row_f.empty:
#         af_padre = same_row_f['AF'].iloc[0]

#     same_row_m = file_two[((file_two['CHROM'] == row.CHROM) & (file_two['POS']== row.POS))]
#     if not same_row_m.empty:
#         af_madre = same_row_m['AF'].iloc[0]

#     new_row = pd.DataFrame({'CHROM': row.CHROM, 'POS': row.POS, 'AF_index': row.AF, 'AF_m': af_madre, 'AF_f': af_padre}, index=[0])
#     df_final = pd.concat([df_final, new_row], ignore_index=True)



# df_final = pd.DataFrame(columns=['CHROM', 'POS', 'Gene_ID', 'AF_index', 'AF_m', 'AF_f'])

# for idx, row in file_index.iterrows():
#     af_padre = 'NA'
#     af_madre = 'NA'

#     same_row_f = file_one[((file_one['CHROM'] == row['CHROM']) & (file_one['POS']== row['POS']) & (file_one['Gene_ID']== row['Gene_ID']))]
#     if not same_row_f.empty:
#         af_padre = same_row_f['AF'].iloc[0]
#         # print(same_row_f['AF'])

#     same_row_m = file_two[((file_two['CHROM'] == row['CHROM']) & (file_two['POS']== row['POS']) & (file_two['Gene_ID']== row['Gene_ID']))]
#     if not same_row_m.empty:
#         af_madre = same_row_m['AF'].iloc[0]

#     new_row = pd.DataFrame({'CHROM': row['CHROM'], 'POS': row['POS'], 'Gene_ID':row['Gene_ID'], 'AF_index': row['AF'], 'AF_m': af_madre, 'AF_f': af_padre}, index=[0])
#     df_final = pd.concat([df_final, new_row], ignore_index=True)