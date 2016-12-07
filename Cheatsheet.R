# Import GeoJSON and store as sp-Dataframe
# The geojson has to be downloaded and the suffix must be changed to ".gejson"
sp_df <- geojson_read(<filepath>, what = "sp")