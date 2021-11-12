// stan test 2 - scripted stan program.

functions {
  real[] whatever(real t,
                  real[] y,
                  real[] theta,
                  real[] x_r,
                  int[] i_r){
    real dydt[2];
    dydt[1] = y[2];
    dydt[2] = -y[1] - theta[1] * y[2];
  return dydt;
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
  real y_hat[T,2] = integrate_ode_rk45(whatever, y0, t0, ts, theta, x_r, x_i);
}
