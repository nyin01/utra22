require(tidyverse)
neut0 <- read.csv("results copy/ctr_neut0.csv")
neut1 <- read.csv("results copy/ctr_neut1.csv")
neg <- read.csv("results copy/ctr_neg.csv")
pos <- read.csv("results copy/ctr_pos.csv")

neut0 %>% select(k, npf)
neut1 %>% select(k, npf)
neg %>% select(k, npf)
pos %>% select(k, npf)

neut0plot <- 
  ggplot(neut0, aes(k, npf)) +
  geom_point() +
  geom_smooth()
neut0plot

neut1plot <- 
  ggplot(neut1, aes(k, npf)) +
  geom_point() +
  geom_smooth()
neut1plot

negplot <- 
  ggplot(neg, aes(k, npf)) +
  geom_point() +
  geom_smooth()
negplot

posplot <- 
  ggplot(pos, aes(k, npf)) +
  geom_point() +
  geom_smooth()
posplot


