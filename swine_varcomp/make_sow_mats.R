## construct incidence matrix
# read .pairs file
link = read.table("yorkshire.pairs",head=T)
# read a grm file
sow.grm = read.table("yorkshire.sows.add.grm.txt", head=T, check.names=F)
sow.factor = factor(link$sow, levels = rownames(sow.grm))
M = table(link$id, sow.factor)

## covariance matrix for sow independent effects
sow.imat = M %*% t(M)
write.table(sow.imat, file="yorkshire.sows.i.txt", quote = FALSE, sep = " ",row.names = TRUE,col.names = TRUE)

## covariance matrix for sow additive genetic effects
sow.amat = M %*% as.matrix(sow.grm) %*% t(M)
write.table(sow.amat, file="yorkshire.sows.a.txt", quote = FALSE, sep = " ",row.names = TRUE,col.names = TRUE)

## covariance matrix for sow dominance genetic effects 
sow.grm = read.table("yorkshire.sows.dom.grm.txt", head=T, check.names=F)
sow.dmat = M %*% as.matrix(sow.grm) %*% t(M)
write.table(sow.dmat, file="yorkshire.sows.d.txt", quote = FALSE, sep = " ",row.names = TRUE,col.names = TRUE)

## covariance matrix for sow A-by-A genetic effects
sow.grm = read.table("yorkshire.sows.foi.grm.txt", head=T, check.names=F)
sow.fmat = M %*% as.matrix(sow.grm) %*% t(M)
write.table(sow.fmat, file="yorkshire.sows.f.txt", quote = FALSE, sep = " ",row.names = TRUE,col.names = TRUE)

