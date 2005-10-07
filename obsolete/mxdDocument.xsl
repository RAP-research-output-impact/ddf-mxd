<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		version="1.0">

<!-- Description:
*   
*      
*  This stylesheet transforms the ORBIT research database XML 
*  to the Danish national Exchange Format for Documents MXD
*  SUBDOCUMENT: Document data handling
* 
-->

<xsl:template name="handle-document">
  <xsl:param name="element"/>

  <xsl:element name="publication">
    <xsl:attribute name="id"><xsl:value-of select="$element/@id"/></xsl:attribute>
    <xsl:attribute name="doc_role"><xsl:value-of select="$element/@role"/></xsl:attribute>

    <!-- THE FOLLOWING ELEMENTS ARE COMPIED FROM THE MAIN XSL file -->
    <xsl:if test="$element/@volume">
      <xsl:attribute name="vol"><xsl:value-of select="document/@vol"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="$element/@issue">
      <xsl:attribute name="issue"><xsl:value-of select="document/@issue"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="$element/@year">
      <xsl:attribute name="year"><xsl:value-of select="document/@year"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="$element/@pages">
      <xsl:attribute name="pages"><xsl:value-of select="document/@pages"/></xsl:attribute>
    </xsl:if>
    <xsl:call-template name="handle-language">
      <xsl:with-param name="element" select="$element/language"/>
    </xsl:call-template>

    <xsl:call-template name="handle-title">
      <xsl:with-param name="element" select="$element/title"/>
    </xsl:call-template>
    <xsl:call-template name="handle-hardcopy">
      <xsl:with-param name="element" select="$element/hardcopy"/>
    </xsl:call-template>
    <xsl:call-template name="handle-ixxn">
      <xsl:with-param name="element" select="$element/identifier"/>
    </xsl:call-template>
    <xsl:call-template name="handle-imprint">
      <xsl:with-param name="element" select="$element/imprint"/>
    </xsl:call-template>
    <xsl:call-template name="handle-locals">
      <xsl:with-param name="element" select="$element/local2"/>
    </xsl:call-template>
    <xsl:call-template name="handle-note">
      <xsl:with-param name="element" select="$element/note"/>
    </xsl:call-template>
    <xsl:call-template name="handle-www">
      <xsl:with-param name="element" select="$element/www"/>
    </xsl:call-template>
    <xsl:call-template name="handle-unstruc">
      <xsl:with-param name="element" select="$element/unstruc"/>
    </xsl:call-template>
    <xsl:for-each select="$element/person">
      <xsl:call-template name="handle-person">
	<xsl:with-param name="element" select="."/>
      </xsl:call-template>
      <xsl:call-template name="handle-organisation">
	<xsl:with-param name="element" select="./organisation"/>
      </xsl:call-template>
    </xsl:for-each>

  </xsl:element>
</xsl:template>


</xsl:stylesheet>

