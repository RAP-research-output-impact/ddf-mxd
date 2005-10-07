<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		version="1.0">

<!-- Description:
*   
*      
*  This stylesheet transforms the ORBIT research database XML 
*  to the Danish national Exchange Format for Documents MXD
*  SUBDOCUMENT: Person data handling
* 
-->

<xsl:variable name="personRoleMapping" select="document('personRoleMapping.xml')/*"/>

<xsl:template name="handle-person">
  <xsl:param name="element"/>

  <xsl:element name="person">
    <xsl:attribute name="aff_no"><xsl:value-of select="organisation[position()]/@id"/></xsl:attribute> <!-- EVT: Find the id for the current org and get the key-value from a unique list according to algorithmes found by Googling "xslt select unique" -->
    <xsl:element name="identifier">
      <xsl:choose>
	<xsl:when test="string-length($element/identifier)">
	  <xsl:attribute name="id_type"><xsl:value-of select="$element/identifier/@id_type"/></xsl:attribute>
	  <xsl:value-of select="$element/identifier"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$element/@id"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
    
    <!-- Partly defined in main stylesheet -->
    <xsl:call-template name="handle-name">  
      <xsl:with-param name="element" select="$element/name"/>
    </xsl:call-template>
    <xsl:call-template name="handle-contact">
      <xsl:with-param name="element" select="$element/contact"/>
    </xsl:call-template>
    <xsl:element name="nationality">
      <xsl:value-of select="$element/country"/>
    </xsl:element>
    <xsl:call-template name="handle-note">
      <xsl:with-param name="element" select="$element/note"/>
    </xsl:call-template>
    <xsl:call-template name="handle-www">
      <xsl:with-param name="element" select="$element/www"/>
    </xsl:call-template>
    <xsl:call-template name="handle-note">
      <xsl:with-param name="element" select="$element/note"/>
    </xsl:call-template>
    <xsl:element name="title">
      <xsl:value-of select="$element/title"/>
    </xsl:element>
    
  </xsl:element>
</xsl:template>


<xsl:template name="handel-role">
  <xsl:param name="element"/>
  <xsl:variable name="actualRole">
    <xsl:value-of select="$element"/>
  </xsl:variable>
  <xsl:attribute name="pers_role"><xsl:value-of select="$personRoleMapping/rule[in = $actualRole]/out"/></xsl:attribute>
</xsl:template>

</xsl:stylesheet>

