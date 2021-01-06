par(mfrow=c(2,1))

d = read.table("yd.yorkshire.BirthWeight.variance.components.T.csv",sep=",")
idx = seq(13,45,by=4)
lbls = c("A","F","D","MI","MA","MD","MF","Litter","E")
slices = as.numeric(d[idx,2])
pct = round(slices*100)
lbls = paste(lbls,pct)
lbls = paste(lbls,"%",sep="")
pie(slices, labels=lbls, main="Birth Weight")

d = read.table("yd.yorkshire.AverageDailyGain_Nursery.variance.components.T.csv",sep=",")
idx = seq(13,45,by=4)
lbls = c("A","F","D","MI","MA","MD","MF","Litter","E")
slices = as.numeric(d[idx,2])
pct = round(slices*100)
lbls = paste(lbls,pct)
lbls = paste(lbls,"%",sep="")
pie(slices, labels=lbls, main="Average Dairy Gain Nursery")

dev.off()

