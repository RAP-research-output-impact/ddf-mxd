<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:ext="http://exslt.org/common"
                version="1.0">

  <!-- 
       Somewhat frobbed code to segregate <person>s and their
       affiliate <organisation>s to obey the MXD format. 
       This is not as straightforward in XSL as you'd like it to be,
       unless you resort to the node-set() extension.

       We only take persons from the /ddf/document element, which in
       practice always is the object="main" doc. MXD doesn't allow for
       complex person data in for example the 'editor of the book in
       which this chapter appears'.
  -->

  <xsl:template name="element-person-organisation">

    <!-- I do not expect more than 1 org per person... -->
    <xsl:variable name="orgs" select="document/person/organisation[not(name=../preceding-sibling::*/organisation/name)]"/>

    <xsl:for-each select="document/person">
      <xsl:call-template name="handle-person">
        <xsl:with-param name="orgs" select="$orgs"/>
      </xsl:call-template>
    </xsl:for-each>
        
    <xsl:for-each select="$orgs">
      <xsl:call-template name="handle-organisation"/>
    </xsl:for-each>

  </xsl:template>


  <xsl:template name="handle-organisation">
    <xsl:element name="organisation">
      <xsl:attribute name="org_role">oaf</xsl:attribute>
      <xsl:attribute name="aff_no">
        <xsl:choose>
          <xsl:when test="normalize-space(./name)">
            <xsl:value-of select="position()"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>0</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <name>
        <level1>
          <xsl:choose>
            <xsl:when test="normalize-space(./name)">
              <xsl:value-of select="./name/main"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>[affiliation unknown]</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
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
    <xsl:param name="orgs"/>
    <xsl:element name="person">
      <xsl:attribute name="pers_role">
        <xsl:variable name="role" select="@role"/>
        <xsl:value-of select="$personRoleMapping/rule[in=$role]/out"/>
      </xsl:attribute>
      <xsl:variable name="thisorg" select="organisation/name"/>
      <xsl:attribute name="aff_no">
        <xsl:choose>
          <xsl:when test="not(normalize-space($thisorg))">
            <xsl:text>0</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="$orgs">
              <xsl:if test="name=$thisorg">
                <xsl:value-of select="position()"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
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
