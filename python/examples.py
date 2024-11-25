from pandas_plink import read_plink1_bin
import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression, RidgeCV, LassoCV
from sklearn.model_selection import train_test_split

trait = "BF"
G = read_plink1_bin("/mnt/jjiang26/sashoaf/genotype/spg.bed", "/mnt/jjiang26/sashoaf/genotype/spg.bim", "/mnt/jjiang26/sashoaf/genotype/spg.fam", verbose=False)
geno = G.values
phenotype_df = pd.read_csv(f"/mnt/jjiang26/sashoaf/phenotype/pheno_{trait}.csv")
phenotype_df.head()

# Check if all phenotyped individuals all have genotypes
geno_ids = G.iid.values.astype(np.int64)
phen_ids = phenotype_df.ID

def get_matching_indices(array1, array2):
    common_ids = list(set(array1) & set(array2))
    idx1 = [np.where(array1 == id)[0][0] for id in common_ids]
    idx2 = [np.where(array2 == id)[0][0] for id in common_ids]
    return common_ids, idx1, idx2

common_ids, geno_idx, phen_idx  = get_matching_indices(geno_ids, phen_ids)

# Number of individuals with both genotypes and phenotypes
sample_size = len(common_ids)

# Matching all individuals' genotypes and phenotypes
X = np.zeros((sample_size, geno.shape[1]))
y = np.zeros(sample_size)

for i in range(sample_size):
    X[i,] = geno[geno_idx[i], ]
    y[i] = phenotype_df[trait][phen_idx[i]]

def standardize(matrix):
    mean = np.mean(matrix, axis=0)
    std = np.std(matrix, axis=0)
    # Identify SNPs with small MAF
    non_zero_std = np.logical_and(mean/2 > 0.01, mean/2 < 0.99)
    
    # Filter the matrix
    matrix_filtered = matrix[:, non_zero_std]
    mean_filtered = mean[non_zero_std]
    std_filtered = std[non_zero_std]
    # Standardize the matrix
    return (matrix_filtered - mean_filtered) / std_filtered

X = standardize(X)
X0 = X
y0 = y

# Training and validation using subset
sample_size = 3000
num_snps = 400
snp_subset = np.linspace(0, X0.shape[1]-1, num_snps, dtype=int)
X = X0[:sample_size, snp_subset]
y = y0[:sample_size]
y = (y - np.mean(y))/np.std(y)

# Optimize alpha
het = 0.4
alpha_ridge = (1-het) *  X.shape[0] / (2*het * X.shape[1])
alpha_lasso = (1-het) / (het * X.shape[1])

# Initialize one array for all methods (replicates x 3 methods)
n_replicates = 100
correlations = np.zeros((n_replicates, 3))  # rows = replicates, columns = methods

for i in range(n_replicates):
   # Split data
   X_training, X_validation, y_training, y_validation = train_test_split(X, y, test_size=0.2)
   
   # Linear regression
   reg = LinearRegression().fit(X_training, y_training)
   correlations[i, 0] = np.corrcoef(reg.predict(X_validation), y_validation)[0, 1]
   
   # Ridge regression
   clf = RidgeCV(alphas=np.logspace(np.log10(alpha_ridge), np.log10(alpha_ridge*1000), 100)).fit(X_training, y_training)
   correlations[i, 1] = np.corrcoef(clf.predict(X_validation), y_validation)[0, 1]
   
   # LASSO
   clf = LassoCV(alphas=np.logspace(np.log10(alpha_lasso/10), np.log10(alpha_lasso*10), 100)).fit(X_training, y_training)
   correlations[i, 2] = np.corrcoef(clf.predict(X_validation), y_validation)[0, 1]

# Print mean correlations
print("Mean correlations (Linear, Ridge, Lasso):", np.mean(correlations, axis=0))

np.savetxt(f"correlations.{trait}.{num_snps}.txt", correlations, 
          delimiter=',',
          header='Linear,Ridge,Lasso',  # Column names
          fmt='%.4f',
          comments='')  # This removes the # symbol
