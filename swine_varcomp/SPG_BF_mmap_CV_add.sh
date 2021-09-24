#!/bin/bash

for data in 1  2 3 4 5 6 7 8 9 10
do 
# Get PEBV
./mmap.2018_04_07_13_28.intel --ped SPG.ped.csv --phenotype_filename SPG_QC_BF_sln.csv --trait BF --covariate_filename inbred.csv --covariates F  --estimate_variance_components --variance_component_filename SPG_QC_mmap_add_grm SPG_sow_mmap_i --subject_set SPG_BF_T$data.csv --variance_component_label A S --file_suffix SPG.BF_add.CV$data --num_mkl_threads 20 --num_em_reml_burnin 2 --use_em_ai_reml --single_pedigree --use_dpotrs

done

# Get inbreeding effect
./mmap.2018_04_07_13_28.intel --ped SPG.ped.csv --phenotype_filename SPG_QC_BF_sln.csv --trait BF --covariate_filename inbred.csv --covariates F  --estimate_variance_components --variance_component_filename SPG_QC_mmap_add_grm SPG_sow_mmap_i --variance_component_label A S --file_suffix SPG.BF_add.CV.Adj --num_mkl_threads 20 --num_em_reml_burnin 2 --use_em_ai_reml --single_pedigree --use_dpotrs


 mkdir BF_a
 mv BF.SPG.BF_add.CV* BF_a