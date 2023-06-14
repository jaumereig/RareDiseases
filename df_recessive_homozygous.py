#!/usr/bin/env python3
import sys
import pandas as pd

# crido al script de la següent manera:
#* python df_recessive_hom.py path_to_file_one path_to_file_index path_to_file_two

#* definir directori pels outputs
output_dir="/home/vant/Escritorio/pid/argentina_yam/"

file_index = pd.read_csv(sys.argv[1], sep='\t', low_memory=False, header=0)
file_one = pd.read_csv(sys.argv[2], sep='\t', low_memory=False, header=0)
file_two = pd.read_csv(sys.argv[3], sep='\t', low_memory=False, header=0)
file_three = pd.read_csv(sys.argv[4], sep='\t', low_memory=False, header=0)
#file_four = pd.read_csv(sys.argv[5], sep='\t', low_memory=False, header=0)

file_index['Name'] = 'AY4858' #? add column with corresponding file name
file_one['Name'] = 'AY4860' # pare healthy
file_two['Name'] = 'AY4857' # sis healthy
file_three['Name'] = 'AY4859' # sis disease
#file_four['Name'] = 'AY4875' # daughter disease

het_file_1_2_3 = pd.concat([file_one, file_two, file_three])
# print(het_file_1_2_3)
multi_file_name = het_file_1_2_3.groupby(["Gene_ID"]).Name.nunique().gt(1)
het_file_1_2_3 = het_file_1_2_3.loc[het_file_1_2_3.Gene_ID.isin(multi_file_name[multi_file_name].index)] #! borra els gens únics del mateix fitxer que no surten a l'altre fitxer
# print(het_file_1_2_3)
het_file_1_2_3 = het_file_1_2_3.groupby('POS').filter(lambda g: len(g) > 1).drop_duplicates(subset=['POS', 'Name'], keep="first") #! selecciona gens amb la mateixa POS a fitxers diferents
# print(het_file_1_2_3)
df_index_123 = pd.concat([het_file_1_2_3, file_index]) #! afegir index file
print(df_index_123)
df_final = df_index_123[df_index_123.duplicated(subset=['CHROM','POS'])] #! triar les línies amb igual POS
print(df_final)
df_final = df_final[df_final.Name == 'AY4858'] #! només index
print(df_final)
df_final.to_csv("hom.rec.fam11.tsv", sep="\t", header=True, index=False)
# print(len(df_final))


############? FOR FAM24
# het_file_1_2_3 = pd.concat([file_one, file_two])
# multi_file_name = het_file_1_2_3.groupby(["Gene_ID"]).Name.nunique().gt(1)
# het_file_1_2_3 = het_file_1_2_3.loc[het_file_1_2_3.Gene_ID.isin(multi_file_name[multi_file_name].index)] #! borra els gens únics del mateix fitxer que no surten a l'altre fitxer
# het_file_1_2_3 = het_file_1_2_3.groupby('POS').filter(lambda g: len(g) > 1).drop_duplicates(subset=['POS', 'Name'], keep="first") #! selecciona gens amb la mateixa POS a fitxers diferents
# # print(het_file_1_2_3)
# # het_file_1_2_3.to_csv("hhet_file_1_2_3.tsv", sep="\t", header=True, index=False)
# df_index_123 = pd.concat([het_file_1_2_3, file_index, file_three]) #! afegir index file
# print(df_index_123)
# #? df_final = df_index_123[df_index_123.duplicated(subset=['CHROM','POS'])] #! triar les línies amb igual POS
# multi_file_name = df_index_123.groupby(["Gene_ID"]).Name.nunique().gt(1)
# print(multi_file_name)
# df_final = df_index_123.loc[df_index_123.Gene_ID.isin(multi_file_name[multi_file_name].index)] #! borra els gens únics del mateix fitxer que no surten a l'altre fitxer
# df_final = df_final.groupby('POS').filter(lambda g: len(g) > 1).drop_duplicates(subset=['POS', 'Name'], keep="first") #! selecciona gens amb la mateixa POS a fitxers diferents
# df_final = df_final[df_final['AF']==1]
# df_final = df_final[df_final['Name']=='AY4877'] #! només index
# print(df_final)
# df_final.to_csv("hom.rec.fam24.tsv", sep="\t", header=True, index=False)



############? FOR ARG
# het_file_1_2 = pd.concat([file_one, file_two]) #! merge rows from parent files
# multi_file_name = het_file_1_2.groupby(["Gene_ID"]).Name.nunique().gt(1)
# het_file_1_2 = het_file_1_2.loc[het_file_1_2.Gene_ID.isin(multi_file_name[multi_file_name].index)] #! borra els gens únics del mateix fitxer que no surten a l'altre fitxer
# het_file_1_2 = het_file_1_2.groupby('POS').filter(lambda g: len(g) > 1).drop_duplicates(subset=['POS', 'Name'], keep="first") #! selecciona gens amb la mateixa POS a fitxers diferents
# df_index_12 = pd.concat([het_file_1_2, file_index]) #! afegir index file
# df_final = df_index_12[df_index_12.duplicated(subset=['CHROM','POS'])] #! triar les línies amb igual POS
# df_final = df_final[df_final.Name == 'file_index'] #! només index
# # print(len(df_final))
# df_final.to_csv("hom.rec.tsv", sep="\t", header=True, index=False)
# df_unique = pd.DataFrame(pd.unique(df_final['Gene_ID'])) #!
# print(df_unique)
# df_unique.to_csv("het.rec.unique.tsv", sep="\t", header=False, index=False)