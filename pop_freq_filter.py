#!/usr/bin/env python3
import pandas as pd
import sys

# Read CSV file #? For argentina I will use the previously filtered file containing homozygous variants only in the index
f=sys.argv[1]
foo = f[:-4]
file = open(f)
df = pd.read_csv(file, sep='\t', low_memory=False)

# Filter file by Annotation column
annot_df = df[(df['gnomAD_WG_AF']<=0.001) | (df['gnomAD_WG_AF'].isnull())] #? 1% == 0.01 /// 1%º == 0.001

# Save filtered CSV file
annot_df.to_csv(foo+".popfreq.1000.tsv", sep="\t", header=True, index=False)

df_unique = pd.DataFrame(pd.unique(annot_df['Gene_ID']))
df_unique.to_csv(foo+".popfreq.1000.unique.tsv", sep="\t", header=False, index=False)