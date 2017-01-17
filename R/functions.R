greenest <- function(x){
  result <- x$NAME_2[x$ndvi==max(x$ndvi)]
  return(result)
}

createProv <- function(x){
  prov <- subset(x, select=c('NAME_1', 'ndvi'))
  prov <- aggregate(x, by='NAME_1', sums=list(list(mean, 'ndvi')))
  return(prov)
}

greenestProv <- function(x){
  greenest_prov <- x$NAME_1[x$ndvi==max(x$ndvi)]
  return(greenest_prov)
}