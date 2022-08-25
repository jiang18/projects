```console
plink --bfile ../../SPG/SPG_ped --maf 0.01 --hwe 1e-6 midp --chr 1-18 --make-bed --out post-qc

gcta64 --bfile post-qc --make-grm --make-grm-alg 1 --out gcta.add --threads 10

gcta64 --bfile post-qc --make-grm-d --make-grm-alg 1 --out gcta.dom --threads 10
```

## R script to compare GRM elements between GCTA and our program

### R script to read the GRM binary file
### Copied from https://cnsgenomics.com/software/gcta/#MakingaGRM
```R
ReadGRMBin=function(prefix, AllN=F, size=4){
  sum_i=function(i){
    return(sum(1:i))
  }
  BinFileName=paste(prefix,".grm.bin",sep="")
  NFileName=paste(prefix,".grm.N.bin",sep="")
  IDFileName=paste(prefix,".grm.id",sep="")
  id = read.table(IDFileName)
  n=dim(id)[1]
  BinFile=file(BinFileName, "rb");
  grm=readBin(BinFile, n=n*(n+1)/2, what=numeric(0), size=size)
  NFile=file(NFileName, "rb");
  if(AllN==T){
    N=readBin(NFile, n=n*(n+1)/2, what=numeric(0), size=size)
  }
  else N=readBin(NFile, n=1, what=numeric(0), size=size)
  closeAllConnections()
  i=sapply(1:n, sum_i)
  return(list(diag=grm[i], off=grm[-i], id=id, N=N))
}
##########################################################

# Additive
# GCTA GRM
bin = ReadGRMBin("gcta.add")
np = length(bin$diag)
G = matrix(0, nrow=np, ncol=np)
G[upper.tri(G)] = bin$off
diag(G) = bin$diag

# GRM by our program
library(data.table)
txtfile = "SPG_ped.add.grm.txt"
grm = as.matrix(fread(txtfile, head=F, check.names=F), rownames=1)

diff = G[upper.tri(G,diag=TRUE)] - grm[upper.tri(grm,diag=TRUE)]
summary(abs(diff))
# output:
# Min.   1st Qu.    Median      Mean   3rd Qu.      Max.
# 0.000e+00 6.242e-08 1.568e-07 1.963e-07 2.698e-07 1.574e-05

# Dominance
# GCTA GRM
bin = ReadGRMBin("gcta.dom.d")
np = length(bin$diag)
G = matrix(0, nrow=np, ncol=np)
G[upper.tri(G)] = bin$off
diag(G) = bin$diag

# GRM by our program
library(data.table)
txtfile = "SPG_ped.dom.grm.txt"
grm = as.matrix(fread(txtfile, head=F, check.names=F), rownames=1)

diff = G[upper.tri(G,diag=TRUE)] - grm[upper.tri(grm,diag=TRUE)]
summary(abs(diff))
# output:
# Min.   1st Qu.    Median      Mean   3rd Qu.      Max.
# 0.000e+00 1.079e-08 2.485e-08 4.070e-08 6.579e-08 7.794e-06

```
