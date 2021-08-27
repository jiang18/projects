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

snp<- read.table(args[1], header = T, sep=",")
QC<- read.table(args[2], header = T, sep="\t")
snp<- merge(snp, QC, by="SNP")
snp<- filter(snp, callrate >= 0.95)
snp<- snp[order(snp$CHR),]
write.table(snp[,c(1:2)], file=args[3], quote = F, col.names = T, row.names = F, sep=",")
