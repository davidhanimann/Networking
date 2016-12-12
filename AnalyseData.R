# setwd("C:/Users/Hella/CloudStation/UZH/Master/872_Spatial_Analysis/Networking")


# Import GeoJSON
# Read data from JSON and cconvert to Spatial data frame
velo <- fromJSON("data/veloweg.json",  flatten = FALSE)
# velo$features ist ein dataframe mit 3 Spalten und 12562 Reihen
# Die drei Spalten haben die folgenden Eigenschaften. 
names(velo$features) # "type"       "geometry"   "properties"
n <- length(velo$features$geometry$coordinates)
coord <- velo$features$geometry$coordinates

# check if coordinates are all matrices
check <-vector(mode = "logical", length =n)
for ( i in 1:n) check[i] <- is.matrix(coord[[i]])
kM<- which(check==FALSE) # Linien, bei denen die Koordinaten keine Matrix sind
nn <- (1:n)[-kM] ## Linien ohne die Ausnahmen! # alle Koordinaten, die eine Matrix sind

coord1 <- coord[-kM] # Hier werden alle diese Linien aus der Liste entfernt (nur in coord1) 
# Subset aller "Matrix-Linien"

m <- length(coord1) ## n-m=l # 12518 of 12562 are matrices
l <- length(kM) # 44 of 12562 are not matrices

## von den kM Koordinaten sind 42 3-Dimensional, hier ist ?brigens auch ein anderer
## geometry.typ: MultiLineString!

## Zwei Linien von diesen kM Eintr?gen haben nochmals ein anderes Format!
check <-vector(mode = "logical", length =n)
for ( i in 1:n) check[i] <- is.list(coord[[i]])
iL<- which(check==TRUE) # coordinates that are lists (lists of matrices)
ohne <- match(iL,kM) # lines that are lists in the subset kM (2 of 44)
kM2 <- kM[-ohne] # lines that are multilinestrings but without the lists (42 of 44)
l2 <-length(kM2)
## in den Linien von kM2 ist jeweils ein dreidimensionales Array auf zwei Dimensionen
## zu reduzieren.
## in den Linien vln kL ist in der Liste nochmals eine Unterliste enthalten mit je 
## zwei Linien. Auch hier ist der geometry.type MultiLinestring.

# ----------------------------------------
# list of matrices elements
ll2 <- lapply(coord[[iL[1]]],Line) # list of matrices transform to line
ll3 <- lapply(coord[[iL[2]]],Line) # list of matrices transform to line
Ls2 <- Lines(ll2,ID=iL[1]) # add name to line
Ls3 <- Lines(ll3,ID=iL[2]) # add name to line
Sl2 <- SpatialLines(list(Ls2,Ls3), proj4string = CRS("+init=epsg:21782")) # transform to SpatialLines list
plot(Sl2) # show both lines

# ---------------------------------------
# 3-D arrays elements
ll4 <- vector("list",l2) # create vector of tablelist from 3-D arrays (#42)
# transform all vectors to list of lines
for ( i in 1:l2) ll4[[i]]<- list(Line(coord[[kM2[i]]][1:(dim(coord[[kM2[i]]])[1]),1,]),
                                 Line(coord[[kM2[i]]][1:(dim(coord[[kM2[i]]])[1]),2,]))
Ls4 <- mapply(Lines,ll4,kM2) # add unique name to each lines
Sl4 <- SpatialLines(Ls4, proj4string = CRS("+init=epsg:21782")) # transform to spatialLines
plot(Sl4) # show all lines that were savec as arrays (42)

# ---------------------------------------
# matrice elements

## Hier werden die anderen Linien von einem Listenformat in einen Format Line, Lines
## Dann SpatialLines und letztlich das SpatialLinesdataframe umgewandelt
ll1 <- lapply(coord1,Line) ## Diese Lineliste enth?lt eine Liste von Koordinaten mit jeder Linie!
# coord1 = all matrice elements from original dataset

m <- length(ll1) # 12518 elemetns in list
## Damit jede Linie einen Namen bekommt, muss aus jeder Linie ein "Lines-Objekt"
## erzeugt werden. Mapply erlaubt auf jedes Listenargument eine Funktion anzuwenden und dies mit Argumenten aus einem Vektor!!
Ls1 <- vector("list",m)
for (i in 1:m) Ls1[[i]] <- Lines(ll1[i],nn[i])
## Alternativ funktioniert auch das!
Ls1 <- mapply(Lines,ll1,nn)# zuweisung einer individuellen Zahl zu jeder Lines
Sp1 <- SpatialLines(Ls1, proj4string = CRS("+init=epsg:21782"))

plot(Sp1) # plot all lines saved as matrices and tranformed to spatialLines



# -----------------------------------------------
# Create Spatial Dataframe
Sp <- SpatialLines(c(Ls1,Ls2,Ls3,Ls4), proj4string = CRS("+init=epsg:21782")) # join all SpatialLines elements -> all dataelements in one


## Hier werden alle Lines- Objedkte in ein SpatialLines-Objekt umgewandelt
## F?r die Zuweisung der Koordinaten zu den "Properties" wird hier die Reihenfolge der Properties angepasst!
## In der Reihenfolge nn, kM2, kL werden die Properties neu geoordnet. Die Gr?sse n bleibt!
prop <-  velo$features[c(nn,kM2,iL),3]

## SpatialLinesDataFram create trhough spatialLines and data=prop
SPDF <- SpatialLinesDataFrame(Sp, prop)
coord_spdf <- coordinates(SPDF) 
class(coord_spdf) ## is list
coord_spdf[1] # line 1 is list with to points
coord_spdf[2] # line 2 is list with 11 points

length_segments <- line_length(SPDF, byid = TRUE) # length of each segement
View(length_segments) #´????
SPDF$Value <- ifelse(SPDF$Radstreifen ==0, "0", "2") # add new column with value based on if there is a cicleway or not
## this could be changed for user preferences


# -------------------------------------------
# build igraph
df.g <- graph.data.frame(d = SPDF, directed = FALSE)
plot(df.g, vertex.label = V(df.g)$Strasse)
plot(df.g)

# ------------------------------------------------
# callculate all line intersections

lines_intersection <- gsection(SPDF) # Divides SpatialLinesDataFrame objects into separate Lines.Each new Lines object is the aggregate
of a single number of aggregated lines.
Sl_intersect <- SpatialLinesNetwork(lines_intersection)
xy_intersect <- cbind(Sl_intersect@g$x, Sl_intersect@g$y)
View(SPDF)


# ----------------------------------------------
# STPLANR: SpatialLinesNetwork


## Lade Paket stplanr, um SpatialLinesNetwork zu kreieren!
library(stplanr)
Sln1 <- SpatialLinesNetwork(SPDF) ## Hier wurde aus dem SpatialLinesData ein Network erzeugt!
plot(Sln1)
plot(Sln1@g)

points(Sln1@g$x,Sln1@g$y, pch=20, col= "red") # plot all x/y of all points
xy_points <- cbind(Sln1@g$x,Sln1@g$y) # get all x/y of points in form of an array
class(xy_points)

V(Sln1@g)
plot(xy_points)

length(Sln1@g$x) # network conatins 9749 points/Vertices

# use Overline "intelligent overline of data" before creating SpatialLinesNetwork
ov <- overline(SPDF,attrib="coordinates") # overline spatialDataFrame
Nw <- SpatialLinesNetwork(ov) # create SpatialLinesNetwork
View(ov)
xy_ov <- cbind(Nw@g$x, Nw@g$y)
length(Nw@g$x)

ov1 <- overline(SPDF,attrib = c("Hoehe_Anfang","Hoehe_Ende")) # overline spatialDataFrame incl. Hoehe_Anfang, Hoehe_Ende
Nw1 <- SpatialLinesNetwork(ov1) # create SpatialLinesNetwork


weightfield(Nw2) <- "Hoehe_Ende" # Hoehe als Optimierungsvariable dem Netzwerk zuweisen.

shopa <- sum_network_routes(Nw,205,6000,sumvar=c("Hoehe_Ende","length"))
# shopa@data
# ID sum_Hoehe_Ende sum_length
# 1  1       50652.44   10.18214

shopa2 <- sum_network_routes(Nw2,205,6000,sumvar=c("Hoehe_Ende","length"))
# Wenn man dann die Berechnung auf Netzwerk zwei macht, dann spielt hier das Attribut sumvar nur für die Ausgabe
# des Ergebnis eine Rolle.

# Bei den beiden Beispielen wird mit jeweils die Summe der Variablen Höhe_Ende und length ausgegeben.


# shopa2@data
# ID sum_Hoehe_Ende sum_length
# 1  1       35941.39   12.81748








shortpath <- sum_network_routes(Nw, 155, 300, sumvars = "length") # calculate shortest path of random listIDs

plot(shortpath, col = "green", lwd = 4) # only plot shortest Path
plot(Nw,add=TRUE) # add network around shortest path


length(Nw@g$x) # 6167 points

coord_line <- coordinates(ov) # get all coordinates from lines
coord_line[1:20] # show coordinates 1:20
           
# ------------------------------------------------------
# Plot shortest Path and points of corresponding SpatialLinesNetwork

## Lade Paket leaflet!
library(leaflet)

m <- leaflet() %>% addTiles() %>% setView(lat= 47.4, lng= 8.5, zoom = 10) %>%
  addPolylines(data=ov, color ="yellow")%>%
  addPolylines(data = shortpath, color = "streetblue")

m



m <- leaflet() %>% addTiles() %>% setView(lat= 47.4, lng= 8.5, zoom = 10) %>%
  addPolylines(data=ov, color ="yellow")%>%
  addPolylines(data = shortpath, color = "streetblue") %>%
  addCircleMarkers(data = xy_points, radius = 4) %>%
  addCircleMarkers(data = xy_intersect, radius = 3, color= "green")
# addMarkers

m

