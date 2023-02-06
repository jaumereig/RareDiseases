#* $1 CHROM
#* $2 POS
#* $3 REF
#* $4 ALT
#* $5 QUAL
#* $6 Allele
#* $7 Annotation
#* $8 Annotation_impact
#* $9 Gene_Name
#* $10 Gene_ID
#!###############################################   main path
path="/home/vant/Escritorio/pid/argentina_yam";
#!###############################################   ...
#!###############################################   files
file1="${path}/AY4941/ShortVariants/AY4941.Homozygous.filtered_annotation.tsv";
file2="${path}/AY4954/ShortVariants/AY4954.Heterozygous.filtered_annotation.popfreq.tsv";
file3="${path}/AY4955/ShortVariants/AY4955.Heterozygous.filtered_annotation.popfreq.tsv";
file4="${path}/AY4947/ShortVariants/AY4947.Homozygous.0.5.tsv";
#!###############################################   ...
#!###############################################   commands

# awk 'FNR==NR{a[$1,$2];b[$1,$2];next} (($1,$2) in a) || (($1,$2) in b)' $file2 $file3 > ${path}/AY4954.AY4955.het.filtered_annotation.tsv;
# awk 'FNR==NR{a[$1,$2];b[$1,$2];next} (($1,$2) in a) || (($1,$2) in b)' ${path}/AY4954.AY4955.het.filtered_annotation.tsv $file1 > ${path}/AY4954.AY4955.AY4944.filtered_annotation.rechom.tsv;
# rm ${path}/AY4954.AY4955.het.filtered_annotation.tsv;

# file1="${path}/AY4941/ShortVariants/"
# file2="${path}/AY4954/ShortVariants/AY4954.allchr.norm.annot.snpEff.gnomAD.CADD.Clinvar.REVEL.InterVar.CandidateGenes.SpliceAI.tagSpliceAI_0.5.vcf.gz.full.xlsx.tsv";
# file3="${path}/AY4955/ShortVariants/AY4955.allchr.norm.annot.snpEff.gnomAD.CADD.Clinvar.REVEL.InterVar.CandidateGenes.SpliceAI.tagSpliceAI_0.5.vcf.gz.full.xlsx.tsv";
# awk 'FNR==NR{a[$1,$2];b[$1,$2];next} (($1,$2) in a) || (($1,$2) in b)' $file2 $file3 > ${path}/AY4954.AY4955.diff.tsv;
cat $file2 $file3 $file1 | sort | awk 'BEGIN{FS="\t"; V1=""; V2=""} 
    {if (V1==$1 && V2==$2) { b=b+1 } else 
    { print b":"$0; b=1; V1=$1; V2=$2} }' |grep "2:"|awk '
    BEGIN{FS=":"} {print $2}' > AY4941.test.tsv
