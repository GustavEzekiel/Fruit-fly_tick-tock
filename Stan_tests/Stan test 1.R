

############################## Probando stan ##################################-




#################### prueba con datos simulados.

set.seed (1234)
nobs      <- 30                                         # número de observaciones (plantas)
frutos    <- rep (20, nobs)                             # frutos disponibles
p_rem     <- 0.2                                        # probabilidad de remoción por fruto
removidos <- rbinom (nobs, size = frutos, prob = p_rem) # removidos: vector de 30 plantas con la cant. de removidos.


library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())  # para que corra varias cadenas a la vez.




## modelo escrito en stan.

modelstring <- "
data { 
  int<lower=1> N;             // total number of observations 
  int<lower=0> removidos[N];  // response variable 
  int<lower=1> frutos[N];
}

parameters {
  real<lower=0,upper=1> theta;
}

model{
  theta ~ beta(1,1);                     // prior
  removidos ~ binomial(frutos, theta);   // model
}
"



## Datos guardados en una lista.

datos <- list(
  N         = nobs,
  removidos = removidos,
  frutos    = frutos
) 



## lectura del string por parte del interpretador de stan

# forma 1
model <- stan_model(model_code = modelstring) 
fit <- sampling(model, 
                data   = datos, 
                chains = 4,
                iter   = 1000, 
                thin   = 1)

# forma 2
cat(file = "stan test 1.stan", modelstring) # guardado del archivo de texto con extensión .stan
fit <- stan( file = "stan_test.stan", 
             data   = datos, 
             chains = 4,
             iter   = 1000, 
             thin   = 1)           

# forma 3
library("readr")
model <- read_file("paht/to/file.stan")
stan.model <- stan_model(model_code = model)
fit <- sampling(stan.model, 
                data = datos, 
                chains = 4,
                iter   = 1000, 
                thin   = 1)

## visualizar salidas del modelo

fit
summary(fit)
plot(fit)
print(fit)
traceplot(fit)
extract(fit)

