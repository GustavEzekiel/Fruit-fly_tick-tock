// stan test 4. Lodka volterra model

functions{
  real[] LV(real t,
            real[] y,
            real[] theta,
            real[] x_r,
            int[] x_i){
    real[] alpha;
    real[] beta;
    real[] gamma;
    real[] delta;

    real dydt[2];

    alpha = theta[1];
    beta = theta[2];
    gamma = theta[3];
    delta = theta[4];

    dydt[1] = alpha*y[1] - beta*y[1]*y[2];
    dydt[2] = gamma*y[1]*y[2] - delta*y[2];
    return dydt;
  }
}

data{

  int T;
  real ts[T];
  real y0[2];
  real t0;
  real y[T, 2];
  real sigma;

}

transformed data {
  real x_r[0];
  int x_i[0];
}

parameters{

  real alpha;
  real beta;
  real gamma;
  real delta;

}

transformed parameters{

  // deterministic node
  real y_hat[T, 2];
  real y_hat[T,2] = integrate_ode_rk45(LV, y0, t0, ts, alpha, beta, gamma, delta, x_r, x_i);

}

model {

  // priors
  alpha ~ normal(1, 0.4);
  beta ~ normal(1, 0.4);
  gamma ~ normal(1, 0.4);
  delta ~ normal(1, 0.4);

  // likelihood
  for (t in 1:T){
    real y[t, 2] ~ std_normal(y_hat[t,2], sigma);
  }
}
