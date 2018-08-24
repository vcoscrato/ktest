# ktest
R interface for estimated kernel densities comparisons

## Installation

```R 
if (!require(devtools)) 
   install.packages('devtools') 
devtools::install_github('vcoscrato/ktest') 
```

## The kTest function
Performs a hypothesis test for equality of distributions based on the estimated kernel densities and the permutation test.

### Example

```R
data = list(x = rnorm(30), y = rexp(50), z = rpois(70, 1))

test = kTest(data)

print(test)

# 3 densities kTest results:
#
#- Common area between all densities: 0.4872
#
#- p-value for H0 (All densities are equal): 4e-04 
#
#
#-------------------------------
#          x      y        z    
#-------- ---- -------- --------
#   x      1    0.5392   0.5841 
#
#   y      NA     1      0.6674 
#
#   z      NA     NA       1    
#-------------------------------
#
#Table: Pairwise Common Area

plot(test)
```
![Alt text](https://github.com/vcoscrato/ktest/blob/master/tests/ktest1.jpeg?raw=true "")
```R
pairs(test)
```
![Alt text](https://github.com/vcoscrato/ktest/blob/master/tests/ktest2.jpeg.jpeg?raw=true "")




## The kSimmetryTest function
Performs a pdf simmetry test for given data based on the estimated kernel densities and the permutation test.

### Example

```R
x = rnorm(100)

x = rnorm(100)
test = kSymmetryTest(x)
print(test)

# kSymmetryTest results: 
#
#- Common area between densities: 0.9191
#
#- p-value for H0 (Density is symmetric around median): 0.7698

plot(test)
```
![Alt text](https://github.com/vcoscrato/ktest/blob/master/tests/kSymmetryTest.jpeg?raw=true "")


## The kGOFTest function
Performs a hypothesis test for goodness-of-fit based on the estimated kernel densities.

### Example

```R

#Comparing with standard normal distribution:

data = rnorm(100)

rfunc = function(n) {
  return(rnorm(n, 0, 1))
}

dfunc = function(x) {
  return(dnorm(x, 0, 1))
}

test = kGOFTest(data, rfunc, dfunc)

print(test)

# kGOFTest results: 
#
#- Common area between densities: 0.9072
#
#- p-value for H0 (Observed and theoric densities are equal): 0.2142

plot(test)
```
![Alt text](https://github.com/vcoscrato/ktest/blob/master/tests/kGOFTest.jpeg?raw=true "")
