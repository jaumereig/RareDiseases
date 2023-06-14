# Rare Variants AID
#### FILTERING FILES FOR PREPROCESSING
1) xlsx2tsv.sh -> bash script to automatize the re-formatting of the excel VCFs to tab-separated files -- easier to process and read
2) select_heterozygous.py -> from input VCF extracts variants in heterozygosity
3) select_homozygous.py -> from input VCF extracts variants in homozygosity
4) annotation_filter.py -> from input VCF extracts variants with LoF or missense annotations (see script for more details)
5) pop_freq_filter.py -> from input VCF extracts variants with population frequency below 0.01 or with NA values
For consistency, better to use the filtering files in the same order, although is not necessary to obtain the right results in the end.

#### COMPOUND HETEROZYGOUS
1) df_compound_het.py -> creates a dataframe with the IDs of the input files and the common variants
   Example:
   
                      CHROM	POS	Gene_ID	AF_index	AF_1	AF_2	gnomAD_WG_AF
                      1	145299792	 NBPF10	0.5	0.5	0.5	0.00418
                      1	185299805	 OTOP1 	0.5	0.5	0.5	0.004214
#### DE NOVO
1) df_denovo.py -> filters variants of index that are not present in the rest of the family.
   Example (not all columns included):
   
                      CHROM	POS	REF	ALT	QUAL	Allele	Annotation	Annotation_Impact	Gene_Name AF
                      1	12921594	C	G	  33.64	G	  stop_gained	        HIGH	PRAMEF2  0.5
                      1	28785729	G	GA	34.6	GA	frameshift_variant	HIGH	PHACTR4  0.5

#### RECESSIVE HOMOZYGOUS
1) df_recessive_homozygous.py -> filters variants of index in accordance with the recessive homozygous inheritance model
   Example (not all columns included):
   

                     CHROM	   POS	REF	ALT	QUAL	Allele	Annotation	Annotation_Impact	Gene_Name AF
                     1	109793851	G	T	804.06	T	missense_variant	MODERATE	CELSR2   1.0
                     7	100807230	G	T	2658.06	T	missense_variant	MODERATE	VGF      1.0

#### VEO-IBD
1) veo_ibd.R -> contains different analyses based on different scenarios analysed. The outputs are either plots or tables to visualise the data.

#### Chuetas
1) xuetas_allgenes.R -> contains different analyses based on different scenarios analysed. The outputs are either plots or tables to visualise the data.

Discalaimer: these scripts are a selection from all the ones used in the process of each cohort analysis. They represent the basic steps to get initial results.
