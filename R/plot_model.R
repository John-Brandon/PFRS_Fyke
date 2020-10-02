#!usr/bin/env Rscript
#
# Purpose: Plot Bayesian model output for Fyke trap catch analysis
#  
# Author: John R. Brandon, PhD (ICF)
#         john.brandon at icf.com
# Date: 2020-09-28
library(pacman)
p_load(lubridate, here, janitor, tidyverse)

# Scripts for wrangling data and fitting models ----------------------------
# Calls read_data.R script to load data
# model_script = here::here('R', 'fit_models.R')  # Commented out assuming models have been run

# Plot NB (no ZI) model posteriors for stripers --------------------------------
sb_3_ggs = ggmcmc::ggs(sb_3)  # wrangle MCMC output into plot friendly format

sb_3_ggs %>% 
  filter(Chain == 1) %>% 
  mutate(Parameter = case_when(
    Parameter == 'b_Intercept' ~ 'Intercept',
    Parameter == 'b_baitedb_Cheese' ~ 'Cheese',
    Parameter == 'b_baitedc_Anchovies' ~ 'Anchovies',
    Parameter == 'b_proximity_to_pumps' ~ 'Proximity to Pumps',
    Parameter == 'b_soak_time_h' ~ 'Soak Time',
    Parameter == 'b_days_elapsed' ~ 'Days Elapsed',
    Parameter == 'shape' ~ 'NB Shape Parameter',
  )) %>% 
  mutate(Parameter = factor(Parameter, levels = c(
    'Intercept', 'Anchovies', 'Cheese', 'Soak Time',
    'Days Elapsed', 'Proximity to Pumps', 'NB Shape Parameter'
  ))) %>% 
  ggplot(aes(x = value)) +
  # facet_wrap(~Parameter, scales = 'free_y', ncol = 1) +
  facet_wrap(~Parameter, scales = 'free', ncol = 1) +
  # geom_freqpoly()
  geom_density(fill = 'gray', color = 'black') +
  # xlim(-2, 2) +
  labs(x = 'Value', 
       y = 'Density',
       title = 'Striped Bass') +
  theme_bw(base_size = 14) +
  theme(axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) +
  NULL

# Plot ZI NB model posteriors for largemouth -----------------------------------
lm_1_ggs = ggmcmc::ggs(lm_1)  # tidy MCMC samples

lm_1_ggs %>% 
  filter(Chain == 1) %>% 
  mutate(Parameter = case_when(
    Parameter == 'b_Intercept' ~ 'Intercept',
    Parameter == 'b_baitedb_Cheese' ~ 'Cheese',
    Parameter == 'b_baitedc_Anchovies' ~ 'Anchovies',
    Parameter == 'b_proximity_to_pumps' ~ 'Proximity to Pumps',
    Parameter == 'b_soak_time_h' ~ 'Soak Time',
    Parameter == 'b_days_elapsed' ~ 'Days Elapsed',
    Parameter == 'shape' ~ 'NB Shape Parameter',
    Parameter == 'zi' ~ 'Zero-Inflation'
  )) %>% 
  mutate(Parameter = factor(Parameter, levels = c(
    'Intercept', 'Anchovies', 'Cheese', 'Soak Time',
    'Days Elapsed', 'Proximity to Pumps', 'NB Shape Parameter', 'Zero-Inflation'
  ))) %>% 
  # filter(Parameter != 'Zero-Inflation') %>% 
  ggplot(aes(x = value)) +
  # facet_wrap(~Parameter, scales = 'free_y', ncol = 1) +
  facet_wrap(~Parameter, scales = 'free', ncol = 1) +
  # geom_freqpoly()
  geom_density(fill = 'gray', color = 'black') +
  # xlim(-2, 2) +
  labs(x = 'Value', 
       y = 'Density',
       title = 'Largemouth Bass') +
  theme_bw(base_size = 14) +
  theme(axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) +
  NULL

# Conditional (marginal) effects plots ----------------------------------------- 
plot(conditional_effects(sb_3), ask = FALSE)
plot(conditional_effects(sb_3), ask = FALSE, points = TRUE)  # More informative with data

# Different flavors of built-in plots with `brms`
brms::pp_check(sb_3)  # Posterior predictive check
brms::mcmc_plot(sb_3, type = 'dens')
brms::mcmc_plot(sb_3, type = 'hist')
brms::mcmc_plot(sb_3, type = 'violin')
brms::mcmc_plot(sb_3, type = 'intervals')
brms::mcmc_plot(sb_3, type = 'areas')
brms::mcmc_plot(sb_3, type = 'acf')
brms::mcmc_plot(sb_3, type = 'acf_bar')
brms::mcmc_plot(sb_3, type = 'scatter', pars = c('shape', 'zi'), alpha = 0.25)
brms::mcmc_plot(sb_3, type = 'rhat')

# Try `ggmcmc` plotting package ------------------------------------------------
sb_1_ggs = ggmcmc::ggs(sb_1)  # wrangle MCMC output into tidy data format for plotting, etc.
# sb_1_ggs  # Check

ggmcmc::ggs_density(sb_1_ggs)
tidybayes::get_variables(sb_1)