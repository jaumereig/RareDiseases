library(dplyr)
library(ggplot2)
################################################################################
#############         HOMOZYGOUS RECESSIVE MODEL                   #############            
################################################################################
## 1 ## Load the data
hom.rec <- read.table("Escritorio/pid/veo_ibd/veo_ibd_selectedgenes_extended.Homozygous.filtered_annotation.tsv", header = TRUE, sep = "\t")

## 2 ## Make bar plot with the variants count of all genes colored by index ID
counts <- hom.rec %>% group_by(Name, Gene_ID) %>% summarise(n=n()) # Count the occurrences of each gene for each unique 'Name'

ggplot(counts, aes(x=Gene_ID, y=n, fill=Name)) + 
  geom_bar(stat="identity", position="stack") +
  xlab("Gene ID") + ylab("Count") +
  ggtitle("Counts of Genes by Name") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  theme(plot.title = element_text(hjust = 0.5))

ggplot(hom.rec, aes(x=Gene_ID, fill=Name)) + # Create a bar plot for each unique 'Name' value in facet_wrap style
  geom_bar() +
  facet_wrap(~ Name, scales="free") +
  labs(title="Counts of Each Gene by Unique 'Name' Value",
       x="Gene ID", y="Count") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  theme(plot.title = element_text(hjust = 0.5)) 

## 3 ## create a sub dataset that only includes the rows where the Gene_ID appears in only one of all the possible 'Name' values
sub_data <- hom.rec %>%
  group_by(Gene_ID) %>%
  filter(n_distinct(Name) == 1)
ggplot(sub_data, aes(x=Gene_ID, fill=Name)) + # Create a bar plot for each unique 'Name' value in facet_wrap style
  geom_bar() +
  facet_wrap(~ Name, scales="free") +
  labs(title="Counts of Each Gene by Unique 'Name' Value",
       x="Gene ID", y="Count") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  theme(plot.title = element_text(hjust = 0.5)) 

################################################################################
#############         COMPOUND HETEROZYGOUS MODEL                  #############
################################################################################
## 1 ## Load the data
comp.het <- read.table("Escritorio/pid/veo_ibd/veo_ibd_selectedgenes_extended.Heterozygous.filtered_annotation.popfreq.100.tsv", header = TRUE, sep = "\t")

## 2 ## Filter by keeping duplicated genes within each index
comp.het_filtered <- comp.het %>% # Keep only rows with duplicated values in Gene_ID for each Name
  group_by(Name) %>%
  filter(duplicated(Gene_ID) | duplicated(Gene_ID, fromLast = TRUE)) # 277 without pop_freq filter and 20 variants with pop_freq filter
length(unique(comp.het_filtered$Name)) # 5 without pop_freq filter and 12 (all) with pop_freq filter

################################################################################
################               DE NOVO MODEL                    ################
################################################################################
## 1 ## Load the data
denovo <- read.table("Escritorio/pid/veo_ibd/veo_ibd_selectedgenes_extended.Heterozygous.filtered_annotation.popfreq.100.tsv", header = TRUE, sep = "\t")

## 2 ## Filter by keeping NA frequencies
denovo.filtered <- denovo[is.na(denovo$gnomAD_WG_AF), ] # 91 variants
length(unique(denovo.filtered$Name)) # 27 (AY4992 has no NAs)

## 3 ## Observe variants in the same locus among different individuals
d <- denovo[duplicated(denovo$POS) & !duplicated(denovo$POS, fromLast = TRUE), ] # only IL6ST has a mutation in the same locus two individuals: AY4985, AY4988

################################################################################
################             CONTROL VARIANTS                   ################
################################################################################
################################################################################
#############         HOMOZYGOUS RECESSIVE MODEL                   #############            
################################################################################
## 1 ## Load the data
hom.rec.control <- read.table("Escritorio/pid/veo_ibd/veo_ibd_selectedgenes_control.Homozygous.filtered_annotation.tsv", header = TRUE, sep = "\t")

## 2 ## create a sub dataset that only includes the rows where the Gene_ID appears in only one of all the possible 'Name' values
sub_data.control <- hom.rec.control %>%
  group_by(Gene_ID) %>%
  filter(n_distinct(Name) == 1)

################################################################################
#############         COMPOUND HETEROZYGOUS MODEL                  #############
################################################################################
## 1 ## Load the data
comp.het.control <- read.table("Escritorio/pid/veo_ibd/veo_ibd_selectedgenes_control.Heterozygous.filtered_annotation.popfreq.100.tsv", header = TRUE, sep = "\t")

## 2 ## Filter by keeping duplicated genes within each index
comp.het_filtered.control <- comp.het.control %>% # Keep only rows with duplicated values in Gene_ID for each Name
  group_by(Name) %>%
  filter(duplicated(Gene_ID) | duplicated(Gene_ID, fromLast = TRUE)) # 277 without pop_freq filter and 20 variants with pop_freq filter
length(unique(comp.het_filtered.control$Name)) # 5 without pop_freq filter and 12 (all) with pop_freq filter

################################################################################
################               DE NOVO MODEL                    ################
################################################################################
## 1 ## Load the data
denovo <- read.table("Escritorio/pid/veo_ibd/veo_ibd_selectedgenes_control.Heterozygous.filtered_annotation.popfreq.100.tsv", header = TRUE, sep = "\t")

## 2 ## Filter by keeping NA frequencies
denovo.filtered <- denovo[is.na(denovo$gnomAD_WG_AF), ] # 91 variants
length(unique(denovo.filtered$Name)) # 27 (AY4992 has no NAs)

