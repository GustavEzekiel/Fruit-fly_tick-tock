# stan test 3.5 running


########### setting 

setwd("D:/Documents/Uncoma/Math & stadistics/Modelos en ecología/Tps/tpfinal/stan tests")

library(rstan)
library(readr)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())  # para que corra varias cadenas a la vez.


########## data 


datos <- list ( T = 10, 
                ts = seq(1:10), 
                y0 = c(1, 0), 
                t0 = 0)


########### running

model <- read_lines("stan test 3.5.stan")
stan.model <- stan_model (model_code = model)

fit <- sampling (stan.model, data = datos, iter = 1000, chains = 4)

#fit <- stan( file = "stan_test 3.stan", 
             #data   = datos, 
             #chains = 4,
             #iter   = 1000, 
             #thin   = 1)

fit
summary(fit)
plot(fit)
print(fit)
traceplot(fit)
y_hat <- extract(fit)$y_hat
y <- extract(fit)$y
