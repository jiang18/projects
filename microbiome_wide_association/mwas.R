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
Z = scale(dat[,21:(num_asv+20)])
M = Z %*% t(Z)
# Convert estimated microbiomic values to ASV effects
# asv_effect = Z %*% solve(M,m)

# Covariance matrix for microbiome is equal to ZZ'/#asv.
M = M / num_asv

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


