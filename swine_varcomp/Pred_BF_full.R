

library(dplyr)
library(data.table)

add<- fread("SPG_QC.add.grm.txt")
foi<- fread("SPG_QC.AA.grm.txt")
dom<- fread("SPG_QC.dom.grm.txt")
ad<- fread("SPG_QC.AD.grm.txt")
dd<- fread("SPG_QC.DD.grm.txt")

Acc<- data.frame(matrix(NA, nrow = 10, ncol = 2))

for (i in 1:10) {
  BF_temp<- read.table(paste("/home/wolftech/jcheng29/Non_additive/CV/BF_f/BF.SPG.BF_full.CV",i,".variance.components.model.csv", sep=""), header = T, sep=",")
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
  
  # AA effect
  foi_temp_T<- foi[foi$V1 %in% BF_temp$EGO]
  foi_temp_T<- foi_temp_T[order(foi_temp_T$V1),]
  foi_temp_T2<- select_if(foi_temp_T, colnames(foi_temp_T) %in% BF_temp$EGO)
  foi_temp_T2<- foi_temp_T2 %>% select(sort(names(foi_temp_T2)))
  F_txt<- as.matrix(foi_temp_T2)
  
  foi_temp_N<- foi[foi$V1 %in% BF_temp_N]
  foi_temp_N<- foi_temp_N[order(foi_temp_N$V1),]
  foi_temp_N2<- select_if(foi_temp_N, colnames(foi_temp_N) %in% BF_temp$EGO)
  foi_temp_N2<- foi_temp_N2 %>% select(sort(names(foi_temp_N2)))
  F_nxt<- as.matrix(foi_temp_N2)
  
  
  f_t<- as.vector(BF_temp$BF_AA)
  f<- F_nxt %*% solve(F_txt) %*%f_t
  
  # AD effect
  ad_temp_T<- ad[ad$V1 %in% BF_temp$EGO]
  ad_temp_T<- ad_temp_T[order(ad_temp_T$V1),]
  ad_temp_T2<- select_if(ad_temp_T, colnames(ad_temp_T) %in% BF_temp$EGO)
  ad_temp_T2<- ad_temp_T2 %>% select(sort(names(ad_temp_T2)))
  AD_txt<- as.matrix(ad_temp_T2)
  
  ad_temp_N<- ad[ad$V1 %in% BF_temp_N]
  ad_temp_N<- ad_temp_N[order(ad_temp_N$V1),]
  ad_temp_N2<- select_if(ad_temp_N, colnames(ad_temp_N) %in% BF_temp$EGO)
  ad_temp_N2<- ad_temp_N2 %>% select(sort(names(ad_temp_N2)))
  AD_nxt<- as.matrix(ad_temp_N2)
  
  
  ad_t<- as.vector(BF_temp$BF_AD)
  axd<- AD_nxt %*% solve(AD_txt) %*%ad_t
  
  # DD effect
  dd_temp_T<- dd[dd$V1 %in% BF_temp$EGO]
  dd_temp_T<- dd_temp_T[order(dd_temp_T$V1),]
  dd_temp_T2<- select_if(dd_temp_T, colnames(dd_temp_T) %in% BF_temp$EGO)
  dd_temp_T2<- dd_temp_T2 %>% select(sort(names(dd_temp_T2)))
  DD_txt<- as.matrix(dd_temp_T2)
  
  dd_temp_N<- dd[dd$V1 %in% BF_temp_N]
  dd_temp_N<- dd_temp_N[order(dd_temp_N$V1),]
  dd_temp_N2<- select_if(dd_temp_N, colnames(dd_temp_N) %in% BF_temp$EGO)
  dd_temp_N2<- dd_temp_N2 %>% select(sort(names(dd_temp_N2)))
  DD_nxt<- as.matrix(dd_temp_N2)
  
  
  dd_t<- as.vector(BF_temp$BF_DD)
  dxd<- DD_nxt %*% solve(DD_txt) %*%dd_t
  
  # Dominance effect
  dom_temp_T<- dom[dom$V1 %in% BF_temp$EGO]
  dom_temp_T<- dom_temp_T[order(dom_temp_T$V1),]
  dom_temp_T2<- select_if(dom_temp_T, colnames(dom_temp_T) %in% BF_temp$EGO)
  dom_temp_T2<- dom_temp_T2 %>% select(sort(names(dom_temp_T2)))
  D_txt<- as.matrix(dom_temp_T2)
  
  dom_temp_N<- dom[dom$V1 %in% BF_temp_N]
  dom_temp_N<- dom_temp_N[order(dom_temp_N$V1),]
  dom_temp_N2<- select_if(dom_temp_N, colnames(dom_temp_N) %in% BF_temp$EGO)
  dom_temp_N2<- dom_temp_N2 %>% select(sort(names(dom_temp_N2)))
  D_nxt<- as.matrix(dom_temp_N2)
  
  
  d_t<- as.vector(BF_temp$BF_D)
  d<- D_nxt %*% solve(D_txt) %*% d_t
  
  p<- a + d + f  + axd + dxd
  
  p<- cbind(add_temp_N$V1, p, a)
  p<- as.data.frame(p)
  names(p)<- c("ID","PEBV","AEBV")
  
 # write.table(p, file=paste("/home/wolftech/jcheng29/Non-additive/CV/model_f/BF",i,"_p.csv", sep=""), quote = F, col.names = F, row.names = F)
  
  # get phenotype
  y<- read.table("SPG_QC_BF_sln.csv", header = T, sep = ",")
  BF_temp_N<- as.data.frame(BF_temp_N)
  names(BF_temp_N)<- "ID"
  y_temp<- merge(BF_temp_N, y, by="ID")
  
  # adjust by F
  BF_Adj<- read.table("/home/wolftech/jcheng29/Non_additive/CV/BF_f/BF.SPG.BF_full.CV.Adj.variance.components.model.csv", header = T, sep=",")
  BF_Adj<- as.data.frame(BF_Adj)
  BF_Adj<- BF_Adj[,c("EGO","F_FIT","BF_S")]
  names(BF_Adj)<- c("ID","F","S")
  y_temp<- merge(y_temp, BF_Adj, by="ID")
  y_temp$BF_Adj<- y_temp$BF - y_temp$F -y_temp$S

  
  y_temp<- merge(y_temp, p, by="ID")
  
  # write.table(y_temp, file=paste("/home/wolftech/jcheng29/Non_additive/CV/BF_f/BF",i,"_y.csv", sep=""), quote = F, col.names = F, row.names = F, sep=",")
  # 
  corr<- cor(y_temp$PEBV, y_temp$BF_Adj, use="p")
  corr2<- cor(y_temp$AEBV, y_temp$BF_Adj, use="p")
  print(corr)
  print(corr2)
  
  Acc[i,1]<- corr
  Acc[i,2]<- corr2
  
}


write.table(Acc, file="/home/wolftech/jcheng29/Non_additive/CV/BF_f/BF_Acc_epi.csv", quote = F, col.names = F, row.names = F, sep=",")












