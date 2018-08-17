# ktest
R interface for estimated kernel densities comparisons

## Instalattion

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

kTest(data)

#$`commonArea`
#[1] 0.4895715

#$p.value
#[1] 2e-04
```

## The kSimmetryTest function
Performs a pdf simmetry test for given data based on the estimated kernel densities and the permutation test.

### Example

```R
x = rnorm(100)

kSimmetryTest(x, around = 'median')

#$`commonArea`
#[1] 0.9450761

#$p.value
#[1] 0.9232
```

## The kGOFTest function
Performs a hypothesis test for goodness-of-fit based on the estimated kernel densities.

### Example

```R

#When using no extra parameters on rfunc and dfunc:

data = rnorm(100)

rfunc = function(n) {
  return(rnorm(n, 0, 1))
}

dfunc = function(x) {
  return(dnorm(x, 0, 1))
}

kGOFTest(data, rfunc, dfunc)

#$`commonArea`
#[1] 0.9034465

#$p.value
#[1] 0.1684

#When using parameters on rfunc and dfunc:

data = rnorm(100)

param1 = 0

param2 = 1

var_names = c(param1, param2)

rfunc = function(n) {
  return(rnorm(n, param1, param2))
}

dfunc = function(x) {
  return(dnorm(x, param1, param2))
}

kGOFTest(data, rfunc, dfunc, param_names = c('param1', 'param2'))

#$`commonArea`
#[1] 0.9537704

#$p.value
#[1] 0.8874
```
