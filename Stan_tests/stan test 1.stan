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
