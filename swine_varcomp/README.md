# MMAP matrices
mmap --square_matrix_txt2mmap --txt_input_filename ../sow/yorkshire.sows.f.txt --binary_output_filename yorkshire.sows.f.bin

# VarComp
## All variance components
mmap --ped yorkshire.ped.csv --phenotype_filename ../pheno/yorkshire.birth_weight.iid.csv --trait yd --estimate_variance_components --variance_component_filename yorkshire.add.grm.bin yorkshire.foi.grm.bin yorkshire.dom.grm.bin yorkshire.sows.i.bin yorkshire.sows.a.bin yorkshire.sows.d.bin yorkshire.sows.f.bin yorkshire.litters.i.bin --variance_component_label A F D SI SA SD SF LI --file_suffix yorkshire.birth_weight --num_mkl_threads 20 --num_em_reml_burnin 2 --use_em_ai_reml --single_pedigree --use_dpotrs
## Individual A + Maternal I/A + Litter I
mmap --ped yorkshire.ped.csv --phenotype_filename ../pheno/yorkshire.birth_weight.iid.csv --trait yd --estimate_variance_components --variance_component_filename yorkshire.add.grm.bin yorkshire.sows.i.bin yorkshire.sows.a.bin yorkshire.litters.i.bin --variance_component_label A SI SA LI --file_suffix yorkshire.birth_weight.r1 --num_mkl_threads 20 --num_em_reml_burnin 2 --use_em_ai_reml --single_pedigree --use_dpotrs
