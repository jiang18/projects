sim_true = read.table("sim_true.txt",sep="\t",quote="")
dt = read.table("50k.summary.txt",head=T)
names(dt) = sim_true[,1]

par(mar=c(2,8,1,1))
boxplot(dt, horizontal=TRUE, las=1)
points(colMeans(dt), 1:ncol(dt), col = "red", pch=1)
points(sim_true[,2], 1:ncol(dt), col = "blue", pch=3)
abline(v=1,col="blue")
legend("topright", legend=c("Estimate mean", "True value"), col=c("red", "blue"), pch=c(1,3))
