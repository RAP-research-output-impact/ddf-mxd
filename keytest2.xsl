<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		version="1.0">

  <xsl:output method="xml" indent="yes" encoding="utf-8"/>

  <xsl:key name="orgkey" match="//person/org" use="name"/>
  <!--xsl:key name="orgkey" match="//person/org" use="."/-->

  <xsl:template match="/root">

    <root>
      <xsl:for-each select="record">

        <xsl:variable name="orgs" select="person/org[not(name = ../preceding-sibling::*/org/name)]"/>
        <!--
          <xsl:for-each select="person/org[not(. = ../preceding-sibling::*/org)]">
            <xsl:copy-of select="."/>
          </xsl:for-each>
        </xsl:variable>
        -->

        <record>
          <xsl:for-each select="person">
            <xsl:call-template name="handle-person">
              <xsl:with-param name="orgs" select="$orgs"/>
            </xsl:call-template>
          </xsl:for-each>

          <xsl:for-each select="$orgs">
            <xsl:call-template name="handle-organisation"/>
          </xsl:for-each>
        </record>
      </xsl:for-each>        

    </root>

  </xsl:template>


  <xsl:template name="handle-organisation">
    <xsl:element name="organisation">
      <xsl:attribute name="aff_no">
        <xsl:value-of select="position()"/>
      </xsl:attribute>
      <xsl:value-of select="./name"/>
    </xsl:element>
  </xsl:template>
  

  <xsl:template name="handle-person">
    <xsl:param name="orgs"/>

    <xsl:variable name="thisorg" select="org/name"/>

    <xsl:element name="person">
      <xsl:attribute name="aff_no">
        <xsl:for-each select="$orgs">
          <xsl:if test="name=$thisorg">
            <xsl:value-of select="position()"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:attribute> 
      <xsl:value-of select="./name"/>
    </xsl:element>
  </xsl:template>
    
</xsl:stylesheet>
