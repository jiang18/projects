## Converting findhap files to plink binary files
### Converting findhap files to plink ped/map files
```
perl aipl2plink findhap-geno-folder ped-filename-prefix
```
### Converting plink ped/map files to bed/fam/bim files
```
plink --chr-set 20 --file ped-filename-prefix --make-bed --out bed-filename-prefix
```

## Generating text GRM files
### Creating a SNP info file for BFMAP
```
perl make_snp_info.pl bim-filename snp-info-filename
```
### BFMAP GRMs
```
bfmap --compute_grm 1 --binary_genotype_file bed-filename-prefix --snp_info_file snp-info-filename --output_file grm-filename-prefix --num_threads 20
```
Three GRMs (additive, dominance, and first-order iteraction [A-by-A]) will be genrated.

## Convert text GRM files to MMAP binary GRM files
```
mmap --square_matrix_txt2mmap --txt_input_filename text-grm-filename --binary_output_filename mmap-grm-filename
```
Use the above command to convert each text GRM file to MMAP binary.

## Covariance matrices for sow effects
### Extracting offspring-sow pairs from genotyped animals
```
perl make_sow_file.pl plink-fam-filename findhap-pedigree-filename output-filename-prefix
```
Two files will be generated, .pairs and .sows.
The .sows file will be used in the command below. 
### Extracting focal sows' genotypes
```
plink --bfile all-animals-bed-filename-prefix --keep sows-filename --make-bed --out sows-plink-prefix
```
### BFMAP GRMs for focal sows only
```
bfmap --compute_grm 1 --binary_genotype_file sows-plink-prefix --snp_info_file snp-info-filename --output_file sows-grm-prefix --num_threads 20
```
### Constructing covariance matrices for sow effects
Run make_sow_mats.R to create four covariance matrices for sow effects. Note that filenames need to be modified in make_sow_mats.R.

## Covariance matrices for litter effects


## VarComp
### All variance components
mmap --ped yorkshire.ped.csv --phenotype_filename ../pheno/yorkshire.birth_weight.iid.csv --trait yd --estimate_variance_components --variance_component_filename yorkshire.add.grm.bin yorkshire.foi.grm.bin yorkshire.dom.grm.bin yorkshire.sows.i.bin yorkshire.sows.a.bin yorkshire.sows.d.bin yorkshire.sows.f.bin yorkshire.litters.i.bin --variance_component_label A F D SI SA SD SF LI --file_suffix yorkshire.birth_weight --num_mkl_threads 20 --num_em_reml_burnin 2 --use_em_ai_reml --single_pedigree --use_dpotrs
### Individual A + Maternal I/A + Litter I
mmap --ped yorkshire.ped.csv --phenotype_filename ../pheno/yorkshire.birth_weight.iid.csv --trait yd --estimate_variance_components --variance_component_filename yorkshire.add.grm.bin yorkshire.sows.i.bin yorkshire.sows.a.bin yorkshire.litters.i.bin --variance_component_label A SI SA LI --file_suffix yorkshire.birth_weight.r1 --num_mkl_threads 20 --num_em_reml_burnin 2 --use_em_ai_reml --single_pedigree --use_dpotrs
