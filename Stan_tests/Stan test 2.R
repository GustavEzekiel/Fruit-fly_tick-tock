# test n 2 para modelos en stan.



#################################### armando los datos.

setwd("D:/Documents/Uncoma/Math & stadistics/Modelos en ecología/Tps/tpfinal/stan tests")

library(readr)
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())  # para que corra varias cadenas a la vez.


## Datos guardados en una lista.

theta = as.array(1.5)
datos <- list(
  T  = 10,
  ts = seq(1:10),
  y0 = c(1,1),
  t0 = 0,
  theta = theta
) 


## corrida del modelo

model <- read_lines("stan test 2.stan")
stan.model <- stan_model (model_code = model)
fit <- sampling (stan.model, data = datos, iter = 1000, chains = 4)



## visualizar salidas del modelo
fit
summary(fit)
plot(fit)
print(fit)
traceplot(fit)
y_hat <- extract(fit)$y_hat





