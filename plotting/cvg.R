library(tidyverse)

dt <- read.csv("results/final_results.csv")

cvgs <- dt %>% select(K, G, S, CV, NPfix)
cvgs$CV <- as.factor(cvgs$CV)

cvgs1 <- filter(cvgs, S == 0, K==100)
cvg1 <- cvgs1 %>% select(G, CV, NPfix)
cvgheat1 <- ggplot(cvg1, aes(x = CV, y = G, label = NPfix, fill = NPfix)) + 
  geom_tile(color = "#F5F2DD", size = 0.75) +
  scale_fill_gradient2(low = "#5d1900",
                       mid = "#f0eed7",
                       high = "#238230",
                       name = "NPfix",
                       midpoint = 1.0,
                       limits = c(0,2)) +
  scale_y_continuous(breaks = c(0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0)) +
  ggtitle("K=100") +
  theme(plot.title = element_text(hjust = 0.5))
cvgheat1

cvgs11 <- filter(cvgs, S == 0, K==10)
cvg11 <- cvgs11 %>% select(G, CV, NPfix)
cvgheat11 <- ggplot(cvg11, aes(x = CV, y = G, label = NPfix, fill = NPfix)) + 
  geom_tile(color = "#F5F2DD", size = 0.75) +
  scale_fill_gradient2(low = "#5d1900",
                       mid = "#f0eed7",
                       high = "#238230",
                       name = "NPfix",
                       midpoint = 1.0,
                       limits = c(0,2)) +
  scale_y_continuous(breaks = c(0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0)) +
  ggtitle("K=10") +
  theme(plot.title = element_text(hjust = 0.5))
cvgheat11

cvgs111 <- filter(cvgs, S == 0, K==1000)
cvg111 <- cvgs111 %>% select(G, CV, NPfix)
cvgheat111 <- ggplot(cvg111, aes(x = CV, y = G, label = NPfix, fill = NPfix)) + 
  geom_tile(color = "#F5F2DD", size = 0.75) +
  scale_fill_gradient2(low = "#5d1900",
                       mid = "#f0eed7",
                       high = "#238230",
                       name = "NPfix",
                       midpoint = 1.0,
                       limits = c(0,2)) +
  scale_y_continuous(breaks = c(0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0)) +
  ggtitle("K=1000") +
  theme(plot.title = element_text(hjust = 0.5))
cvgheat111

#

cvgs2 <- filter(cvgs, S == 0.01, K==10)
cvg2 <- cvgs2 %>% select(G, CV, NPfix)
cvgheat2 <- ggplot(cvg2, aes(x = CV, y = G, label = NPfix, fill = NPfix)) + 
  geom_tile(color = "#F5F2DD", size = 0.75) +
  scale_fill_gradient2(low = "#5d1900",
                       mid = "#f0eed7",
                       high = "#238230",
                       name = "NPfix",
                       midpoint = 1.0,
                       limits = c(0,2)) +
  scale_y_continuous(breaks = c(0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0)) +
  ggtitle("S=0.01 K=10")+
  theme(plot.title = element_text(hjust = 0.5))
cvgheat2

cvgs22 <- filter(cvgs, S == 0.01, K==100)
cvg22 <- cvgs22 %>% select(G, CV, NPfix)
cvgheat22 <- ggplot(cvg22, aes(x = CV, y = G, label = NPfix, fill = NPfix)) + 
  geom_tile(color = "#F5F2DD", size = 0.75) +
  scale_fill_gradient2(low = "#5d1900",
                       mid = "#f0eed7",
                       high = "#238230",
                       name = "NPfix",
                       midpoint = 1.0,
                       limits = c(0,2)) +
  scale_y_continuous(breaks = c(0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0)) +
  ggtitle("S=0.01 K=100")+
  theme(plot.title = element_text(hjust = 0.5))
cvgheat22

cvgs222 <- filter(cvgs, S == 0.01, K==1000)
cvg222 <- cvgs222 %>% select(G, CV, NPfix)
cvgheat222<- ggplot(cvg222, aes(x = CV, y = G, label = NPfix, fill = NPfix)) + 
  geom_tile(color = "#F5F2DD", size = 0.75) +
  scale_fill_gradient2(low = "#5d1900",
                       mid = "#f0eed7",
                       high = "#238230",
                       name = "NPfix",
                       midpoint = 1.0,
                       limits = c(0,2)) +
  scale_y_continuous(breaks = c(0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0)) +
  ggtitle("S=0.01 K=1000")+
  theme(plot.title = element_text(hjust = 0.5))
cvgheat222

#

cvgs3 <- filter(cvgs, S == 0.1, K==10)
cvg3 <- cvgs3 %>% select(G, CV, NPfix)
cvgheat3 <- ggplot(cvg3, aes(x = CV, y = G, label = NPfix, fill = NPfix)) + 
  geom_tile(color = "#F5F2DD", size = 0.75) +
  scale_fill_gradient2(low = "#5d1900",
                       mid = "#f0eed7",
                       high = "#238230",
                       name = "NPfix",
                       midpoint = 1.0,
                       limits = c(0,2)) +
  scale_y_continuous(breaks = c(0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0)) +
  ggtitle("S=0.1 K=10")+
  theme(plot.title = element_text(hjust = 0.5))
cvgheat3

cvgs33 <- filter(cvgs, S == 0.1, K==100)
cvg33 <- cvgs33 %>% select(G, CV, NPfix)
cvgheat33 <- ggplot(cvg33, aes(x = CV, y = G, label = NPfix, fill = NPfix)) + 
  geom_tile(color = "#F5F2DD", size = 0.75) +
  scale_fill_gradient2(low = "#5d1900",
                       mid = "#f0eed7",
                       high = "#238230",
                       name = "NPfix",
                       midpoint = 1.0,
                       limits = c(0,2)) +
  scale_y_continuous(breaks = c(0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0)) +
  ggtitle("S=0.1 K=100")+
  theme(plot.title = element_text(hjust = 0.5))
cvgheat33

cvgs333 <- filter(cvgs, S == 0.1, K==1000)
cvg333 <- cvgs333 %>% select(G, CV, NPfix)
cvgheat333 <- ggplot(cvg333, aes(x = CV, y = G, label = NPfix, fill = NPfix)) + 
  geom_tile(color = "#F5F2DD", size = 0.75) +
  scale_fill_gradient2(low = "#5d1900",
                       mid = "#f0eed7",
                       high = "#238230",
                       name = "NPfix",
                       midpoint = 1.0,
                       limits = c(0,2)) +
  scale_y_continuous(breaks = c(0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0)) +
  ggtitle("S=0.1 K=1000")+
  theme(plot.title = element_text(hjust = 0.5))
cvgheat333

#

cvgs4 <- filter(cvgs, S == 0.5, K==10)
cvg4 <- cvgs4 %>% select(G, CV, NPfix)
cvgheat4 <- ggplot(cvg4, aes(x = CV, y = G, label = NPfix, fill = NPfix)) + 
  geom_tile(color = "#F5F2DD", size = 0.75) +
  scale_fill_gradient2(low = "#5d1900",
                       mid = "#f0eed7",
                       high = "#238230",
                       name = "NPfix",
                       midpoint = 1.0,
                       limits = c(0,2)) +
  scale_y_continuous(breaks = c(0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0)) +
  ggtitle("S=0.5 K=10")+
  theme(plot.title = element_text(hjust = 0.5))
cvgheat4

cvgs44 <- filter(cvgs, S == .5, K==100)
cvg44 <- cvgs44 %>% select(G, CV, NPfix)
cvgheat44 <- ggplot(cvg44, aes(x = CV, y = G, label = NPfix, fill = NPfix)) + 
  geom_tile(color = "#F5F2DD", size = 0.75) +
  scale_fill_gradient2(low = "#5d1900",
                       mid = "#f0eed7",
                       high = "#238230",
                       name = "NPfix",
                       midpoint = 1.0,
                       limits = c(0,2)) +
  scale_y_continuous(breaks = c(0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0)) +
  ggtitle("S=0.5 K=100")+
  theme(plot.title = element_text(hjust = 0.5))
cvgheat44

cvgs444 <- filter(cvgs, S == 0.5, K==1000)
cvg444 <- cvgs444 %>% select(G, CV, NPfix)
cvgheat444 <- ggplot(cvg444, aes(x = CV, y = G, label = NPfix, fill = NPfix)) + 
  geom_tile(color = "#F5F2DD", size = 0.75) +
  scale_fill_gradient2(low = "#5d1900",
                       mid = "#f0eed7",
                       high = "#238230",
                       name = "NPfix",
                       midpoint = 1.0,
                       limits = c(0,2)) +
  scale_y_continuous(breaks = c(0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0)) +
  ggtitle("S=0.5 K=1000")+
  theme(plot.title = element_text(hjust = 0.5))
cvgheat444

#

cvgs5 <- filter(cvgs, S == 1, K==10)
cvg5 <- cvgs5 %>% select(G, CV, NPfix)
cvgheat5 <- ggplot(cvg5, aes(x = CV, y = G, label = NPfix, fill = NPfix)) + 
  geom_tile(color = "#F5F2DD", size = 0.75) +
  scale_fill_gradient2(low = "#5d1900",
                       mid = "#f0eed7",
                       high = "#238230",
                       name = "NPfix",
                       midpoint = 1.0,
                       limits = c(0,2)) +
  scale_y_continuous(breaks = c(0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0)) +
  ggtitle("S=1 K=10")+
  theme(plot.title = element_text(hjust = 0.5))
cvgheat5

cvgs55 <- filter(cvgs, S == 1, K==100)
cvg55 <- cvgs55 %>% select(G, CV, NPfix)
cvgheat55 <- ggplot(cvg55, aes(x = CV, y = G, label = NPfix, fill = NPfix)) + 
  geom_tile(color = "#F5F2DD", size = 0.75) +
  scale_fill_gradient2(low = "#5d1900",
                       mid = "#f0eed7",
                       high = "#238230",
                       name = "NPfix",
                       midpoint = 1.0,
                       limits = c(0,2)) +
  scale_y_continuous(breaks = c(0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0)) +
  ggtitle("S=1 K=100")+
  theme(plot.title = element_text(hjust = 0.5))
cvgheat55

cvgs555 <- filter(cvgs, S == 1, K==1000)
cvg555 <- cvgs555 %>% select(G, CV, NPfix)
cvgheat555 <- ggplot(cvg555, aes(x = CV, y = G, label = NPfix, fill = NPfix)) + 
  geom_tile(color = "#F5F2DD", size = 0.75) +
  scale_fill_gradient2(low = "#5d1900",
                       mid = "#f0eed7",
                       high = "#238230",
                       name = "NPfix",
                       midpoint = 1.0,
                       limits = c(0,2)) +
  scale_y_continuous(breaks = c(0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0)) +
  ggtitle("S=1 K=1000")+
  theme(plot.title = element_text(hjust = 0.5))
cvgheat555
