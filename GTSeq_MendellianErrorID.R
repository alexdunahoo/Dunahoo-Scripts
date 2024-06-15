# Script Name: GTSeq_MendellianErrorID.R

# Author: Alex Dunahoo
# Date: June 15, 2024

# Purpose: This script is used to identify loci with mendellian errors using the output of GTSeq genotyping scripts as the input. 
# Designed to be used with GTseq_Genotyper_v3.pl genotyping script: https://github.com/GTseq/GTseq-Pipeline/blob/master/GTseq_Genotyper_v3.pl

# Currently only works with one parent-offspring relationships

# Input Files Needed: Genotype File, Known Parent-Offspring Relationships

# Update these to match file paths.
relationshipFilePath <- "/Users/alexdunahoo/Desktop/FinalGenotyping/Relationships.csv"
genotypeFilePath <- "/Users/alexdunahoo/Desktop/FinalGenotyping/CompiledGenotypes.csv"

# Packages Needed: tidyverse
if (!require("tidyverse")) {  install.packages("tidyverse", dependencies = TRUE) ; library(tidyverse)}

# Read in csv file with known Parent-Offspring relationships
# Two columns: "Offspring" column and "Parent" column
relationships <- read_csv(relationshipFilePath)

# Create vectors of offspring and Parents
uniqueParents <- relationships %>% distinct(Parent) %>% pull()
uniqueOffspring <- relationships %>% distinct(Offspring) %>% pull()

# Read in csv file that is the output of GTSeq genotyping scripts
genotypes <- read_csv(genotypeFilePath) %>%
  
  mutate_all(~gsub(",", "", .)) %>%

  select(-c(2:6)) %>% pivot_longer(cols = 2:ncol(.),values_to = "Genotype",names_to = "Loci") 
  
# Create new data frames for Parent and offspring genotypes
ParentGenotypes <- genotypes %>% filter(Sample %in% uniqueParents)
offspringGenotypes <- genotypes %>% filter(Sample %in% uniqueOffspring)

# Create a new data frame that contains paired genotypes for both the Parent and offspring
pairedGenotypes <- left_join(offspringGenotypes,relationships,by = c("Sample" = "Offspring")) %>%
  
  left_join(ParentGenotypes,by = c("Parent" = "Sample","Loci" = "Loci"))

# Identifies loci with at least one mendellian error
lociWithMendellianError <- pairedGenotypes %>% 

  # Filter out ungenotyped loci
  filter(Genotype.x != "00" & Genotype.y != "00") %>%
  
  # Seperate genotypes into two allele columns
  separate(Genotype.x,into = c("JuvenileAllele1","JuvenileAllele2"),sep = 1) %>%
  separate(Genotype.y, into = c("ParentAllele1","ParentAllele2"),sep = 1) %>%

  # Filter for records that have a mendellian error
  # Mendellian Error = Juvenile Allele doesn't match what is possible from parents
  filter(JuvenileAllele1 != ParentAllele1 & JuvenileAllele1 != ParentAllele2) %>%
  filter(JuvenileAllele2 != ParentAllele1 & JuvenileAllele2 != ParentAllele2) %>%
  
  # Creates vector of loci with at least one mendellian error
  distinct(Loci) %>%
  pull()

# Removes all intermediate variables from the environment
rm(list = setdiff(ls(), "lociWithMendellianError"))
