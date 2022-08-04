require(tidyverse)
dt <- read.csv("results/all_ctr.csv")

dt %>% select(Control, K, NPfix)

scat <- ggplot(dt, aes(x = K, y = NPfix, color = Control, shape = Control)) +
  geom_point(size = 2) +
  scale_x_log10() 
scat
