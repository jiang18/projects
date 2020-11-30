dat = read.csv("T1.csv")
dat = dat[which(dat$Breed.x == "LW"),]
# Order by ID
dat = dat[order(dat$ID),]

# Estimated microbiomic value for each individual
# from your previous model fitting
# m = read.table()

num_asv = dim(dat)[2] - 20
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
# A = diag(dim(sire)[2])
S = sire %*% A %*% t(sire)

# Incidence matrix for room
room.factor = factor(dat$Room)
room = table(dat$ID, room.factor)

