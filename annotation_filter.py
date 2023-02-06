#!/usr/bin/env python3
import pandas as pd
import sys

'''
NO
__________
3'/5'utr*
conservative in-frame
downstream
initiatior codon variant
inter/intragenic region
intron
splice region
synonyms
up stream
-------------
SI
_____________
disruptive in-frame *
frameshift*
missense*
splice_acceptor/donor*
stop gained
start_lost
stop_lost
stop_retained
bidirectional_gene_fusion
---------------
Reminder: some variants can have different annotations as they can affect the transcripts differently
'''

#! Another common operation is the use of boolean vectors to filter the data. The operators are: | for or, & for and, and ~ for not. These must be grouped by using parentheses.

# Read CSV file #? For argentina I will use the previously filtered file containing homozygous variants only in the index
f=sys.argv[1]
foo = f[:-4]
file = open(f)
df = pd.read_csv(file, sep='\t', low_memory=False)

# Filter file by Annotation column
annot_df = df[  (df['Annotation']!='3_prime_UTR_variant') & (df['Annotation']!='5_prime_UTR_variant') & (df['Annotation']!='downstream_gene_variant')
    & (df['Annotation']!='conservative_inframe_deletion')  & (df['Annotation']!='conservative_inframe_insertion')  & (df['Annotation']!='downstream_gene_variant')
    & (df['Annotation']!='intergenic_region')  & (df['Annotation']!='intragenic_variant')  & (df['Annotation']!='intron_variant') & (df['Annotation']!='splice_region_variant')
    & (df['Annotation']!='splice_region_variant&synonymous_variant')  & (df['Annotation']!='splice_region_variant&intron_variant')
    & (df['Annotation']!='splice_acceptor_variant&intron_variant') & (df['Annotation']!='splice_acceptor_variant&intron_variant')
    & (df['Annotation']!='splice_donor_variant&intron_variant') & (df['Annotation']!='splice_acceptor_variant&splice_donor_variant&intron_variant')
    & (df['Annotation']!='synonymous_variant')  & (df['Annotation']!='upstream_gene_variant')  & (df['Annotation']!='downstream_gene_variant')  
    & (df['Annotation']!='non_coding_transcript_exon_variant') & (df['Annotation']!='conservative_inframe_deletion&splice_region_variant') 
    & (df['Annotation']!='splice_region_variant&downstream_gene_variant') & (df['Annotation']!='initiatior_codon_variant') 
    & (df['Annotation']!='conservative_inframe_insertion&splice_region_variant') 
    & (df['Annotation']!='splice_acceptor_variant&conservative_inframe_deletion&splice_region_variant&intron_variant')]

# print(annot_df)
# Save filtered CSV file
annot_df.to_csv(foo+".filtered_annotation.tsv", sep="\t", header=True, index=False)
