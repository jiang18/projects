#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[3] = "out.txt"
}

# for filter function
library(dplyr, lib.loc="~/Rlibs")

Ind<- read.table(args[1], header = T, sep=",")
QC<- read.table(args[2], header = T, sep="\t")
names(QC)[1]<- "ID"
Ind<- merge(Ind, QC, by="ID")
Ind<- filter(Ind, callrate >= 0.95)
Ind<- Ind[order(Ind$ID),]
write.table(Ind[,c(1:2)], file=args[3], quote = F, col.names = T, row.names = F, sep=",")
