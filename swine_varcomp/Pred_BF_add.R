
library(dplyr)
library(data.table)

add<- fread("SPG_QC.add.grm.txt")

Acc<- data.frame(matrix(NA, nrow = 10, ncol = 1))

for (i in 1:10) {
  BF_temp<- read.table(paste("/home/wolftech/jcheng29/Non_additive/CV/BF_a/BF.SPG.BF_add.CV",i,".variance.components.model.csv", sep=""), header = T, sep=",")
  BF_temp_N<- read.table(paste("/home/wolftech/jcheng29/Non_additive/CV/SPG_BF_N",i,".csv", sep=""), header = F)
  
  BF_temp<- BF_temp[order(BF_temp$EGO),]
  BF_temp_N<- BF_temp_N[order(BF_temp_N$V1),]
  
  # Additive effect
  add_temp_T<- add[add$V1 %in% BF_temp$EGO]
  add_temp_T<- add_temp_T[order(add_temp_T$V1),]
  add_temp_T2<- select_if(add_temp_T, colnames(add_temp_T) %in% BF_temp$EGO)
  add_temp_T2<- add_temp_T2 %>% select(sort(names(add_temp_T2)))
  A_txt<- as.matrix(add_temp_T2)
  
  add_temp_N<- add[add$V1 %in% BF_temp_N]
  add_temp_N<- add_temp_N[order(add_temp_N$V1),]
  add_temp_N2<- select_if(add_temp_N, colnames(add_temp_N) %in% BF_temp$EGO)
  add_temp_N2<- add_temp_N2 %>% select(sort(names(add_temp_N2)))
  A_nxt<- as.matrix(add_temp_N2)
  
  
  a_t<- as.vector(BF_temp$BF_A)
  a<- A_nxt %*% solve(A_txt) %*% a_t
  
  #write.table(a, file=paste("~/BF",i,"_a.csv", sep=""), quote = F, col.names = F, row.names = F)
  
  p<- a 
  p<- cbind(add_temp_N$V1, p)
  p<- as.data.frame(p)
  names(p)<- c("ID","PEBV")
  
 # write.table(p, file=paste("/home/wolftech/jcheng29/Non_additive/CV/BF_a/BF",i,"_p.csv", sep=""), quote = F, col.names = F, row.names = F)
  
  # get phenotype
  y<- read.table("SPG_QC_BF_sln.csv", header = T, sep = ",")
  BF_temp_N<- as.data.frame(BF_temp_N)
  names(BF_temp_N)<- "ID"
  y_temp<- merge(BF_temp_N, y, by="ID")
  
  # adjust by F
  BF_Adj<- read.table("/home/wolftech/jcheng29/Non_additive/CV/BF_a/BF.SPG.BF_add.CV.Adj.variance.components.model.csv", header = T, sep=",")
  BF_Adj<- as.data.frame(BF_Adj)
  BF_Adj<- BF_Adj[,c("EGO","F_FIT","BF_S")]
  names(BF_Adj)[1]<- "ID"
  y_temp<- merge(y_temp, BF_Adj, by="ID")
  y_temp$BF_Adj<- y_temp$BF - y_temp$F_FIT - y_temp$BF_S
  
  y_temp<- merge(y_temp, p, by="ID")
  write.table(y_temp, file=paste("/home/wolftech/jcheng29/Non_additive/CV/BF_a/BF",i,"_y.csv", sep=""), quote = F, col.names = F, row.names = F, sep=",")
  
  
  corr<- cor(y_temp$PEBV, y_temp$BF_Adj, use="p")
  print(corr)
  
  Acc[i,1]<- corr
  
}

write.table(Acc, file="/home/wolftech/jcheng29/Non_additive/CV/BF_a/BF_Acc.csv", quote = F, col.names = F, row.names = F, sep=",")








