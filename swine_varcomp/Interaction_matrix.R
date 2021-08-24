install.packages('fastmatrix','~/Rlibs', 'https://mirror.las.iastate.edu/CRAN/src/contrib/fastmatrix_0.3-819.tar.gz')
library(fastmatrix, lib.loc="/home/wolftech/jcheng29/Rlibs")

install.packages('data.table','~/Rlibs','https://mirror.las.iastate.edu/CRAN/src/contrib/data.table_1.14.0.tar.gz')
 library(data.table, lib.loc="/home/wolftech/jcheng29/Rlibs")

# read add and dom grm and ID
add<- fread("SPG.add.grm.txt")
dom<- fread("SPG.dom.grm.txt")
ID<- add$V1

# remove ID
rownames(add)<- add$V1
add<- add[,-1]

rownames(dom)<- dom$V1
dom<- dom[,-1]

# Get AXA, AXD, DXD
# AAtop<- hadamard(add, add)
# AA<- AAtop/(sum(diag(AAtop))/nrow(add))
# rownames(AA)<- ID
# colnames(AA)<- ID
# 
# write.table(AA, file="SPG.AA.grm.txt", col.names=T, row.names=T, quote=F, sep=" ")


ADtop<- hadamard(add, dom)
AD<- ADtop/(sum(diag(ADtop))/nrow(add))
rownames(AD)<- ID
colnames(AD)<- ID

write.table(AD, file="SPG.AD.grm.txt", col.names=T, row.names=T, quote=F, sep=" ")


DDtop<- hadamard(dom, dom)
DD<- DDtop/(sum(diag(DDtop))/nrow(dom))
rownames(DD)<- ID
colnames(DD)<- ID

write.table(DD, file="SPG.DD.grm.txt", col.names=T, row.names=T, quote=F, sep=" ")