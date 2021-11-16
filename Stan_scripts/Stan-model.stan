// Fruit-fly_tik-tok
// Guzkiel

functions {
vector circ(real t, 
            vector y, 
            real alpha,
            real beta,
            real Jcy,
            real Jc,
            real Jt,
            real Jp,
            real Kcy,
            real Kc,
            real Kt,
            real Kp, 
            vector lg,
            vector m,
            real x_r, 
            real x_i){
      vector[4] dydt;
      dydt[1] = (alpha/lg[1]) / Jcy  - (beta/lg[1]) * y[1]^m[1] / (Kcy^m[1] + y[1]^m[1]);
      dydt[2] = (alpha/lg[2]) / ( Jc + (y[1]*y[2])^m[2] ) - (beta/lg[2]) * y[2]^m[2] / (Kc^m[2] + y[2]^m[2]);
      dydt[3] = (alpha/lg[3]) * (y[1]*y[2])^m[3] / ( Jt + (y[1]*y[2])^m[3] + (y[3]*y[4])^m[3] ) - (beta/lg[3]) * y[3]^m[3] / (y[3]^m[3] + y[3]^m[3]);
      dydt[4] = (alpha/lg[4]) * (y[1]*y[2])^m[4] / ( Jt + (y[1]*y[2])^m[4] + (y[3]*y[4])^m[4] ) - (beta/lg[4]) * y[4]^m[4] / (y[4]^m[4] + y[4]^m[4]); 
      return dydt;
            }
}

data { 
  int<lower=1> T;             // total number of observations
  real ts[T];                 // vector de tiempos a resolver
  real ob[T, 4];              // array con las observaciones para cada gen en todos los tiempos ts. 
  vector[4] y0;               // valores iniciales 
  real<lower=0> t0;           // tiempo inicial
  real m[4];                  // ctes de hill
  real lg[4];                 // largo de los genes
  real x_i[T];                 // ?
  real x_r[T];                 // ?
}

parameters {
  real<lower=10> alpha;
  real<lower=10> beta;
  real<lower=0> Jcy;
  real<lower=0> Jc;
  real<lower=0> Jt;
  real<lower=0> Jp;
  real<lower=0> Kcy;
  real<lower=0> Kc;
  real<lower=0> Kt;
  real<lower=0> Kp;
  real<lower=0> sigma;
}

model{
  alpha ~ normal(0.016, 0.005);                                        // priors
  beta  ~ normal(0.016, 0.005);                                           
  sigma ~ cauchy(0, 1);
  y0    ~ normal(y0, sigma);                                                                               
  vector[4] y_hat[T] = ode_rk45(circ, y0, t0, ts, alpha, beta,         // Model: deterministic part 
                                Jcy, Jc, Jt, Jp, Kcy, Kc, Kt, Kp);
  for (t in 1:T) {                                                     // Model: random part 
    for (i in 1:4) {
      ob[t, i] ~ normal(y_hat[t, i], sigma);
    }
  }
}
