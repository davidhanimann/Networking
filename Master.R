# Set default directory
setwd("~/Desktop/SpatAnalysisI/Networking/Networking/")

# Import GeoJSON
# Read data from JSON and cconvert to Spatial data frame
velo <- fromJSON("data/veloweg.json", flatten = FALSE)
coords <- matrix(unlist(velo$features$geometry$coordinates), ncol = 2, byrow = TRUE)
velo <- SpatialLinesDataFrame(coords = coords, data = velo$features$properties, proj4string = CRS("+init=epsg:4326"))

