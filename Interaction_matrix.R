
#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[3,4,5] = "out.txt"
}


#install.packages('fastmatrix','~/Rlibs', 'https://mirror.las.iastate.edu/CRAN/src/contrib/fastmatrix_0.3-819.tar.gz')
library(fastmatrix, lib.loc="/home/wolftech/jcheng29/Rlibs")

#install.packages('data.table','~/Rlibs','https://mirror.las.iastate.edu/CRAN/src/contrib/data.table_1.14.0.tar.gz')
 library(data.table, lib.loc="/home/wolftech/jcheng29/Rlibs")


# read add and dom grm and ID
add<- fread(args[1])
dom<- fread(args[2])
ID<- add$V1

# remove ID
rownames(add)<- add$V1
add<- add[,-1]

rownames(dom)<- dom$V1
dom<- dom[,-1]

# Get AXA, AXD, DXD
AAtop<- hadamard(add, add)
AA<- AAtop/(sum(diag(AAtop))/nrow(add))
rownames(AA)<- ID
colnames(AA)<- ID

write.table(AA, file=args[3], col.names=T, row.names=T, quote=F, sep=" ")


ADtop<- hadamard(add, dom)
AD<- ADtop/(sum(diag(ADtop))/nrow(add))
rownames(AD)<- ID
colnames(AD)<- ID

write.table(AD, file=args[4], col.names=T, row.names=T, quote=F, sep=" ")


DDtop<- hadamard(dom, dom)
DD<- DDtop/(sum(diag(DDtop))/nrow(dom))
rownames(DD)<- ID
colnames(DD)<- ID

write.table(DD, file=args[5], col.names=T, row.names=T, quote=F, sep=" ")