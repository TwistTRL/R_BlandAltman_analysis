# Bland-Altman analysis (with repeated measurements)
This is not a R package!
This repository is only intended as a documentation on what Bland-Altman is for, how Bland-Altman is done, and how it can be implemented in R. The code is directly from a data analysis project we did in the laboratory.

# About Bland-Altman analysis
Bland-Altman analysis, or Bland-Altman plot is a visualization technique for evaluating agreements between two "measurements".

# Differences from T-Test
One question I had about Bland-Altman analysis is how different it is from the popular T-Test. I can share some of my understanding in this subject, but I could be wrong. Fair warning.
Well, strictly speaking, Bland-Altman is only a visualization, not a hypothesis testing. People using Bland-Altman care about
1. the bias between (two) measurements, and 
2. the deviation of the differences between (two) measurements, and
3. how the deviation of the differences changes with magnitude of the measurements.
With T-Test, people care about 
1. the bias between (two) measurements, and
2. the deviation of the **mean difference** between (two) measurements.
The difference in how the deviation is measured should be apparent for those who understand the difference between standard deviation and the standard deviation of the mean. The limitation of T-Test is its assumption that the differences in measurements are centered around 0, without any hidden structure, or non-linearity, whereas Bland-Altman make no such assumption. It show you a visualization.

# How Bland-Altman analysis is done
(Assuming each measurement pair is independent)
Simple, you would plot out m1-m2 (y axis) vs (m1+m2)/2 (x axis). Additionally, you would add lines to indicate mean bias, mean of `m1-m2`; upper LOA, `mean_bias + 1.96*stdev(m1-m2)` and lower LOA.
In essense, LOA are 95% CI of `m1-m2`.
In addition, 95% CI of both LOA are usually reported. I would simply derive them using bootstrap method.
In essense, 95% CI of LOA are 95% CI of the 95% CI of `m1-m2`. Strange, right? I know.

# Bland-Altman analysis with repeated measurements
If the measurement pair comes from a handful of subjects; i.e, there are repeated measures in each subject, we would want to conduct a modified Bland-Altman analysis detailed by Bland and Altman, 2007. The basic idea is to weigh the within-subject variance and within-measurement variance properly. They detailed two methods, depending on whether the underlying measurements from a same subject varies or not. For detailed explanation, please refer to their paper.

# About this repo
This repository was created for Bland-Altman analysis with repeated measurements, where the measurements varies. Again, this is mainly for documentation.
To run the Bland-Altman analysis on test data:
```
library(tidyverse)
source("./BACalc.r")

df = read.csv("test_data.tsv",sep='\t')

run_BlandAltman_analysis_bootstrapped(df$RV,df$IC,df$Subj,10000)
```

by Lingyu Zhou
