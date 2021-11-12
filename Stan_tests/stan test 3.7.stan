// stan test 3.5

functions {
  real[] sho(real t,
            real[] y,
            real[] theta,
            real[] x_r,
            int[] x_i) {
  real dydt_1 = y[2];
  real dydt_2 = -y[1] - theta[1] * y[2];
  return {dydt_1, dydt_2};
  }
}

data {
  int T;
  int N;
  real y0[2];
  real t0;
  real ts[T];
  real y[N, T, 2];
}

transformed data {
  real x_r[0];
  int x_i[0];
}

parameters {
  real <lower=0> sigma;
  real theta[1];
}

transformed parameters {
  real y_hat[N, T, 2];
  
  for (n in 1:N){
    y_hat[n, , ] = integrate_ode_rk45(sho, y0, t0, ts, theta, x_r, x_i);
  }
}

model {
  // priors
  sigma ~ normal(0.2, 0.1);
  //for (n in 1:N){
  theta[1] ~ normal(1.2, 0.4);

  // noise
  for(n in 1:N){
    y[n , ,1] ~ normal(y_hat[n, ,1], sigma);
    y[n , ,2] ~ normal(y_hat[n, ,2], sigma);
  }
}

