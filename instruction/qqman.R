library(qqman)

# Read MMAP GWAS output
# read.csv() or read.table()
gwas = read.csv("*.norm.add.mle.pval.slim.csv")
manhattan(gwas, chr = "CHR", bp = "POS", p = "SNP_TSCORE_PVAL", snp = "SNPNAME", col = c("red", "blue"))

# One can alternatively modify colnames.
colnames(gwas)[c(1,4,15)] = c("SNP","BP","P")
manhattan(gwas)
