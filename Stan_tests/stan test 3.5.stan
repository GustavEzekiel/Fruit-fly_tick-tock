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
  real y0[2];
  real t0;
  real ts[T];
  real y[T, 2];
}

transformed data {
  real x_r[0];
  int x_i[0];
}

parameters {
  real theta[1];
  real <lower=0> sigma;
}

transformed parameters {
  real y_hat[T,2] = integrate_ode_rk45(sho, y0, t0, ts, theta, x_r, x_i);
}

model {
  // priors
  theta ~ normal(1.2, 0.4);
  sigma ~ normal(0.2, 0.1);
  // noise
  y[, 1] ~ normal(y_hat[, 1], sigma);
  y[, 2] ~ normal(y_hat[, 2], sigma);
}

