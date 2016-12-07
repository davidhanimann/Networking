library(jsonlite)
library(sp)
library(igraph)
library(dplyr)
library(leaflet)

# ------------------------
library(stplanr) ## didn't work for install.packages -> see workaround above 'pkgURL' 
# needed following packages installed that way as well:
library(sp)
library(DBI)
library(R6)
library(dplyr)
library(httr) #httr_1.2.1.zip
library(readr) # readr_1.0.0.zip
library(R.utlis) # R.utils_2.5.0.zip
library(R.methodsS3) # R.methodsS3_1.7.1.zip
library(R.oo)
library(RgoogleMaps) # 	RgoogleMaps_1.4.1.zip
library(data.table) # data.table_1.9.8.zip
library(lubridate) # 	lubridate_1.6.0.zip
library(maptools) # maptools_0.8-40.zip
library(openxlsx) # openxlsx_3.0.0.zip
library(stplanr)

# Url of the windows binary for spatstat and R Version 3.2
# see: https://cran.r-project.org/bin/win/contrib/3.2/
pkgUrl <- "https://cran.r-project.org/bin/windows/contrib/3.2/openxlsx_3.0.0.zip"
# Install the zip directly
install.packages(pkgUrl, repos = NULL,dependencies=TRUE, type="binary")
# ----------------------
