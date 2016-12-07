# Set default directory
setwd("~/Desktop/SpatAnalysisI/Networking/Networking/")
setwd("C:/Users/Hella/CloudStation/UZH/Master/872_Spatial_Analysis/Networking")

# Import GeoJSON
# Read data from JSON and cconvert to Spatial data frame
<<<<<<< HEAD
velo <- geojson_read("data/veloweg.geojson", what = "sp")
kreise <- geojson_read("data/stadtkreise.geojson", what = "sp")
=======
velo <- fromJSON("data/veloweg.json", flatten = FALSE)

# read all intersection points
points_all <- fromJSON("data/points_all_attributes.geojson", flatten = FALSE)
View(points_all)
# create spatial datafram
coords_points <- matrix(unlist(points_all$features$geometry$coordinates), ncol = 2, byrow = TRUE)
points_sp <- SpatialPointsDataFrame (coords = coords_points, data = points_all$features$properties, proj4string = CRS("+init=epsg:4326"))

# Plot Points spatial
plot(points_sp, pch = 20, cex = 0.1)

# show columnheader
head(points_sp)

# eliminate the column id_2
points_sp$id_2 <- NULL
head(points_sp) # id_2 is removed

class(points_sp)

# remove duplicated rows -> unique ID AND mm1091 (Height)
points_sp[ , 12] # ID
unique(points_sp)
points_sp[!duplicated(points_sp[,c('ID', 'mm1091')]),]
points_lim <- duplicated ( points_all[,12:13])
points_lim <- unique(points_all, by = "ID" AND "mm1091")


>>>>>>> a0c83d33d742c33bfd68e4b368625ac3bb54a57f

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