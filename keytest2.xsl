<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		version="1.0">

  <xsl:output method="xml" indent="yes" encoding="utf-8"/>

  <xsl:key name="orgkey" match="//person/org" use="name"/>
  <!--xsl:key name="orgkey" match="//person/org" use="."/-->

  <xsl:template match="/root">

    <root>
      <xsl:for-each select="record">
        <record>
          <xsl:for-each select="person">
            <xsl:call-template name="handle-person">
              <xsl:with-param name="element" select="."/>
            </xsl:call-template>
          </xsl:for-each>
          
          <xsl:for-each select="person/org[not(. = ../preceding-sibling::*/org)]">
            <xsl:call-template name="handle-organisation">
              <xsl:with-param name="element" select="."/>
            </xsl:call-template>
          </xsl:for-each>
          </record>
      </xsl:for-each>        

    </root>

  </xsl:template>


  <xsl:template name="handle-organisation">
    <xsl:param name="element"/>
    
    <xsl:element name="organisation">
      <xsl:attribute name="aff_no">
        <xsl:value-of select="position()"/>
      </xsl:attribute>
      <xsl:value-of select="./name"/>
    </xsl:element>
  </xsl:template>
  

  <xsl:template name="handle-person">
    <xsl:param name="element"/>

    <xsl:variable name="orgs" select="..//person/org"/>

    <xsl:element name="person">
      <xsl:attribute name="aff_no">
        <xsl:variable name="myorgname" select="org/name"/>
        <xsl:value-of select="$orgs/org[name=$myorgname]"/>
      </xsl:attribute> 
      <xsl:value-of select="./name"/>
    </xsl:element>
  </xsl:template>
    
</xsl:stylesheet>
