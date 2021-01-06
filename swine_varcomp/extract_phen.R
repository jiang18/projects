load("../phenYorkshire.RData")

write.csv(phen$Summary, file="yorkshire.summary.csv", quote=F, row.names=F)

for(t in phen$Summary$trait)
{
	write.csv(phen[[t]],file=paste("yorkshire",t,"csv",sep="."), quote=F, row.names=F)
}

