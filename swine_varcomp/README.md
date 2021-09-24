*Updated August 28, 2021*

---

## Quality control
### Call rate
```
perl get_call_rate.pl findhap-geno-folder out-filename-prefix
```
The above commond uses findhap raw genotypes (generally named as **genotypes.txt**) to calculate SNP call rate and individual call rate. Individual call rate will be used to filter out animals in REML. SNP call rate will be used to filter out SNPs when building GRMs.

### MAF and HWE
QCs based on MAF and HWE will be used by PLINK for computing inbreeding coefficients and by BFMAP for computing GRMs.

---

## Converting findhap files to plink binary files
### Converting findhap files to plink ped/map files
```
perl aipl2plink.pl findhap-geno-folder ped-filename-prefix
```
There must be three files in the findhap folder: pedigree.file, genotypes.imputed, and chromosome.data.
### Converting plink ped/map files to bed/fam/bim files
```
plink --chr-set 20 --file ped-filename-prefix --make-bed --out bed-filename-prefix
```

---

## Inbreeding coefficients
```
plink --het --maf 0.01 --hwe 1e-6 midp --bfile bed-filename-prefix --out ibc-filename
```
The above command generates a .het file. Delete the first column and convert it to a CSV file. The CSV file will be used by MMAP as a covariate file in variance component estimation.
```
--covariate_filename ibc-csv --covariates F
```

---

## Generating text GRM files
### BFMAP executable
/home/share/jjiang26/bfmap

### Creating a SNP info file for BFMAP and filter SNPs by removing SNPs that have call rate less than 0.95
```
perl make_snp_info.pl bim-filename snp-info-filename
Rscript --vanilla SNP_filtering.R <snp-info-filename> <snp_call_rate.txt filename> <output filename with filtered SNPs>
```
Make sure R packages "dplyr" is loaded before run

### BFMAP GRMs
```
bfmap --compute_grm 1 --min_maf 0.01 --min_hwe_pval 1e-6 --hwe_midp --binary_genotype_file bed-filename-prefix --snp_info_file snp-info-filename --output_file grm-filename-prefix --num_threads 20
```
Three text GRM files (additive, dominance, and second-order interaction [A-by-A]) will be generated.

### Creating GRMs for additive by additive (AA), additive by dominance (AD), and  dominance by dominance (DD) based on existed additive and dominance GRMs.
```
Rscript --vanilla Interaction_matrix.R <add.grm.txt input file> <dom.grm.txt input file> <AA.grm.txt output file>  <AD.grm.txt output file>  <DD.grm.txt output file>
```
Before run the above command, make sure R packages "fastmatrix" and "data.table" are properly installed. 
Three text GRM files (additive by additive [AA], additive by dominance [AD], and  dominance by dominance [DD]) will be genrated.

---

## Converting text GRM files to MMAP binary GRM files
```
mmap --square_matrix_txt2mmap --txt_input_filename text-grm-filename --binary_output_filename mmap-grm-filename
```
Use the above command to convert each text GRM file to MMAP binary.

---

## Covariance matrices for sow effects
### Extracting offspring-sow pairs from genotyped animals
```
perl make_sow_file.pl plink-fam-filename findhap-pedigree-filename output-filename-prefix
```
Two files will be generated, .pairs and .sows.
The .sows file will be used in the command below. 
The .pairs file will be used by make_sow_mats.R.
### Extracting focal sows' genotypes
```
plink --bfile all-animals-bed-filename-prefix --keep sows-filename --make-bed --out sows-plink-prefix
```
### BFMAP GRMs for focal sows only
```
bfmap --compute_grm 1 --binary_genotype_file sows-plink-prefix --snp_info_file snp-info-filename --output_file sows-grm-prefix --num_threads 20
```
### Constructing covariance matrices for sow effects
1. Check and run make_sow_mats.R to create four covariance matrices for sow effects. Note that filenames need to be modified in make_sow_mats.R.
2. Convert text files of covariance matrix to MMAP binary files, similar to conversion for GRMs.

---

## Covariance matrices for litter effects
### Extracting litter info from pedigree
```
perl make_litter_file.pl plink-fam-filename findhap-pedigree-filename output-filename
```
The plink fam file is of all genotyped animals.

The output file will be used by make_litter_mats.R, e.g., yorkshire.litters.
### Constructing covariance matrices for litter effects
1. Check and run make_litter_mats.R to create four covariance matrices for litter effects. Note that filenames need to be modified in make_litter_mats.R.
2. Convert text files of covariance matrix to MMAP binary files, similar to conversion for GRMs.

---

## Variance component estimation
Below are two example MMAP commands. Note that all covariance matrices (including GRMs) need to be constructed only once. Refer to [the MMAP manual](https://mmap.github.io/) to create a pedigree file (--ped) and phenotype files (--phenotype_filename).

### Filter phenotypes by removing animals that have call rate less than 0.95
```
Rscript --vanilla Animal_filtering.R <phenotype-filename> <ind_call_rate.txt filename> <output phenotype filename with filtered animals>
```
Make sure R packages "dplyr" is loaded before run
  
### All variance components
```
mmap --ped yorkshire.ped.csv --phenotype_filename ../pheno/yorkshire.birth_weight.iid.csv --trait yd --estimate_variance_components --variance_component_filename yorkshire.add.grm.bin yorkshire.foi.grm.bin yorkshire.dom.grm.bin yorkshire.sows.i.bin yorkshire.sows.a.bin yorkshire.sows.d.bin yorkshire.sows.f.bin yorkshire.litters.i.bin --variance_component_label A F D SI SA SD SF LI --file_suffix yorkshire.birth_weight --num_mkl_threads 20 --num_em_reml_burnin 2 --use_em_ai_reml --single_pedigree --use_dpotrs --num_iterations 20
```
### Individual A + Maternal I/A + Litter I
```
mmap --ped yorkshire.ped.csv --phenotype_filename ../pheno/yorkshire.birth_weight.iid.csv --trait yd --estimate_variance_components --variance_component_filename yorkshire.add.grm.bin yorkshire.sows.i.bin yorkshire.sows.a.bin yorkshire.litters.i.bin --variance_component_label A SI SA LI --file_suffix yorkshire.birth_weight.r1 --num_mkl_threads 20 --num_em_reml_burnin 2 --use_em_ai_reml --single_pedigree --use_dpotrs --num_iterations 20
```
### Genomic prediction (10-fold cross-validation)
To run the following script, make sure all folder path and file names are adjusted accordingly, and split all data evenly into 10 folds before run.

## For the model that includes only additive genetic effect
Predicting gebv using training data
```
./SPG_BF_mmap_CV_add.sh
```
Compute total genetic value and correlate with adjusted phenotypes from the validation animals
```
Rscript Pred_BF_add.R
```

## For the model that includes all genetic effect and permnentant environmental effect
Predicting gebv using training data
```
./SPG_BF_mmap_CV_full.sh
```
Compute total genetic value and correlate with adjusted phenotypes from the validation animals
```
Rscript Pred_BF_full.R
```

---

## Todo
### GRM for the X chromosome and dosage compensation
https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3014363/

