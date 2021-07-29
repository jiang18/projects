true = read.csv("hsq50.sim.csv")
nn = 10
cor = matrix(nrow=nn, ncol=3)
for(i in 1:nn) {
  one = read.csv( paste("hsq50", i, "one.mq.gv.csv", sep=".") )
  cor[i,1] = cor(true[9001:10000,i+101], one[9001:10000,2])
  main = read.csv( paste("hsq50", i, "main.mq.gv.csv", sep=".") )
  cor[i,2] = cor(true[9001:10000,i+101], main[9001:10000,2])
  main = read.csv( paste("hsq50", i, "sig.mq.gv.csv", sep=".") )
  cor[i,3] = cor(true[9001:10000,i+101], main[9001:10000,2])
}
t.test(cor[,1],cor[,3], paired=T)

d = read.csv( paste("hsq50", i, "loo.mq.vc.csv", sep=".") )
d$vc[which(abs(d$var /d$seV) > 3)]

###############################

true = read.csv("pheno/hsq90.gv.sim.csv")

nn = 10
cor = matrix(nrow=nn, ncol=2)
for(i in 1:nn) {
  one = read.csv( paste("50k/hsq90", i, "one.mq.gv.csv", sep=".") )
  cor[i,1] = cor(true[45001:50000,i+101], one[45001:50000,2])
  sig = read.csv( paste("50k/hsq90", i, "sig.mq.gv.csv", sep=".") )
  cor[i,2] = cor(true[45001:50000,i+101], sig[45001:50000,2])
}
t.test(cor[,1],cor[,2], paired=T)
