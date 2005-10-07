<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		version="1.0">

<!-- Description:
*   
*      
*  This stylesheet transforms the ORBIT research database XML 
*  to the Danish national Exchange Format for Documents MXD
*  SUBDOCUMENT: Organisation data handling
* 
-->

<xsl:template name="handle-organisation">
  <xsl:param name="element"/>

  <xsl:element name="organisation">
    <xsl:attribute name="aff_no"><xsl:value-of select="$element/@id"/></xsl:attribute>
    <xsl:call-template name="handle-name">
      <xsl:with-param name="element" select="$element/name"/>
    </xsl:call-template>
  </xsl:element>
</xsl:template>


</xsl:stylesheet>

