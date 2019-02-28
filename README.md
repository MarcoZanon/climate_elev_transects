## Climate and elevation transects
This repository contains the code for this Shiny app:
https://zanon.shinyapps.io/clima_topo/

This app allows you to draw elevation (meters) and above-ground temperature (°C) curves along any North-South transect.

It works with climate data from [WorldClim version 2](http://worldclim.org/version2) and [ETOPO 5](https://www.eea.europa.eu/data-and-maps/data/world-digital-elevation-model-etopo5) elevation data (not included in the repository).  


#### To use the app locally:
- download and install a free version of [RStudio Desktop](https://www.rstudio.com/products/rstudio/download/)

- install R packages ```shiny```, ```raster```, and ```rgdal``` by typing ```install.packages(c("shiny", "raster", "rgdal"))``` in the RStudio Console.

- download the GEOTIFF DEM file alwdgg.tif from [here](https://www.eea.europa.eu/data-and-maps/data/world-digital-elevation-model-etopo5) and put it in the ```/data_sets/DEM_geotiff``` folder. 

- download 5min tmin and tmax data from [here](http://worldclim.org/version2) and unzip them in the ```/data_sets/WorldClim2``` folder.

- load ui.R and server.R into RStudio. 

The app should then be ready to run with RStudio. Click on ```▶ Run App``` in the top right corner of the RStudio code editor.
