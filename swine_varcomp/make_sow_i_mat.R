link = read.table("pedigree.file",head=F)
link<- link[,c(2,4)]
names(link)<- c("ID","Sow")
ind<- read.table("SPG_ped.fam", header = F)
ind<- as.data.frame(ind[,c(2)])
names(ind)<- "ID"
link<- merge(ind, link, by="ID")

lt.factor = factor(link$Sow)
M = table(link$ID, lt.factor)

lt.imat = as.data.frame(M %*% t(M))
write.table(lt.imat, file="SPG.sow.i.txt", quote = FALSE, sep = " ",row.names = TRUE,col.names = TRUE)
#fwrite(lt.imat, file="SPG.sow.i.txt", quote = FALSE, sep = " ",row.names = TRUE,col.names = TRUE)
