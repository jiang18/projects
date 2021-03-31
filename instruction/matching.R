ped = data.frame(numeric=c(1001, 1002, 1003), character=c("ASD", "FGH", "JKL") )
gen = c("JKL", "ASD")

# use hash to create character-numeric matching
library(hash)
h = hash(ped$character, ped$numeric)

# get numeric IDs given a list of character IDs and the hash
values(h, keys=gen)


