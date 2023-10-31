<?xml version="1.0"?>
<!--
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:gpx="http://www.topografix.com/GPX/1/0">
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.interlis.ch/INTERLIS2.3"
                xmlns:gpx="http://www.topografix.com/GPX/1/1"
                xmlns:gpxtpx="http://www.garmin.com/xmlschemas/TrackPointExtension/v1"
                xmlns:uuid="java:java.util.UUID"
                exclude-result-prefixes="gpx gpxtpx uuid">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

    <xsl:variable name="ilimodel" select="'GPX_GARMIN_EXTENSIONS'"/>
    <xsl:param name="TRACK_CMT" select="0"/>

    <xsl:template match="/">
        <xsl:variable name="GPX_BID" select="uuid:randomUUID()"/>
        <TRANSFER>
            <HEADERSECTION SENDER="gpx2xtf XSLT processor" VERSION="2.3">
                <MODELS>
                    <MODEL VERSION="2023-08-24" URI="http://www.garmin.com">
                        <xsl:attribute name="NAME">
                            <xsl:value-of select="$ilimodel"/>
                        </xsl:attribute>
                    </MODEL>
                </MODELS>
            </HEADERSECTION>
            <DATASECTION>
                <xsl:element name="{$ilimodel}.GPX">
                    <xsl:attribute name="BID">
                        <!--xsl:value-of select="1"/-->
                        <xsl:value-of select="uuid:randomUUID()"/>
                    </xsl:attribute>
                    <xsl:element name="{$ilimodel}.GPX.TRACK">
                        <xsl:attribute name="TID">
                            <!--xsl:value-of select="1"/-->
                            <xsl:value-of select="$GPX_BID"/>
                        </xsl:attribute>
                        <cmt>
                            <xsl:value-of select="$TRACK_CMT"/>
                        </cmt>
                    </xsl:element>
                    <xsl:apply-templates select="gpx:gpx/gpx:trk/gpx:trkseg">
                        <xsl:with-param name="BASKET_ID" select="$GPX_BID"/>
                    </xsl:apply-templates>
                </xsl:element>
            </DATASECTION>
        </TRANSFER>
    </xsl:template>

    <xsl:template match="gpx:gpx/gpx:trk/gpx:trkseg">
        <xsl:param name="BASKET_ID" select="0"></xsl:param>
        <xsl:variable name="TRACKSEG_TID" select="uuid:randomUUID()"/>
        <xsl:element name="{$ilimodel}.GPX.TRACKSEGMENT">
            <xsl:attribute name="TID">
                <xsl:value-of select="$TRACKSEG_TID"/>
            </xsl:attribute>
            <xsl:element name="TRACK">
                <xsl:attribute name="REF">
                    <xsl:value-of select="$BASKET_ID"/>
                </xsl:attribute>
            </xsl:element>
        </xsl:element>
        <xsl:apply-templates select="gpx:trkpt">
            <xsl:with-param name="TRACKSEG_TID" select="$TRACKSEG_TID"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="gpx:trkpt">
        <xsl:param name="TRACKSEG_TID" select="0"></xsl:param>
        <xsl:element name="{$ilimodel}.GPX.TRACKPOINT">
            <xsl:attribute name="TID">
                <xsl:value-of select="uuid:randomUUID()"/>
            </xsl:attribute>
            <point>
                <COORD>
                    <C1>
                        <xsl:value-of select="@lon"></xsl:value-of>
                    </C1>
                    <C2>
                        <xsl:value-of select="@lat"></xsl:value-of>
                    </C2>
                    <C3>
                        <xsl:value-of select="gpx:ele"></xsl:value-of>
                    </C3>
                </COORD>
            </point>
            <time>
                <xsl:value-of select="concat(substring-before(gpx:time, 'Z'),'.000')"/>
            </time>
            <atemp>
                <xsl:value-of select="gpx:extensions/gpxtpx:TrackPointExtension/gpxtpx:atemp"/>
            </atemp>
            <cad>
                <xsl:value-of select="gpx:extensions/gpxtpx:TrackPointExtension/gpxtpx:cad"/>
            </cad>
            <hr>
                <xsl:value-of select="gpx:extensions/gpxtpx:TrackPointExtension/gpxtpx:hr"/>
            </hr>
            <xsl:element name="TRACKSEGMENT">
                <xsl:attribute name="REF">
                    <xsl:value-of select="$TRACKSEG_TID"/>
                </xsl:attribute>
            </xsl:element>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
