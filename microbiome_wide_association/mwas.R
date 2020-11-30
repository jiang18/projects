period = "T1"
breed = "LW"
trait = "ADFI"

dat = read.csv(paste(period,".csv",sep=""))
dat = dat[which(dat$Breed.x == breed),]
# Order by ID
dat = dat[order(dat$ID),]

# Estimated microbiomic value for each individual
# from your previous model fitting
# m = read.table()

num_asv = ncol(dat) - 20
dat[,21:(num_asv+20)] = log(dat[,21:(num_asv+20)]/10000+0.001)
Z = dat[,21:(num_asv+20)]
asv_sd = apply(Z, MARGIN=2, FUN=sd)
Z = Z[,which(asv_sd > 0)]
Z = scale(Z)
M = Z %*% t(Z)
# Convert estimated microbiomic values to ASV effects
# asv_effect = Z %*% solve(M,m)

# Covariance matrix for microbiome is equal to ZZ'/#asv.
M = M / ncol(Z)

# Covariance matrix for pen
pen.factor = factor(dat$Pen)
pen = table(dat$ID, pen.factor)
P = pen %*% t(pen)

# Covariance matrix for sire
sire.factor = factor(dat$SireID)
sire = table(dat$ID, sire.factor)
# Suppose the numerator relationship matrix between sires is A
A = diag(ncol(sire))
S = sire %*% A %*% t(sire)

# Incidence matrix for room
room.factor = factor(dat$Room)
room = table(dat$ID, room.factor)

# Extract VC estimates for the period-breed-trait combo
vc = read.table("VC.txt",head=T)
this_vc = vc[which(vc$Trait == trait & vc$Breed == breed & vc$Period == period),]

# Complete covariance matrix
V = P*this_vc$mean_p + S*this_vc$mean_s + M*this_vc$mean_m + diag(nrow(dat))*this_vc$mean_e

# Generalized least squares
stat = matrix(NA,ncol=4,nrow=num_asv)
df = nrow(dat) - ncol(room) - 1
rownames(stat) = colnames(dat)[21:(20+num_asv)]
colnames(stat) = c("BETA","SE","T","P")

L_inv = solve(t(chol(V)))
y_adj = L_inv %*% dat[,which(colnames(dat)==trait)]
room_adj = L_inv %*% room
for(i in (21:(20+num_asv))) {
	if(asv_sd[i-20] == 0) {
		next
	}
	asv_adj = L_inv %*% dat[,i]
	X_adj = cbind(asv_adj, room_adj)
	XtX_adj = t(X_adj) %*% X_adj
	b_hat = solve(XtX_adj, (t(X_adj) %*% y_adj))
	b_hat_var = solve(XtX_adj)
	stat[i-20,1] = b_hat[1]
	stat[i-20,2] = sqrt(b_hat_var[1,1])
	stat[i-20,3] = stat[i-20,1]/stat[i-20,2]
	stat[i-20,4] = 2*pt(abs(stat[i-20,3]), df=df, lower.tail=F)
}
write.csv(stat,file=paste(period,breed,trait,"csv",sep="."), row.names=T,quote=F)
summary(stat)
head(stat[order(stat[,4]),])


# Verify the above GLS implementation
library(nlme)
y = dat[,which(colnames(dat)==trait)]
x = dat[,i]
D = diag(V)
R = diag(sqrt(1/D)) %*% V %*% diag(sqrt(1/D))
R = corSymm(R[lower.tri(R)], fixed = T)
weights = varFixed(~D)
fit = gls(y~x+room-1, correlation = R, weights = weights)
summary(fit)

fit = lm(y_adj~asv_adj+room_adj-1)
summary(fit)
# The above two summary results should have identical statistics (beta, SE, t-value, and p-value).
# Also, the ASV regression statistics should be similar to the last row in the output table.
