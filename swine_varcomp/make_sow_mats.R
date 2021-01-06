sow.grm = read.table("yorkshire.sows.add.grm.txt", head=T, check.names=F)
link = read.table("yorkshire.sows",head=T)
sow.factor = factor(link$sow, levels = rownames(sow.grm))
M = table(link$id, sow.factor)

sow.imat = M %*% t(M)
write.table(sow.imat, file="yorkshire.sows.i.txt", quote = FALSE, sep = " ",row.names = TRUE,col.names = TRUE)

sow.amat = M %*% as.matrix(sow.grm) %*% t(M)
write.table(sow.amat, file="yorkshire.sows.a.txt", quote = FALSE, sep = " ",row.names = TRUE,col.names = TRUE)

################################################################################
sow.grm = read.table("yorkshire.sows.dom.grm.txt", head=T, check.names=F)
link = read.table("yorkshire.sows",head=T)
sow.factor = factor(link$sow, levels = rownames(sow.grm))
M = table(link$id, sow.factor)

sow.dmat = M %*% as.matrix(sow.grm) %*% t(M)
write.table(sow.dmat, file="yorkshire.sows.d.txt", quote = FALSE, sep = " ",row.names = TRUE,col.names = TRUE)

sow.grm = read.table("yorkshire.sows.foi.grm.txt", head=T, check.names=F)
sow.fmat = M %*% as.matrix(sow.grm) %*% t(M)
write.table(sow.fmat, file="yorkshire.sows.f.txt", quote = FALSE, sep = " ",row.names = TRUE,col.names = TRUE)

