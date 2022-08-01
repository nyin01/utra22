library(tidyverse)

dt <- read.csv("results copy/final_results.csv")
View(dt)

kg <- dt %>% select(k, g, npf)
kgheat <- ggplot(kg, aes(x = k, y = g, label = npf, fill = npf)) + 
  geom_tile(color = "#F5F2DD", size = 1) +
  scale_fill_gradient2(low = "#5d1900",
                       mid = "#f0eed7",
                       high = "#238230",
                       name = "npf",
                       midpoint = 1.0,
                       limits = c(0,2)) +
  scale_x_log10() +
  scale_y_continuous(breaks = c(0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0))
kgheat

ks <- dt %>% select(k, s, npf)
ks$s <- as.factor(ks$s)
ksheat <- ggplot(ks, aes(x = k, y = s, label = npf, fill = npf)) + 
  geom_tile(color = "#F5F2DD", size = 1) +
  scale_fill_gradient2(low = "#5d1900",
                       mid = "#f0eed7",
                       high = "#238230",
                       name = "npf",
                       midpoint = 1.0,
                       limits = c(0,2)) +
  scale_x_log10()
ksheat

kcv <- dt %>% select(k, cv, npf)
kcv$cv <- as.factor(kcv$cv)
kcvheat <- ggplot(kcv, aes(x = k, y = cv, label = npf, fill = npf)) + 
  geom_tile(color = "#F5F2DD", size = 1) +
  scale_fill_gradient2(low = "#5d1900",
                       mid = "#f0eed7",
                       high = "#238230",
                       name = "npf",
                       midpoint = 1.0,
                       limits = c(0,2)) +
  scale_x_log10()
kcvheat

sg <- dt %>% select(g, s, npf)
sg$s <- as.factor(sg$s)
sgheat <- ggplot(sg, aes(x = s, y = g, label = npf, fill = npf)) + 
  geom_tile(color = "#F5F2DD", size = 1) +
  scale_fill_gradient2(low = "#5d1900",
                       mid = "#f0eed7",
                       high = "#238230",
                       name = "npf",
                       midpoint = 1.0,
                       limits = c(0,2)) +
  scale_y_continuous(breaks = c(0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0))
sgheat

cvg <- dt %>% select(g, cv, npf)
cvg$cv <- as.factor(cvg$cv)
cvgheat <- ggplot(cvg, aes(x = cv, y = g, label = npf, fill = npf)) + 
  geom_tile(color = "#F5F2DD", size = 1) +
  scale_fill_gradient2(low = "#5d1900",
                       mid = "#f0eed7",
                       high = "#238230",
                       name = "npf",
                       midpoint = 1.0,
                       limits = c(0,2)) +
  scale_y_continuous(breaks = c(0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0))
cvgheat

scv <- dt %>% select(s, cv, npf)
scv$s <- as.factor(scv$s)
scv$cv <- as.factor(scv$cv)
scvheat <- ggplot(scv, aes(s, cv, fill= npf)) +
  geom_tile(color = "#F5F2DD", size = 1) +
  scale_fill_gradient2(low = "#5d1900",
                       mid = "#f0eed7",
                       high = "#238230",
                       name = "npf",
                       midpoint = 1.0,
                       limits = c(0,2))
scvheat

