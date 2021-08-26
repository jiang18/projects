*Updated August 26, 2021*

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

### Creating a SNP info file for BFMAP
```
perl make_snp_info.pl bim-filename snp-info-filename
```
***TO BE UPDATED to use only good SNPs passing call rate threshold.***
### BFMAP GRMs
```
bfmap --compute_grm 1 --min_maf 0.01 --min_hwe_pval 1e-6 --hwe_midp --binary_genotype_file bed-filename-prefix --snp_info_file snp-info-filename --output_file grm-filename-prefix --num_threads 20
```
Three text GRM files (additive, dominance, and first-order iteraction [A-by-A]) will be genrated.

### Creating GRMs for additive by additive (AA), additive by dominance (AD), and  dominance by dominance (DD) based on existed additive and dominance grms.
```
R < Interaction_matrix.R --no-save
```
Before run the above command, make sure R packages "fastmatrix" and "data.table" are properly installed. Also, change the input (additive grm and dominance grm) and output file names accordingly.
Three text GRM files (additive by additive (AA), additive by dominance (AD), and  dominance by dominance (DD)) will be genrated.

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
### All variance components
```
mmap --ped yorkshire.ped.csv --phenotype_filename ../pheno/yorkshire.birth_weight.iid.csv --trait yd --estimate_variance_components --variance_component_filename yorkshire.add.grm.bin yorkshire.foi.grm.bin yorkshire.dom.grm.bin yorkshire.sows.i.bin yorkshire.sows.a.bin yorkshire.sows.d.bin yorkshire.sows.f.bin yorkshire.litters.i.bin --variance_component_label A F D SI SA SD SF LI --file_suffix yorkshire.birth_weight --num_mkl_threads 20 --num_em_reml_burnin 2 --use_em_ai_reml --single_pedigree --use_dpotrs --num_iterations 20
```
### Individual A + Maternal I/A + Litter I
```
mmap --ped yorkshire.ped.csv --phenotype_filename ../pheno/yorkshire.birth_weight.iid.csv --trait yd --estimate_variance_components --variance_component_filename yorkshire.add.grm.bin yorkshire.sows.i.bin yorkshire.sows.a.bin yorkshire.litters.i.bin --variance_component_label A SI SA LI --file_suffix yorkshire.birth_weight.r1 --num_mkl_threads 20 --num_em_reml_burnin 2 --use_em_ai_reml --single_pedigree --use_dpotrs --num_iterations 20
```

---

## Todo
### GRM for the X chromosome and dosage compensation
https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3014363/

