## Name: Maarten van Doornik
## Date: 17-01-2017

#load libraries
library(raster)
library(rgdal)

#source functions
source("R/functions.R")

#download and unzip data
dir.create('./data')
download.file(url='https://raw.githubusercontent.com/GeoScripting-WUR/VectorRaster/gh-pages/data/MODIS.zip',
               destfile='data/MODIS_NDVI.zip', method='auto')
unzip('data/MODIS_NDVI.zip', exdir='data')

#load data into workspace
nlMunicipality <- getData('GADM',country='NLD', level=2, path='data')
modis <- brick(list.files(path='./data', pattern = glob2rx('MOD13A3*.grd'), full.names = TRUE))

#Create the same coordinate system
nlMunicipality <- spTransform(nlMunicipality, CRS(proj4string(modis)))

#mask the MODIS NDVI data to the boundaries of the Netherlands
modisNL <- mask(modis, nlMunicipality)

#put the necessary layers in separate variables
ndvi_jan <- modisNL[["January"]]
ndvi_aug <- modisNL[["August"]]
ndvi_avg <- mean(modisNL)
names(ndvi_jan) <- 'ndvi'
names(ndvi_aug) <- 'ndvi'
names(ndvi_avg) <- 'ndvi'

#extract the mean NDVI value for every municipality
mun_ndvi_jan <- extract(ndvi_jan, nlMunicipality, sp=TRUE, fun=mean, na.rm=TRUE)
mun_ndvi_aug <- extract(ndvi_aug, nlMunicipality, sp=TRUE, fun=mean, na.rm=TRUE)
mun_ndvi_avg <- extract(ndvi_avg, nlMunicipality, sp=TRUE, fun=mean, na.rm=TRUE)

#find the greenest municipality in January, August and on average
greenest_jan <- greenest(mun_ndvi_jan)
greenest_aug <- greenest(mun_ndvi_aug)
greenest_avg <- greenest(mun_ndvi_avg)

#find the greenest province in January
provinces <- createProv(mun_ndvi_jan)
greenest_prov <- greenestProv(provinces)

#write down the result
paste("The greenest municipality in January is", greenest_jan)
paste("The greenest municipality in August is", greenest_aug)
paste("The greenest municipality on average is", greenest_avg)
paste("The greenest province in January is", greenest_prov)

#plot maps
spplot(mun_ndvi_jan, zcol='ndvi', main="Greenness of the Dutch municipalities in January", col.regions=rev(terrain.colors(255)))
spplot(mun_ndvi_aug, zcol='ndvi', main="Greenness of the Dutch municipalities in August", col.regions=rev(terrain.colors(255)))
spplot(mun_ndvi_avg, zcol='ndvi', main="Average greenness of the Dutch municipalities over the year", col.regions=rev(terrain.colors(255)))
spplot(provinces, zcol='ndvi', main="Greenness of the Dutch provinces in January", col.regions=rev(terrain.colors(255)))
