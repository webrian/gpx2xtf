# GPX tracks to INTERLIS XLS Transformation 
GPX tracks (with Garmin trackpoint extensions) to INTERLIS XSL Transformation

## Prerequisites and database setup

Installation on Ubuntu 22.04

`sudo apt-get install xmlstarlet libsaxon-java libsaxon-java-doc`

Create a database

`java -jar ili2pg-5.0.1.jar --schemaimport --dbhost localhost --dbusr adrian --dbpwd ****** --dbdatabase adrian --dbschema tracks --coalesceCatalogueRef --createEnumTabs --createNumChecks --createUnique --createFk --createFkIdx --coalesceMultiSurface --coalesceMultiLine --coalesceMultiPoint --coalesceArray --beautifyEnumDispName --createGeomIdx --createMetaInfo --expandMultilingual --createDatasetCol --createTypeConstraint --createEnumTabsWithId --createTidCol --smart2Inheritance --strokeArcs=False --createBasketCol --defaultSrsAuth EPSG --defaultSrsCode 4326 --preScript NULL --postScript NULL --models GPX_GARMIN_EXTENSIONS GPX_GARMIN_EXTENSIONS.ili`

Create a materialized view

`psql -d $dbname -U $dbuser -f create_mv_tracks.sql`

## Add data to the database

Validate GPX

`xmlstarlet val -s gpx.xsd track.gpx`

XSL Transformation 

`saxon-xslt track.gpx gpx2xtf.xsl TRACK_CMT="202308231812" > track.xtf`

Validate INTERLIS output

`ilivalidator track.xtf`

Import data

`java -jar ili2pg-5.0.1.jar --update --dbhost localhost --dbusr adrian --dbpwd ****** --dbdatabase adrian --dbschema tracks --importTid --importBid --dataset 20120126_RoadCycling --iliMetaAttrs NULL 20120126_RoadCycling.xtf`

Refresh materialized view

`REFRESH MATERIALIZED VIEW tracks.mv_tracks;`
