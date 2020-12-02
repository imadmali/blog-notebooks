data {
  int<lower=0> N;
  real y[N];
  real mu_loc;
  real<lower=0> mu_sd;
}
parameters {
  real mu;
}
model {
  y ~ normal(mu, 1);
  mu ~ normal(mu_loc, mu_sd);
}
