convertDataStacked = function(data, classes) {

  if(is.list(data) & is.null(classes)) {

    if(is.data.frame(data)) {

      return(data)

    } else {

      if(is.null(names(data))) {

        data = setNames(data, as.factor(1:length(data)))

      }

      return(stack(data))

    }

  } else if(is.vector(data) & is.vector(classes) & length(data) == length(classes)) {

    return(data.frame(data, as.factor(classes)))

  } else {

    stop("data and class type does not fit, if data is a matrix or a stacked data frame then classes must me NULL, if x is a vector then classes must be a vector.")

  }
}


densitiesEval = function(data, bw = bw.nrd0(data[,1]), npoints = 512) {

  mini = min(data[,1]) - 3*bw

  maxi = max(data[,1]) + 3*bw

  l = levels(data[,2])

  densities = list()

  for(i in 1:length(l)) {

    densities[[i]] = density(data[data[,2] == l[i],1], bw, n = npoints, na.rm = TRUE, from = mini, to = maxi)

  }

  return(list(densities = densities, labels = l))
}


commonArea = function(densities) {

  x = densities[[1]]$x

  y = densities[[1]]$y

  for(i in 2:length(densities)) {

    for(j in 1:length(x)) {

      y[j] = min(y[j], densities[[i]]$y[j])

    }

  }

  return(auc(x, y, type = 'spline'))
}


pairwiseCommonArea = function(densities, labels) {

  pairwiseca = matrix(0, nrow = length(labels), ncol = length(labels))

  rownames(pairwiseca) = labels

  colnames(pairwiseca) = labels

  for(i in 1:length(labels)) {

    for(j in 1:length(labels)) {

      if(i > j) {

        pairwiseca[i,j] = NA

      }

      if(i == j) {

        pairwiseca[i,j] = 1

      }

      if(i < j) {

        pairwiseca[i,j] = commonArea(densities[c(i,j)])

      }

    }

  }

  return(pairwiseca)
}


permTest = function(data, B, threads, bw, npoints, k) {

  if(threads > 1) {

    if(threads > detectCores()) {

      warning("threads inserted greater than available, parameter threads set to total cores - 1.")

      threads = detectCores() - 1

    }

    cl = makeCluster(threads)

    registerDoParallel(cl)

    on.exit(stopCluster(cl))

    Ti = foreach(i = 1:B, .combine = c, .export = c("commonArea", "densitiesEval"), .packages = "MESS") %dopar% {

      data[,1] = sample(data[,1])

      return(commonArea(densitiesEval(data, bw, npoints)$densities))

    }

  } else {

    Ti = vector("numeric", B)

    for(i in 1:B) {

      data[,1] = sample(data[,1])

      Ti[i] = commonArea(densitiesEval(data, bw, npoints)$densities)

    }

  }

  p = (1/B)*sum(Ti < k)

  return(p)
}


pairwisePermTest = function(data, labels, B, threads, bw, npoints, pairwiseca) {

  pairwisep = matrix(0, nrow = length(labels), ncol = length(labels))

  rownames(pairwisep) = labels

  colnames(pairwisep) = labels

  for(i in 1:length(labels)) {

    for(j in 1:length(labels)) {

      if(i >= j) {

        pairwisep[i,j] = NA

      } else {

        data2 = data[data[,2] %in% labels[c(i,j)],]

        data2[,2] = factor(data2[,2])

        pairwisep[i,j] = permTest(data2, B, threads, bw = bw(data2[,1]), npoints, pairwiseca[i,j])

      }

    }

  }

  return(pairwisep)
}


commonAreaReal = function(d, dfunc) {

  x = d$x

  y = d$y

  for(j in 1:length(x)) {

    y[j] = min(y[j], dfunc(d$x[j]))

  }

  return(auc(x, y, type = 'spline'))
}


#' @export

plot.densities = function(output) {

  ymax = 0

  for(i in 1:length(output$labels)) {

    if(max(output$densities[[i]]$y) > ymax) {

      ymax = max(output$densities[[i]]$y)

    }

  }

  xlabel = paste('Common area =', round(output$ca, 4))

  if(!is.null(output$pvalue)) {

    xlabel = paste(xlabel, '/ p-value =', round(output$pvalue, 4))

  }

  plot(output$densities[[1]], col = 1, main = 'Comparison of densities', xlab = xlabel, ylab = "Density", ylim = c(0, ymax))

  for(i in 2:length(output$labels)) {

    lines(output$densities[[i]], col = i)

  }

  legend('topright', output$labels, col = 1:length(output$labels), lwd = 2, bty = 'n')

}
