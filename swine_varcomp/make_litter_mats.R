link = read.table("yorkshire.litters",head=T)
lt.factor = factor(link$litter)
M = table(link$id, lt.factor)

lt.imat = M %*% t(M)
write.table(lt.imat, file="yorkshire.litters.i.txt", quote = FALSE, sep = " ",row.names = TRUE,col.names = TRUE)
