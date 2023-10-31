# GPX tracks to INTERLIS XLS Transformation 
GPX tracks (with Garmin trackpoint extensions) to INTERLIS XSL Transformation 

Installation on Ubuntu 22.04

`sudo apt-get install xmlstarlet libsaxon-java libsaxon-java-doc`

Validate GPX

`xmlstarlet val -s gpx.xsd track.gpx`

XSL Transformation 

`saxon-xslt track.gpx gpx2xtf.xsl TRACK_CMT="202308231812" > track.xtf`

Validate INTERLIS output

`ilivalidator track.xtf`

Import to database

`ili2pg`
