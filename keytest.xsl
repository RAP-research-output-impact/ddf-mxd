<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		version="1.0">

  <xsl:output method="xml" indent="yes" encoding="utf-8"/>

  <xsl:key name="orgkey" match="//person/org" use="concat(@id,name)"/>
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
          
          <!--
              Hmm, problem: we'd like to avoid listing the same org
              twice. I have no idea how I could use a function like
              key() or concat() in a nodeset comparison- I suppose it
              can't be done. You could try:

              person/org[not(. = ../preceding-sibling::*/org)]

              ...but that will compare the value-of the nodes and that
              does not include @id.

              So for now we'll have to live with doubles.
          -->
          <!--xsl:for-each select="person/org[not(. = ../preceding-sibling::*/org)]"-->
          <xsl:for-each select="person/org">
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
      <!--xsl:attribute name="aff_no"><xsl:value-of select="$element/@id"/></xsl:attribute-->
      <xsl:attribute name="aff_no">
        <xsl:value-of select="generate-id(key('orgkey', concat(@id, name)))"/>
      </xsl:attribute>
      <xsl:value-of select="./name"/>
    </xsl:element>
  </xsl:template>
  

  <xsl:template name="handle-person">
    <xsl:param name="element"/>
    <xsl:element name="person">
      <xsl:attribute name="aff_no">
        <xsl:value-of select="generate-id(key('orgkey', concat(org/@id, org/name)))"/>
      </xsl:attribute> 
      <xsl:value-of select="./name"/>
    </xsl:element>
  </xsl:template>
    
</xsl:stylesheet>
