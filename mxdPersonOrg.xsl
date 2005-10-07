<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		version="1.0">

  <!-- 
       Somewhat tentative code to segregate <person>s and their
       affiliate <organisation>s to obey the MXD format. This is quite
       impossible for a variety of XSL restrictions you'll bump into,
       one by one, if you try it.

       We only take persons from the /ddf/document element, which in
       practice always is the object="main" doc. MXD doesn't allow for
       complex person data in for example the 'editor of the book in
       which this chapter appears'.
  -->

  <xsl:template name="element-person-organisation">

    <xsl:for-each select="document/person">
      <xsl:call-template name="handle-person"/>
    </xsl:for-each>
        
    <!--
        Hmm, problem: we'd like to avoid listing the same org twice,
        AND I'd like to include @id in the key. I have no idea how I
        could use a function like key() or concat() in a nodeset
        comparison- I suppose it can't be done. You could try:
        
        person/org[not(. = ../preceding-sibling::*/org)]
        
        ...but that will compare the value-of the nodes and that
        does not include @id.
        
        So for now we'll have to live with doubles. Alternatively we
        can use only the value-of <organisation/name> as key.
    -->
    <!--xsl:for-each select="document/person/organisation"-->
    <xsl:for-each select="document/person/organisation[not(. = ../preceding-sibling::*/organisation)]">
      <xsl:call-template name="handle-organisation"/>
    </xsl:for-each>

  </xsl:template>


  <xsl:template name="handle-organisation">
    <xsl:element name="organisation">
      <xsl:attribute name="org_role">oaf</xsl:attribute>
      <xsl:attribute name="aff_no">
        <xsl:value-of select="generate-id(key('orgkey', name))"/>
      </xsl:attribute>

      <name>
        <level1>
          <xsl:value-of select="./name/main"/>
        </level1>
        <level2>
          <xsl:value-of select="./name/sub"/>
        </level2>
        <level3>
          <xsl:value-of select="./name/sub2"/>
        </level3>
        <acronym>
          <xsl:value-of select="./name/FIXME"/>
        </acronym>
      </name>
      <xsl:if test="./@id">
        <!-- TODO: check this: maybe we should us the sub2code instead? -->
        <id id_type="loc_org">
          DTU-<xsl:value-of select="./@id"/>
        </id>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  

  <xsl:template name="handle-person">
    <xsl:element name="person">
      <xsl:attribute name="pers_role">
        <xsl:variable name="role" select="@role"/>
        <xsl:value-of select="$personRoleMapping/rule[in=$role]/out"/>
      </xsl:attribute>
      <xsl:attribute name="aff_no">
        <xsl:value-of select="generate-id(key('orgkey', organisation/name))"/>
      </xsl:attribute> 

      <name>
        <first><xsl:value-of select="./name/first"/></first>
        <last><xsl:value-of select="./name/last"/></last>
      </name>
      <xsl:if test="identifier[@type='cwisno']/text()">
        <id id_type="loc_per">
          DTU-<xsl:value-of select="identifier[@type='cwisno']"/>
        </id>
      </xsl:if>
      <!-- TODO: title and other elms -->

    </xsl:element>
  </xsl:template>
    
</xsl:stylesheet>
