#!usr/bin/env Rscript
#
# Purpose: Fit Bayesian regression models to Fyke net catch data.
#  
# Author: John R. Brandon, PhD (ICF)
#         john.brandon at icf.com
# Date: 2020-09-28
library(pacman)
p_load(lubridate, here, janitor, tidyverse, brms, tidybayes, ggmcmc)

# Read and wrangle data --------------------------------------------------------
wrangle_script = here::here('R', 'wrangle_data.R')
source(wrangle_script)

# Striped bass -----------------------------------------------------------------

# Try zero-inflated NB with all available variables
sb_1 = brm(striped_bass ~ baited + proximity_to_pumps + soak_time_h + days_elapsed + deep_deployment,
           data = large_net_catch_dat,
           family = zero_inflated_negbinomial())

summary(sb_1)  # R_hat values near 1.0 are consistent with successful convergence

# Example dropping variables: deployment depth + days_elapsed since first set in this case 
sb_2 = brm(striped_bass ~ baited + proximity_to_pumps + soak_time_h,
           data = large_net_catch_dat,
           family = zero_inflated_negbinomial())

# Bayesian model comparison using Leave One Out (LOO) cross-validation
loo_sb_1 = loo(sb_1)
loo_sb_2 = loo(sb_2)
comp_sb = loo_compare(loo_sb_1, loo_sb_2)
comp_sb  # top model is sb_1

# Fit Stripers WITHOUT Zero inflation ---------------------------------------------------
# Note the "family" argument in `brm` function call below
sb_3 = brm(striped_bass ~ baited + proximity_to_pumps + soak_time_h + days_elapsed + deep_deployment,
           data = large_net_catch_dat,
           family = negbinomial())
loo_sb_3 = loo(sb_3)  
comp_sb_123 = loo_compare(loo_sb_1, loo_sb_2, loo_sb_3)  # model comparison with and without zero-inflation
comp_sb_123  # Top model includes all variables without zero-inflation in this example

summary(sb_3)
plot(conditional_effects(sb_3), ask = FALSE, points = TRUE)

# Fit largemouth bass ----------------------------------------------------------
lm_1 = brm(largemouth_bass ~ baited + proximity_to_pumps + soak_time_h + days_elapsed + deep_deployment,
           data = large_net_catch_dat,
           family = zero_inflated_negbinomial())
summary(lm_1)
plot(conditional_effects(lm_1), ask = FALSE, points = TRUE)

# Try without zero-inflation
lm_2 = brm(largemouth_bass ~ baited + proximity_to_pumps + soak_time_h + days_elapsed + deep_deployment,
           data = large_net_catch_dat,
           family = negbinomial())
summary(lm_2)
plot(conditional_effects(lm_2), ask = FALSE, points = TRUE)

# Model comparison for largemouth ----------------------------------------------
loo_lm_1 = loo(lm_1)
loo_lm_2 = loo(lm_2)
comp_lm_12 = loo_compare(loo_lm_1, loo_lm_2)
comp_lm_12  # lm_1 with ZI top model
