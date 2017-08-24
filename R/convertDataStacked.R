#' convertDataStacked
#'
#' Creates stacked data frame.
#'
#' @param data Either a list of numeric vectors or a data frame where each column
#' is a vector of observations.
#'
#' @return A stacked data frame.
#' @export
#'
#' @examples convertDataStacked(list(x=c(1,2), y=c(2,3,3), z=c(3,4,5,6,7)))
#' convertDataStacked(data.frame(x=c(1,2), y=c(2,3), z=c(3,4)))

convertDataStacked <- function(data) {
  if(is.list(data)) {
    if(is.data.frame(data)) {
      if(is.factor(data[,2])) {
        return(data[is.na(data)[,1] == FALSE,])
      } else {
        return(stack(data)[is.na(stack(data)[,1]) == FALSE,])
      }
    } else {
      if(is.null(names(data))) {
        data <- setNames(data, as.factor(1:length(data)))
      }
      return(stack(data))
    }
  } else {
    stop("Object type is not valid, insert one of, list, data frame or stacked data frame.")
  }
}
