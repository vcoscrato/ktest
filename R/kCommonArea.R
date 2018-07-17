#' kCommonArea
#'
#' Computes the common area between two or more estimed kernel densities.
#'
#' @param data A stacked data frame (see ?convertDataStacked).
#' @param bw The bandwidth used to estimate the kernel densities.
#' @param npoints The number of points used to estimate the kernel densities.
#'
#' @return Common area between the kernel densities.
#' @export
#'
#' @examples data <- convertDataStacked(list(x = rnorm(30), y = rexp(50)))
#' kCommonArea(data)

kCommonArea <- function(data, bw = bw.nrd0(data[,1]), npoints = 512, plot = FALSE, return_densities = FALSE) {
  mini <- min(data[,1]) - 3*bw
  maxi <- max(data[,1]) + 3*bw
  l <- levels(data[,2])
  d <- density(data[data[,2] == l[1],1], n = npoints, na.rm = TRUE, from = mini, to = maxi)
  if(return_densities)
    densities = list(d)
  x <- d[[1]]
  y <- d[[2]]
  for(i in 2:length(l)) {
    d <- density(data[data[,2] == l[i],1], n = npoints, na.rm = TRUE, from = mini, to = maxi)$y
    if(return_densities)
      densities[[i]] = d
    for(j in 1:npoints) {
      y[j] <- min(y[j], d[j])
    }
  }
  if(plot) {
   for(i in 1:length(d))
     plot(densities[[i]], col = i)
  }
  if(return_densities)
    return(list(CommonArea = auc(x, y, type = 'spline'), densities = densities))
  else
    return(auc(x, y, type = 'spline'))
}
