#!usr/bin/env Rscript
#
# Purpose: Initial exploration of PFRS Fyke net data for CPUE analysis.
#   From Rick Wilder:
#     The data are in an Excel document here:
#     S:\Corp\Projects\DWR\_BDO-1601\PFRS-03_ICF-00712.18\09_Technical Workspace\2020_number_crunching\Fykes\Fyke_data_combo_20201307.xlsx
# 
#     The cleaned up CPUE data are in the “Combo” tab, columns AV:BL. If you want to see raw catch data, they are in Q:AI.
# 
# Author: John R. Brandon, PhD (ICF)
#         john.brandon at icf.com
# Date: 2020-07-27
library(pacman)
p_load(lubridate, here, janitor, tidyverse)

# Read data --------------------------------------------------------------------
