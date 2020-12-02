library(rstan)
rstan_options(auto_write = TRUE)

N <- 1e3
y <- rnorm(N, 3, 1)

B <- 10
b <- rep(1:B, each = floor(N/B))

# diffuse initial prior
stan_data <- list(mu_loc = 0,
                  mu_sd = 5)

# perturb up the first and fifth batch
y[b==1] <- rnorm(length(which(b==1)), 0, 1)
y[b==5] <- rnorm(length(which(b==1)), 0, 1)

batch_fits <- list()
batch_priors <- list(mu_loc = stan_data$mu_loc, mu_sd = stan_data$mu_sd)
batch_posterior <- matrix(NA, ncol = 3, nrow = B, dimnames = list(NULL, c("mean", "lwr", "upr")))
batch_posterior <- data.frame(batch_posterior)

for (i in 1:B) {
  # fit
  stan_data$y <- y[b==i]
  stan_data$N <- length(stan_data$y)
  fit <- stan("model.stan", data = stan_data, chains = 4, iter = 2e3, refresh = 0)
  batch_fits[[i]] <- fit
  # update prior
  samples <- as.matrix(fit)
  post_mu <- samples[,"mu"]
  stan_data$mu_loc <- mean(post_mu)
  stan_data$mu_sd <- sd(post_mu)
  batch_posterior[i,] <- c(mean = mean(post_mu), lwr = quantile(post_mu, 0.05), upr = quantile(post_mu, 0.95))
  batch_priors$mu_loc <- append(batch_priors$mu_loc, stan_data$mu_loc)
  batch_priors$mu_sd <- append(batch_priors$mu_sd, stan_data$mu_sd)
}

plot(batch_posterior$mean, type = "l", ylim = c(0,5))
lines(batch_posterior$lwr, lty = 2)
lines(batch_posterior$upr, lty = 2)
abline(h = mean(y), col = "red")

hist(post_mu, breaks = 50, col = "#808080", border = FALSE)
abline(v = mean(post_mu), col = "black", lwd = 3)
abline(v = mean(y), col = "red", lwd = 3)
abline(v = quantile(post_mu, 0.05), lty = 2, lwd = 2)
abline(v = quantile(post_mu, 0.95), lty = 2, lwd = 2)
