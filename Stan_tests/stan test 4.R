# stan test 4 runnin


########### settings

setwd("D:/Documents/Uncoma/Math & stadistics/Modelos en ecología/Tps/tpfinal/stan tests")

library(rstan)
library(readr)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())  # para que corra varias cadenas a la vez.


########## data 

theta = c(1.5, 1.5, 1.5, 1.5)

df <- read.csv("num.csv", sep = ",", header = T)

datos <- list ( T = 50, ts = seq(1:50), y0 = c(5, 5), t0 = 0, y = df[ , 2:3], sigma = 0.5)


########### running

model <- read_lines("stan test 4.stan")

stan.model <- stan_model (model_code = model)
fit <- sampling (stan.model, data = datos, iter = 500, chains = 2)