#!usr/bin/env Rscript
#
# Purpose: Read and wrangle Fyke trap catch data in preparation for analysis.
# 
# Author: John R. Brandon, PhD (ICF)
#         john.brandon at icf.com
# Date: 2020-09-23
library(pacman)
p_load(lubridate, here, janitor, tidyverse, readxl)

# Read data --------------------------------------------------------------------
dat_file = here::here('data', 'cleaned_cpue_data_2020-07-27.xlsx')

raw_dat = readxl::read_excel(path = dat_file,  
                             sheet = 'raw_catch') %>% 
  janitor::clean_names() %>% 
  mutate(deployment_date = as.Date(deployment_date),
         julian_day = format(deployment_date, format = '%j'),
         julian_day = as.integer(julian_day),
         dummy_year = 2020,
         month = lubridate::month(deployment_date),
         day = lubridate::day(deployment_date),
         baited_boolean = ifelse(baited == 'None', FALSE, TRUE),
         striped_bass = as.integer(striped_bass),
         largemouth_bass = as.integer(largemouth_bass),
         days_elapsed = julian_day - julian_day[1],
         days_elapsed = ifelse(days_elapsed < 0, 365 + days_elapsed, days_elapsed),
         baited = case_when(
           baited == 'None' ~ 'a_None',  # alphabetical prefix helps sort in facet plots
           baited == 'Cheese' ~ 'b_Cheese',  
           baited == 'Anchovies' ~ 'c_Anchovies'
         ),
         baited = factor(baited, levels = c('a_None', 'b_Cheese', 'c_Anchovies'))) %>% 
  select(julian_day, days_elapsed, everything())

# str(raw_dat)  # Check
# View(raw_dat)

# Get catch data for target species  -------------------------------------------
catch_dat = raw_dat %>% 
  select(julian_day:trap_diameter, largemouth_bass:all_predators, 
         baited_boolean) 

# Initial statistical analysis limited to 10-foot diameter traps
large_net_catch_dat = filter(catch_dat, trap_diameter == 10)

