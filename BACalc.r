library(tidyverse)

getDividend = function(ano){
  meanSq=ano$`Mean Sq`
  return( meanSq[1] - meanSq[2])
}

getDivisor = function(group){
  count = as.vector(table(group))
  n = length(count)
  sum_m = sum(count)
  sum_m2 = sum(count**2)
  return ((sum_m**2-sum_m2) / ((n-1)*sum_m))
}

run_BlandAltman_analysis_simple = function(x1,x2,group=NULL){
  if (is.null(group)) {
    diffMean = mean(x1-x2)
    variance = var(x1-x2)
    SD = sqrt(variance)
    return (list( mean=diffMean,
                  LOA_upper=diffMean+1.96*SD,
                  LOA_lower=diffMean-1.96*SD
                  )
            )
  }
  else {
    model = df %>% lm( formula=(x1-x2)~factor(group) )
    ano = anova(model)
    # Get dividend
    meanSq=ano$`Mean Sq`
    dividend = meanSq[1] - meanSq[2]
    # Get divisor
    count = as.vector(table(group))
    n = length(count)
    sum_m = sum(count)
    sum_m2 = sum(count**2)
    divisor = (sum_m**2-sum_m2) / ((n-1)*sum_m)
    # Get SD
    variance = dividend/divisor+ano$`Mean Sq`[2]
    diffMean = mean(x1-x2)
    SD = sqrt(variance)
    return (list( mean=diffMean,
                  LOA_upper=diffMean+1.96*SD,
                  LOA_lower=diffMean-1.96*SD
                  )
            )
  }
}

run_BlandAltman_analysis_bootstrapped = function(x1,x2,group=NULL,bootstrap=10000){
  diffMean = NULL
  LOA_upper = NULL
  LOA_lower = NULL
  res = run_BlandAltman_analysis_simple(x1,x2,group)
  diffMean = res$mean
  LOA_upper = res$LOA_upper
  LOA_lower = res$LOA_lower
  # To be filled
  mean_975CI = NULL
  mean_025CI = NULL
  LOA_upper_975CI = NULL
  LOA_upper_025CI = NULL
  LOA_lower_975CI = NULL
  LOA_lower_025CI = NULL
  # Start bootstrap
  index = seq(1,length(x1))
  m = c()
  u = c()
  l = c()
  if (is.null(group)) {
    for (i in seq(bootstrap)){
      order = sample(index,length(x1),replace=TRUE)
      tmp_x1 = x1[order]
      tmp_x2 = x2[order]
      res = run_BlandAltman_analysis_simple(tmp_x1,tmp_x2)
      m = c(m,res$mean)
      u = c(u,res$LOA_upper)
      l = c(l,res$LOA_lower)
    }
  }
  else {
    for (i in seq(bootstrap)){
      order = sample(index,length(x1),replace=TRUE)
      tmp_x1 = x1[order]
      tmp_x2 = x2[order]
      tmp_group = group[order]
      res = run_BlandAltman_analysis_simple(tmp_x1,tmp_x2,tmp_group)
      m = c(m,res$mean)
      u = c(u,res$LOA_upper)
      l = c(l,res$LOA_lower)
    }
  }
  mean_975CI = quantile(m,0.975)[1]
  mean_025CI = quantile(m,0.025)[1]
  LOA_upper_975CI = quantile(u,0.975)[1]
  LOA_upper_025CI = quantile(u,0.025)[1]
  LOA_lower_975CI = quantile(l,0.975)[1]
  LOA_lower_025CI = quantile(l,0.025)[1]
  return (list(mean=diffMean,
              LOA_upper = LOA_upper,
              LOA_lower = LOA_lower,
              mean_975CI = mean_975CI,
              mean_025CI = mean_025CI,
              LOA_upper_975CI = LOA_upper_975CI,
              LOA_upper_025CI = LOA_upper_025CI,
              LOA_lower_975CI = LOA_lower_975CI,
              LOA_lower_025CI = LOA_lower_025CI
              )
          )
} 
