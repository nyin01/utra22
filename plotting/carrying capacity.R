library(tidyverse)
dt <- read.csv("results/final_results.csv")

knpf <- dt %>% select(K, NPfix)
knpf$K <- as.factor(knpf$K)
p <- ggplot(knpf, aes(x=K, y=NPfix, fill=K)) +
  geom_violin() +
  scale_fill_grey() +
  theme_classic()
p

# sort
dtsorted <- dt[order(dt$S, dt$CV, dt$G),]

# select cols
dtselected <- dtsorted %>% select(K,NPfix)

# subset
k10 <- subset(dtselected, K==10, NPfix, drop=TRUE)
k100 <- subset(dtselected, K==100, NPfix, drop=TRUE)
k1000 <- subset(dtselected, K==1000, NPfix, drop=TRUE)

# paired t test
result12 <- t.test(k10, k100, paired=TRUE)
result12
result13 <- t.test(k10, k1000, paired=TRUE)
result13
result23 <- t.test(k100, k1000, paired=TRUE)
result23
