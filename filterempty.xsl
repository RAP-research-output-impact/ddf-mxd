<?xml version="1.0"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		version="1.0">
  <xsl:output method="xml" indent="yes" encoding="utf-8"/>

  <xsl:template match="*">
    <xsl:if test="node()">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:copy-of select="."/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>



</xsl:stylesheet>
