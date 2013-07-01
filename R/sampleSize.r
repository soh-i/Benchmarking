nsize <- function(error=e, zscore=z, number=n, pval=p) {
    n <- number/((error/zscore)^2 * (number-1)/(pval*(1-pval))+1)
      return (n)
  }

print(nsize(e=0.05, z=1.96, n=100, p=0.5))
