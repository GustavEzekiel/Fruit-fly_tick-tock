// stan test 3.5

functions {
  real[] sho(real t,
            real[] y,
            real[] theta,
            real[] x_r,
            int[] x_i) {
  
  real beta = theta[2];
  real alpha = theta[3]; 
  real Jt = theta[4];
  real Jp = theta[5];
  real mc = theta[6];
  real mt = theta[7];
  real mp = theta[8];
  
  real dydt_1 = 10^alpha/(theta[1] + y[1]^mc) - 10^beta*y[1];
  real dydt_2 = (10^alpha*y[1]^mt)/(Jt + y[1]^mt + (y[2]*y[3])^mt) - 10^beta*y[2];
  real dydt_3 = (10^alpha*y[1]^mp)/(Jp + y[1]^mp + (y[2]*y[3])^mp) - 10^beta*y[3];
  return {dydt_1, dydt_2, dydt_3};
  }
}

data {
  int <lower=0> T;
  int N;
  real y0[3];
  real t0;
  real<lower=t0> t[T];
  real y[T, N, 3];
  int mc;
  int mt;
  int mp;
}

transformed data {
  real x_r[0];
  int x_i[0];
}

parameters {
  real <lower=0> sigma;
  real <lower=0> alpha;
  real <lower=0> beta;
  real <lower=0> theta[1];
  real <lower=0> Jt;
  real <lower=0> Jp;
}

transformed parameters {
  real y_hat[T, N, 3];
  
  for (n in 1:N){
    y_hat[ , n, ] = integrate_ode_rk45(sho, y0, t0, t, theta, x_r, x_i);
  }
}

model {
  // priors
  sigma ~ normal(1, 2);
  for (n in 1:N){
    alpha[n] ~ normal(1.8, 0.5); # fijarse porque estos n tiran error.
    beta[n] ~ normal(1.8, 0.5);
}
  // noise
  for(n in 1:N){
    y[ , n, 1] ~ normal(y_hat[ , n, 1], sigma);
    y[ , n, 2] ~ normal(y_hat[ , n, 2], sigma);
    y[ , n, 3] ~ normal(y_hat[ , n, 3], sigma);
  }
}



