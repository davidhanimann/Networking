# Set default directory
setwd("~/Desktop/SpatAnalysisI/Networking/Networking/")

# Import GeoJSON
# Read data from JSON and cconvert to Spatial data frame
velo <- geojson_read("data/veloweg.geojson", what = "sp")
kreise <- geojson_read("data/stadtkreise.geojson", what = "sp")

# 

kreis1 <- velo[kreise[kreise$Kreisnummer==1,],]
plot(kreis1, col = kreis1$Objekt.ID)

kreis1@proj4string


plot(velo[velo$Radweg != 0 | velo$Radstreifen != 0,])
plot(velo)


# Graph
g1 <- graph(c(1,2)) 
plot(g1)
V(g1)
g1[]