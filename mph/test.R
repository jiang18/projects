library(data.table)
sw = fread("../funct.snp_info.csv", head=T, sep=",")

rname = sw$snp
sw = sw[,-1]
sw[is.na(sw)] = 0
sw = as.matrix(sw)

main = which( !(grepl("500", colnames(sw)) | grepl("peak", colnames(sw))) )
sw = sw[,main]

rownames(sw) = rname

sw = sw[,-23]
# MPH output
mq = read.csv("../10k/hsq50.2.loo.mq.vc.csv")
mq = mq[-nrow(mq),]

snpvar = sw %*% mq$enrichment * (nrow(sw)/sum(mq$m))
snpvar = snpvar[snpvar>0,]
write.csv(snpvar, file="snpvar.txt",row.names=T, quote=F)

######################################################

# heritability estimate
lhs = t(sw) %*% sw
var = lhs %*% as.matrix(mq[,9:ncol(mq)]) %*% t(lhs)
h.est = lhs %*% mq$enrichment / sum(mq$m)
h.se = sqrt(diag(var)) / sum(mq$m) 

# enrichment estimate
e.est = h.est / (mq$m/mq$m[1])
e.se = h.se / (mq$m/mq$m[1])

hh = cbind(h.est, h.se, e.est, e.se)
hh[order(hh[,3]),]

##############
# 50K
##############
sw = fread("../funct.snp_info.csv", head=T, sep=",")

rname = sw$snp
sw = sw[,-1]
sw[is.na(sw)] = 0
sw = as.matrix(sw)

main = which( !(grepl("500", colnames(sw)) | grepl("peak", colnames(sw))) )
sw = sw[,main]

rownames(sw) = rname

# MPH output
mq = read.csv("../50k/hsq90.2.200.1.mq.csv")
mq = mq[-nrow(mq),]

snpvar = sw %*% mq$enrichment * (nrow(sw)/sum(mq$m))

