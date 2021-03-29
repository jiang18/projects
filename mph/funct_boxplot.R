true = read.table("sim_true.txt")
dt = read.table("50k.summary.txt",head=T)
names(dt) = true[,1]

boxplot(dt,las=2)
points(1:ncol(dt), colMeans(dt), col = "red", pch=1)
points(1:ncol(dt), true[,2], col = "blue", pch=2)
abline(h=1,col="blue")
dev.off()

