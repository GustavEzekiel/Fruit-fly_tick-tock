

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
  real theta[1];
}

transformed data {
  real x_r[0];
  int x_i[0];
}

parameters {
  real <lower=0, upper=1> p;
}

model {
}

generated quantities {
  real y_hat[T,2] = integrate_ode_rk45(sho, y0, t0, ts, theta, x_r, x_i);
  // add measurement error
  real y[T, 2];
  for (t in 1:T) {
    y[t, 1] = y_hat[t,2] + normal_rng(0, 0.1); // rng stands for "random number generator"
    y[t, 2] = y_hat[t,2] + normal_rng(0, 0.1);
  }
}