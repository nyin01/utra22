dt <- read.csv("results copy/short_result.csv")
install.packages("tidyverse")
require(tidyverse)

View(dt)

kg <- dt %>% select(k, g, npf)
kgheat <- ggplot(kg, aes(k, g)) + geom_tile(aes(fill=npf))
kgheat

ks <- dt %>% select(k, s, npf)
ksheat <- ggplot(ks, aes(k, s)) + geom_tile(aes(fill=npf))
ksheat

kcv <- dt %>% select(k, cv, npf)
kcvheat <- ggplot(kcv, aes(k, cv)) + geom_tile(aes(fill=npf))
kcvheat

gs <- dt %>% select(g, s, npf)
gsheat <- ggplot(gs, aes(g, s)) + geom_tile(aes(fill=npf))
gsheat

gcv <- dt %>% select(g, cv, npf)
gcvheat <- ggplot(gcv, aes(g, cv)) + geom_tile(aes(fill=npf))
gcvheat

scv <- dt %>% select(s, cv, npf)
scvheat <- ggplot(scv, aes(s, cv)) + geom_tile(aes(fill=npf))
scvheat
