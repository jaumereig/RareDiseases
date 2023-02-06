#!/usr/bin/env python3
# # Initialize
import sys
import pandas as pd


# Read TSV file
f = sys.argv[1]
foo = f[:7] # take 7 first characters (id.)
file = open(f)
df = pd.read_csv(file, sep='\t', low_memory=False)

# Filter file. Select rows with AF = 0.5 (heterozygosity)
hom_het_df = df[df['AF']==0.5]

# Save filtered TSV file
hom_het_df.to_csv(foo+"Heterozygous.tsv", sep="\t", header=True, index=False)