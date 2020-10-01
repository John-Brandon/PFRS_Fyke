# PFRS_Fyke
Analysis of PFRS Fyke trap catch data. This repository includes code for Bayesian regression modeling using `STAN` and the `brms` package in `R`.

The model code should be considered somewhat preliminary at this stage. For example, it does not take into account several environmental covariates that should be available in the next iteration, e.g. water temperature. 

Nevertheless, it does provide an example of code that can be extended to include additional covariates, or adapted to fit regression models (including overdispersion and/or zero inflation) for alternative sources of catch data.

The `R` scripts have been divided into several steps for analysis: wrangling data; tabling data; fitting models; and plotting. File names correspond with code organized by each task, starting with the `wrangle_data.R` script as the first step in the workflow.

FAQs for `brms`, including installation and compiler requisites can be found [here](https://cran.r-project.org/web/packages/brms/readme/README.html). 
