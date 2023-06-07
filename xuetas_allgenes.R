library(ggplot2)
library(dplyr)
library(reshape2)
library(readr)
#########
## CNV ##
#########
## 1 ## Load the data
data <- read.table("Escritorio/pid/xuetas_spain/xuetas_allsv.tsv", header = TRUE, sep = "\t")
data <- subset(data, is.na(Gene_count)) # rows with a number in gene_count have the unique genes of the dataset and would bias the results
length(unique(data$Gene_name)) #1731

## 2 ## Count the occurrences of each Gene_ID
sv_counts <- as.data.frame(table(data$Gene_name))
sv_counts_f20 <- sv_counts[sv_counts$Freq > 20, ] # Filter the counts with more than 20 occurrences

## 3 ## From intersection list
#[['OTULIN', 'PTPRJ', 'DUOX2', 'CFHR4', 'FCGR2B', 'TGFBR1', 'FCGR3A', 'CFHR1', 'ADAMTS13', 'FANCD2', 'C4B', 'UNC93B1', 'ADGRE2', 'RELA', 'ALPI', 'CFH', 'GZMB', 'NCF1', 'CFHR3', 'PMS2', 'DNMT3B', 'POLE', 'SMARCD2', 'ATAD3A', 'MBL2', 'PSTPIP1', 'PSMG2', 'SH3KBP1', 'C4A', 'CARMIL2', 'TNFRSF13C', 'SAR1B', 'TBX1', 'FCGR3B', 'STAT4']
sv_counts_intersect <- sv_counts[sv_counts$Var1 %in% c('OTULIN', 'PTPRJ', 'DUOX2', 'CFHR4', 'FCGR2B', 'TGFBR1', 'FCGR3A', 'CFHR1', 'ADAMTS13', 'FANCD2', 'C4B', 'UNC93B1', 'ADGRE2', 'RELA', 'ALPI', 'CFH', 'GZMB', 'NCF1', 'CFHR3', 'PMS2', 'DNMT3B', 'POLE', 'SMARCD2', 'ATAD3A', 'MBL2', 'PSTPIP1', 'PSMG2', 'SH3KBP1', 'C4A', 'CARMIL2', 'TNFRSF13C', 'SAR1B', 'TBX1', 'FCGR3B', 'STAT4'),]
sv_counts_intersect <- sv_counts_intersect[sv_counts_intersect$Freq > 3, ] # Filter the counts with more than 3 occurrences

## 4 ## Plot the CNVs in genes within the intersection list
ggplot(data = data[data$Gene_name %in% sv_counts_intersect$Var1, ]) +
  aes(x = Gene_name, fill = Status) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Counts of Gene IDs in intersection")

## 5 ## Formatted table with each unique gene in a row and the proportions of DEL and DUP in it
summary_table <- data %>%
  group_by(Gene_name) %>%
  summarise(
    count = n(),
    afected_dup = sum(Status == "afected" & SV_type == "DUP"),
    afected_del = sum(Status == "afected" & SV_type == "DEL"),
    healthy_dup = sum(Status == "healthy" & SV_type == "DUP"),
    healthy_del = sum(Status == "healthy" & SV_type == "DEL"),
    total_dup = afected_dup + healthy_dup,
    total_del = afected_del + healthy_del,
    proportion_dup = paste0(afected_dup, "/", healthy_dup),
    proportion_del = paste0(afected_del, "/", healthy_del),
    fraction_dup = afected_dup/healthy_dup,
    fraction_del = afected_del/healthy_del 
  )%>%
  arrange(desc(afected_dup), desc(afected_del))
summary_table_8_18 <- summary_table[summary_table$count > 8, ] # Filter the genes with more than 14 counts
summary_table_8_18 <- summary_table_8_18[summary_table_8_18$count < 18, ] # Filter the genes with less than 22 counts

## 6 ## Format the summary table to have two separate tables in long format, each for DUPs and DELs only
df_long_dup <- melt(summary_table_8_18, id.vars = "Gene_name", measure.vars = c("afected_dup", "healthy_dup"))
df_long_del <- melt(summary_table_8_18, id.vars = "Gene_name", measure.vars = c("afected_del", "healthy_del"))

df_long_dup_to_delete <- df_long_dup$Gene_name[df_long_dup$value == 0]
df_long_dup <- df_long_dup[!(df_long_dup$Gene_name %in% df_long_dup_to_delete),] # Delete genes with no afected DUP cases

df_long_del_to_delete <- df_long_del$Gene_name[df_long_del$value == 0]
df_long_del <- df_long_del[!(df_long_del$Gene_name %in% df_long_del_to_delete),] # Delete genes with no afected DEL cases

check_value <- function(gene) { # Define a function that checks if the value for "healthy_del" is higher than "afected_del" (or *_dup)
  if (gene$value[gene$variable == "healthy_del"] > gene$value[gene$variable == "afected_del"]) {
    return(NULL)
  } else {
    return(gene)
  }
}

df_long_del_filtered <- do.call(rbind, lapply(split(df_long_del, df_long_del$Gene_name), check_value)) # Apply the check_value function to each group of Gene_name and bind the results into a single data frame
df_long_dup_filtered <- do.call(rbind, lapply(split(df_long_dup, df_long_dup$Gene_name), check_value))

# create stacked bar plot for duplicates
ggplot(df_long_dup, aes(x = Gene_name, y = value, fill = variable)) + 
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(x = "Gene", y = "Count") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  #scale_fill_manual(values = c("afected_dup" = "red", "healthy_dup" = "blue")) +
  ggtitle("Stacked Bar Plot for afected_dup and healthy_dup")

# create stacked bar plot for deletions
ggplot(df_sorted, aes(x = Gene_name, y = value, fill = variable)) + 
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(x = "Gene", y = "Count") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Stacked Bar Plot for afected_del and healthy_del")

## 7 ## Make a list of the unique genes in df_long_del_filtered and df_long_dup_filtered to filter those genes from summary_table_8_18
unique_gene_names <- unique(c(df_long_del_filtered$Gene_name, df_long_dup_filtered$Gene_name))
summary_table_8_18_filtered <- summary_table_8_18[summary_table_8_18$Gene_name %in% unique_gene_names,]

## 8 ## Save table
write_tsv(x = summary_table_8_18_filtered, file = "~/Escritorio/pid/xuetas_spain/list_genes_cnv.tsv")

#++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--++--#
#########
## SNP ##
#########
# Load the data
data <- read.table("Escritorio/pid/xuetas_spain/xuetas_allgenes_hom.filtered_annotation.popfreq.100.tsv", header = TRUE, sep = "\t")

# Create the bar plot
ggplot(data, aes(x = Gene_ID, fill = Name)) + 
  geom_bar() +
  labs(x = "Gene_ID", y = "Count") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Count the occurrences of each Gene_ID
gene_counts <- as.data.frame(table(data$Gene_ID))

# Filter the counts with more than 2 occurrences
gene_counts <- gene_counts[gene_counts$Freq > 2, ]

# Create the plot
ggplot(data = data[data$Gene_ID %in% gene_counts$Var1, ]) +
  aes(x = Gene_ID, fill = Name) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Counts of Gene IDs with more than 2 occurrences")


# Count the occurrences of each POS
variant_counts <- as.data.frame(table(data$POS))

# Filter the counts with more than 5 occurrences
variant_counts <- variant_counts[variant_counts$Freq > 2, ]
# Create the plot
ggplot(data = data[data$POS %in% variant_counts$Var1, ]) +
  aes(x = as.factor(POS), fill = Name) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Counts of Variants with more than 2 occurrences")

# Genes in intersection with list
# 'AP3D1', 'MAD2L2', 'TAOK2', 'POLA1', 'SH3KBP1', 'PIGA', 'C4A'
gene_counts <- gene_counts[gene_counts$Var1 %in% c('AP3D1', 'MAD2L2', 'TAOK2', 'POLA1', 'SH3KBP1', 'PIGA', 'C4A'),]
# Create the plot
ggplot(data = data[data$Gene_ID %in% gene_counts$Var1, ]) +
  aes(x = Gene_ID, fill = Name) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Counts of Gene IDs in intersection")