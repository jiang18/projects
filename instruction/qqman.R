library(qqman)

# Read MMAP GWAS output
# read.csv() or read.table(,sep=",",head=T)
gwas = read.csv("*.norm.add.mle.pval.slim.csv")
manhattan(gwas, chr = "CHR", bp = "POS", p = "SNP_TSCORE_PVAL", snp = "SNPNAME", genomewideline = -log10(0.05/nrow(gwas)))

# One can alternatively modify colnames.
colnames(gwas)[c(1,4,15)] = c("SNP","BP","P")
manhattan(gwas, genomewideline = -log10(0.05/nrow(gwas)))

# If not interactive, save the plot in a PDF file
pdf(filename)
manhattan(gwas, genomewideline = -log10(0.05/nrow(gwas)))
dev.off()
