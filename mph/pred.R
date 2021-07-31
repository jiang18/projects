true = read.csv("pheno/hsq90.gv.sim.csv")

nn = 1
cor = matrix(nrow=nn, ncol=3)
for(i in 1:nn) {
  one = read.csv( paste("50k/hsq90", i, "one.mq.gv.csv", sep=".") )
  cor[i,1] = cor(true[45001:50000,i+101], one[45001:50000,2])
  sig = read.csv( paste("50k/hsq90", i, "sig.mq.gv.csv", sep=".") )
  cor[i,2] = cor(true[45001:50000,i+101], sig[45001:50000,2])
  sig = read.csv( paste("50k/hsq90", i, "top.mq.gv.csv", sep=".") )
  cor[i,3] = cor(true[45001:50000,i+101], sig[45001:50000,2])
}
t.test(cor[,1],cor[,2], paired=T)

################################
true = read.csv("hsq50.sim.csv")
nn = 10
cor = matrix(nrow=nn, ncol=3)
for(i in 1:nn) {
  one = read.csv( paste("hsq50", i, "one.mq.gv.csv", sep=".") )
  cor[i,1] = cor(true[9001:10000,i+101], one[9001:10000,2])
  xxx = read.csv( paste("hsq50", i, "loo.mq.gv.csv", sep=".") )
  cor[i,2] = cor(true[9001:10000,i+101], xxx[9001:10000,2])
  xxx = read.csv( paste("hsq50", i, "top.mq.gv.csv", sep=".") )
  cor[i,3] = cor(true[9001:10000,i+101], xxx[9001:10000,2])
}
t.test(cor[,1],cor[,3], paired=T)

i = 1
xxx = read.csv( paste("hsq50", i, "sig.mq.gv.csv", sep=".") )
cor(true[9001:10000,i+101], xxx[9001:10000,2])
