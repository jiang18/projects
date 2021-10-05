link = read.table("pedigree.file",head=F)
link<- link[,c(2,4)]
names(link)<- c("ID","Sow")
ind<- read.table("SPG_QC.grm.indi", header = F)
names(ind)<- "ID"
ind$order<- c(1:nrow(ind))
link<- merge(ind, link, by="ID")
link<- link[order(link$order),]


lt.factor = factor(link$Sow)
M = table(link$order, lt.factor)

lt.imat = as.data.frame(M %*% t(M))
write.table(lt.imat, file="SPG.sow.i.txt", quote = FALSE, sep = " ",row.names = link$ID,col.names = link$ID)
#fwrite(lt.imat, file="SPG.sow.i.txt", quote = FALSE, sep = " ",row.names = TRUE,col.names = TRUE)
