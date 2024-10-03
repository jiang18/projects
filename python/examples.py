from pandas_plink import read_plink1_bin
import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression, RidgeCV, LassoCV

G = read_plink1_bin("/mnt/jjiang26/sashoaf/genotype/spg.bed", "/mnt/jjiang26/sashoaf/genotype/spg.bim", "/mnt/jjiang26/sashoaf/genotype/spg.fam", verbose=False)
geno = G.values
phenotype_df = pd.read_csv("/mnt/jjiang26/sashoaf/phenotype/pheno_NBD.csv")
phenotype_df.head()


# Check if all phenotyped individuals all have genotypes
geno_ids = G.iid.values.astype(np.int64)
phen_ids = phenotype_df.ID
np.isin(phen_ids, geno_ids).sum() == len(phen_ids)

# Number of individuals with both genotypes and phenotypes
sample_size = np.isin(phen_ids, geno_ids).sum()

# Matching all individuals' genotypes and phenotypes
X = np.zeros((sample_size, geno.shape[1]))
y = phenotype_df.NBD

# Matching indeces
def find_indices_unsorted(array1, array2):
    mask = np.isin(array2, array1)
    return np.where(mask)[0]

# Find indices of individuals in genotypes kept for analysis
kept_geno_indices = find_indices_unsorted(phen_ids, geno_ids)

for i in range(sample_size):
    X[i,] = geno[kept_geno_indices[i], ]

# Training and validation
# First 3000 as training and others as validation

X_training = X[:3000, ]
X_validation = X[3000:, ]
y_training = y[:3000]
y_validation = y[3000:]

every = 1000

# Linear regression
reg = LinearRegression().fit(X_training[:, ::every], y_training)
reg.score(X_training[:, ::every], y_training)
# prediction accuracy
np.corrcoef(reg.predict(X_validation[:, ::every]), y_validation)[0, 1]

# Ridge regression
clf = RidgeCV(alphas=[1e-3, 1e-2, 1e-1, 1, 10], cv=5).fit(X_training, y_training)
clf.score(X_training, y_training)
# prediction accuracy
np.corrcoef(clf.predict(X_validation), y_validation)[0, 1]
