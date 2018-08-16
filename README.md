# ktest
R interface for estimated kernel densities comparisons

## The kTest function
Performs a hypothesis test for equality of distributions based on the estimated kernel densities and the permutation test.

### Example

```R
> data = list(x = rnorm(30), y = rexp(50), z = rpois(70, 1))

> kTest(data)

$`commonArea`
[1] 0.4895715

$p.value
[1] 2e-04
```

## The kSimmetryTest function
Performs a pdf simmetry test for given data based on the estimated kernel densities and the permutation test.

### Example

```R
> x = rnorm(100)

> kSimmetryTest(x, around = 'median')

$`commonArea`
[1] 0.9450761

$p.value
[1] 0.9232
```

## The kGOFTest function
Performs a hypothesis test for goodness-of-fit based on the estimated kernel densities.

### Example

```R
> data = rnorm(100)

> param1 = mean(data)

> param2 = sd(data)

> var_names = c(param1, param2)

> rfunc = function(n) {
+   return(rnorm(n, param1, param2))
+ }

> dfunc = function(x) {
+   return(dnorm(x, param1, param2))
+ }

> kGOFTest(data, rfunc, dfunc, threads = 2, param_names = c('param1', 'param2'))

$`commonArea`
[1] 0.921853

$p.value
[1] 0.3854
```
