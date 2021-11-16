// Fruit-fly_tik-tok
// Guzkiel

data {
  int<lower=0> N;
  vector[N] t;
  vector[N] y;
}


parameters {
  real<lower=-1.5, upper=0> A;
  real<lower=0, upper=3> C;
  real<lower=0, upper=0.5> f;
  real<lower=-1, upper=0> w;
  real<lower=0> alpha;
}

model {
  // priors
  f ~ normal(0.25, 0.05); // previa informativa.
  A ~ uniform(-1.5, 0);   // previa informativa
  C ~ uniform(0, 3);      // previa informativa
  w ~ uniform(-1, 0);     // previa informativa
  alpha ~ normal(5 , 10); // previa no informativa: alpha es el parametro "shape" de la distribucion gamma. Beta = alpha/mu
  
  // model
  for (n in 1:N)
    y[n] ~ gamma(alpha, alpha * (1/(A * cos(f*t[n] + w) + C)));
}


