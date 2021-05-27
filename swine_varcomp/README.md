# Converting findhap files to plink binary files
## Converting findhap files to plink ped/map files
```
perl aipl2plink *findhap-geno-folder* plink-filename-prefix
```
## Converting plink ped/map files to bed/fam/bim files
```
plink --chr-set 20 --file ped-filename-prefix --make-bed --out bed-filename-prefix
```

# Building text GRMs
## Creating a SNP info file for BFMAP
```
perl make_snp_info.pl bim-filename snp-info-filename
```
## BFMAP GRMs
```
bfmap --compute_grm 1 --binary_genotype_file plink-filename-prefix --snp_info_file snp-info-filename --output_file grm-filename-prefix --num_threads 20
```

# MMAP matrices
mmap --square_matrix_txt2mmap --txt_input_filename ../sow/yorkshire.sows.f.txt --binary_output_filename yorkshire.sows.f.bin

# VarComp
## All variance components
mmap --ped yorkshire.ped.csv --phenotype_filename ../pheno/yorkshire.birth_weight.iid.csv --trait yd --estimate_variance_components --variance_component_filename yorkshire.add.grm.bin yorkshire.foi.grm.bin yorkshire.dom.grm.bin yorkshire.sows.i.bin yorkshire.sows.a.bin yorkshire.sows.d.bin yorkshire.sows.f.bin yorkshire.litters.i.bin --variance_component_label A F D SI SA SD SF LI --file_suffix yorkshire.birth_weight --num_mkl_threads 20 --num_em_reml_burnin 2 --use_em_ai_reml --single_pedigree --use_dpotrs
## Individual A + Maternal I/A + Litter I
mmap --ped yorkshire.ped.csv --phenotype_filename ../pheno/yorkshire.birth_weight.iid.csv --trait yd --estimate_variance_components --variance_component_filename yorkshire.add.grm.bin yorkshire.sows.i.bin yorkshire.sows.a.bin yorkshire.litters.i.bin --variance_component_label A SI SA LI --file_suffix yorkshire.birth_weight.r1 --num_mkl_threads 20 --num_em_reml_burnin 2 --use_em_ai_reml --single_pedigree --use_dpotrs
