<?xml version="1.0"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		version="1.0">

  <xsl:key name="orgkey" match="//person/organisation" use="name"/>
  <xsl:include href="mxdPersonOrg.xsl"/>
  <!--xsl:include href="mxdDocument.xsl"/-->

  <!-- Description:
       *   
       *      
       *  This stylesheet transforms the ORBIT research database XML 
       *  to the Danish national Exchange Format for Documents MXD
       * 
       *  Usage: sabcmd xsl2xsl.xsl records.xml result.xml
       *  where 
       *  xsl2xsl.xsl is the current stylesheet
       *  records.xml contains the orbit records             
       *  result.xml is the resulting xml in exchange format
       *
       * You can also use xsltproc, of course.
       *
  -->

  <!--
      TODO: things that must be done
      FIXME: problem that must be fixed to comply with MXD standard
      EXTRA: things that should be added when time allows
  -->

  <!-- Mapping files for specific element -->
  <xsl:variable name="docTypeMapping" select="document('docTypeMapping.xml')/*"/>
  <xsl:variable name="keyTypeMapping" select="document('keyTypeMapping.xml')/*"/>
  <xsl:variable name="pubStatusMapping" select="document('pubStatusMapping.xml')/*"/>
  <xsl:variable name="indicatorMapping" select="document('indicatorMapping.xml')/*"/>
  <xsl:variable name="langMapping" select="document('langMapping.xml')/*"/>
  <xsl:variable name="personRoleMapping" select="document('personRoleMapping.xml')/*"/>

  <!-- Some vars we need time and again, globally -->
  <xsl:variable name="ddftype" select="/ddf/@type"/>
  <xsl:variable name="ddfdoctype" select="/ddf/document/@type"/>

  <xsl:output method="xml" indent="yes" encoding="utf-8"/>

  <xsl:template match="/*">
    <xsl:element name="records">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>


  <xsl:template match="/ddf">

    <!-- for ddf_doc/@doc_type -->
    <xsl:variable name="mxdtype" 
                  select="$docTypeMapping/rule[in = $ddftype]/out/text()"/>
    <!-- for ddf_doc/publication/thingy: in_journal, in_book etc. -->
    <xsl:variable name="mxdpubelm" 
                  select="$docTypeMapping/rule[in = $ddftype and type = $ddfdoctype]/name"/>
    
    <!-- <ddf_doc> -->
    <xsl:element name="ddf_doc">
      <!-- begin attributes -->
      <xsl:attribute name="xmlns">
        <xsl:text>http://dtv.dk/mxd/xml/schemas/2005/08/12/</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="format_version">1.0.0</xsl:attribute>
      <xsl:attribute name="doc_type">
        <xsl:value-of select="$mxdtype"/>
      </xsl:attribute>
      <xsl:attribute name="doc_lang">
        <xsl:variable name="doclang" select="string(/ddf/document/language)"/>
        <xsl:value-of select="$langMapping/rule[in=$doclang]/out"/>
      </xsl:attribute>
      <xsl:attribute name="doc_year">
        <!-- 
             maybe FIXME: Orbit/ddf uses local, local2, local4 etc. in
             the cataloguing record, but (Zebra) export formats have
             the more sensible <local num="3"> construct. I'll presume
             the sensible one.
        -->
        <xsl:value-of select="normalize-space(document/local/field[@tag='Annual report year'])"/>
      </xsl:attribute>
      <xsl:attribute name="doc_review">
        <!--xsl:variable name="rev" select="concat('', document/indicator/review)"/-->
        <xsl:variable name="rev" select="string(document/indicator/review)"/>
        <xsl:value-of select="$indicatorMapping/rule[in=$rev]/out"/>
      </xsl:attribute>
      <xsl:attribute name="doc_level">
        <xsl:variable name="lev" select="document/indicator/level"/>
        <xsl:value-of select="$indicatorMapping/rule[in=$lev]/out"/>
      </xsl:attribute>
      <xsl:attribute name="rec_source">DTU</xsl:attribute>
      <xsl:attribute name="rec_id">dtu<xsl:value-of select="@id"/></xsl:attribute>
      <xsl:attribute name="rec_upd">
        <xsl:variable name="upd" select="/ddf/admin/system/updated"/>
        <xsl:value-of select="concat(
          substring($upd, 1, 4), '-',
          substring($upd, 5, 2), '-',
          substring($upd, 7, 2))" />
      </xsl:attribute>
      <!-- rec_status makes no sense without context -->
      <xsl:attribute name="rec_status">c</xsl:attribute>


      <!-- end attributes - do not insert elements before this line -->

      <!-- <title> -->
      <xsl:call-template name="element-title"/>

      <!-- <description> -->
      <xsl:call-template name="element-description"/>

      <!-- <person>, <organistion> repeat -->
      <!-- this is in mxdPersonOrg.xsl -->
      <xsl:call-template name="element-person-organisation"/>

      <!-- <project> repeats -->
      <xsl:call-template name="element-project"/>

      <!-- <event> repeats -->
      <xsl:call-template name="element-event"/>

      <!-- <local_field> repeats -->
      <xsl:call-template name="element-local_field"/>

      <!-- <publication> -->
      <xsl:call-template name="element-publication"/>

    </xsl:element> <!-- </ddf_doc> -->
  </xsl:template> <!-- match=/ddf -->


  <xsl:template match="* | @*">
    <!-- Handling <xsl:value-of select="name()"/> -->
    <xsl:apply-templates/>
  </xsl:template>

  <!-- end of match-templates -->

  <!-- ******************************************************************* -->

  <!-- ddf_doc/* element templates: title, description, project, event -->
  <!-- all of these have /ddf as their context node -->

  <xsl:template name="element-title">
    <xsl:element name="title">
      <xsl:element name="original">
        <main><xsl:value-of select="document/title/main"/></main>
        <sub><xsl:value-of select="document/title/sub"/></sub>
        <!-- EXTRA: part -->
      </xsl:element>
    </xsl:element> <!-- </title> -->
  </xsl:template>


  <xsl:template name="element-description">

    <xsl:element name="description">
      <xsl:for-each select="document/abstract">
        <xsl:variable name="lang" select="@lang"/>
        <xsl:element name="abstract">
          <xsl:attribute name="xml:lang">
            <xsl:value-of select="$langMapping/rule[in=$lang]/out"/>
          </xsl:attribute>
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:for-each>      

      <xsl:for-each select="document/note">
        <xsl:variable name="lang" select="@lang"/>
        <xsl:element name="note">
          <xsl:attribute name="xml:lang">
            <xsl:value-of select="$langMapping/rule[in=$lang]/out"/>
          </xsl:attribute>
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:for-each>
      <!-- TODO: DDF hardcopy (not in Orbit) ==> <note> -->
     
      <!-- TODO: <thesis> -->
    
      <xsl:element name="subject">
        <!-- neither keywords nor classes have a language. -->

        <!-- virtually all keywords in Orbit are 'free', a few are 'local' -->
        <xsl:for-each select="document/keyword">
          <xsl:variable name="type" select="@type"/>          
          <xsl:element name="keyword">
            <xsl:attribute name="key_type">
              <xsl:value-of select="$keyTypeMapping/rule[in=$type]/out"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
          </xsl:element>
        </xsl:for-each>

        <!-- class is seldom used in Orbit; only @type=local is in use -->
        <xsl:for-each select="document/class">
          <xsl:variable name="type" select="@type"/>
          <xsl:element name="class">
            <xsl:attribute name="class_type">
              <xsl:value-of select="$keyTypeMapping/rule[in=$type]/out"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>

    </xsl:element> <!-- </description> -->
  </xsl:template>


  <xsl:template name="element-project">
    <xsl:if test="//project">  <!-- or so -->
      <xsl:element name="project">
        <!-- TODO later: no projects are used in Orbit literature -->
      </xsl:element> <!-- </project> -->
    </xsl:if>
  </xsl:template>


  <xsl:template name="element-event">
    <xsl:if test="document/event">
      <xsl:element name="event">
        <!-- Let's just use 'presented at' here -->
        <xsl:attribute name="event_role">ep</xsl:attribute>

        <xsl:variable name="event" select="document/event"/>
      
        <title>
          <full>
            <xsl:value-of select="$event/name/main"/>
            <xsl:if test="$event/name/sub">
              : <xsl:value-of select="$event/name/sub"/>
            </xsl:if>
          </full>
          <acronym>
            <xsl:value-of select="$event/name/acronym"/>
          </acronym>
          <number>
            <xsl:value-of select="$event/name/number"/>
          </number>
        </title>
        <dates>
          <!-- We only have 1 year -->
          <start>
            <xsl:value-of select="$event/dates/year"/>
          </start>
          <end>
            <xsl:value-of select="$event/dates/year"/>
          </end>
        </dates>
        <place>
          <xsl:value-of select="$event/place"/>
        </place>
        <uri>
          <xsl:value-of select="document/www/url"/>
        </uri>

      </xsl:element> <!-- </event> -->
    </xsl:if>
  </xsl:template>


  <xsl:template name="element-local_field">
    <!-- 
         Orbit exported local fields are of this structure, which
         incidentally translates directly to MXD:

         <local>
           <field num="3" tag="Internal note" type="1" tagsea="internalnote">
              hest
           </field>
         </local>

         Remember that the catalogued format uses local, local2,
         local3 etc. to overcome restrictions in Metatoo- we assume
         the above "loopable" construct here.
    -->
    <xsl:for-each select="document/local/field">
      <xsl:element name="local_field">
        <xsl:attribute name="tag_type">
          <xsl:value-of select="@type"/>
        </xsl:attribute>
        <xsl:if test="@lang">
          <xsl:variable name="lang" select="@lang"/>
          <xsl:attribute name="xml:lang">
            <xsl:value-of select="$langMapping/rule[in=$lang]/out"/>
          </xsl:attribute>
        </xsl:if>

        <code>
          <!-- Make this 0 if @num is undefined -->
          <xsl:value-of select="number(concat('0', @num))"/>
        </code>
        <data>
          <xsl:value-of select="."/>
        </data>
      </xsl:element>
    </xsl:for-each>

  </xsl:template>

  <xsl:template name="element-publication">
    <xsl:variable name="docelm" 
                  select="$docTypeMapping/rule[in = $ddftype and type = $ddfdoctype]/name"/>
    <xsl:variable name="auxdoc" select="document/document[@object='aux']"/>

    <xsl:element name="publication">
      <!-- <in_journal|in_book|in_report|book|report|patent|inetpub|other> -->
      <xsl:element name="{$docelm}">
        <xsl:variable name="pubstatus"> <!-- E.g. unpublished, published -->
          <xsl:value-of select="document/@status"/>
        </xsl:variable>
        <xsl:attribute name="pub_status">
          <xsl:value-of select="$pubStatusMapping/rule[in = $pubstatus]/out"/>
        </xsl:attribute>

        <!-- 
             The various <document> elements contain a small truckload
             of subelements, but they only overlap partly between each
             other and are only 1 level deep.
        -->

        <xsl:choose>
          <xsl:when test="$docelm = 'in_journal'">
            <title>
              <xsl:value-of select="$auxdoc/title/main"/>
              <xsl:if test="$auxdoc/title/sub">
                : <xsl:value-of select="$auxdoc/title/sub"/>
              </xsl:if>
            </title>
            <issn>
              <xsl:call-template name="subst">
                <xsl:with-param name="in" select="$auxdoc/identifier[@type='ISSN']"/>
                <xsl:with-param name="from" select="'-'"/>
                <xsl:with-param name="to" select="''"/>
              </xsl:call-template>
            </issn>
            <year><xsl:value-of select="$auxdoc/@year"/></year>
            <vol><xsl:value-of select="$auxdoc/@vol"/></vol>
            <issue><xsl:value-of select="$auxdoc/@issue"/></issue>
            <pages><xsl:value-of select="$auxdoc/@pages"/></pages>
            <!-- TODO: what's this? <paperid></paperid> -->
            <!-- <doi></doi> -->
            <uri>
              <xsl:value-of select="document/www/url"/> <!-- NOT from aux doc! -->
            </uri>
          </xsl:when>

          <xsl:when test="$docelm = 'in_book'">
            <title>
              <xsl:value-of select="$auxdoc/title/main"/>
              <xsl:if test="$auxdoc/title/sub">
                : <xsl:value-of select="$auxdoc/title/sub"/>
              </xsl:if>
            </title>
            <!-- part is ambiguous; should we indeed use series/part? -->
            <part>
              <xsl:value-of select="$auxdoc/document[@role='in series']/title/part"/>
            </part>
            <edition>
              <xsl:value-of select="$auxdoc/imprint/edition"/>
            </edition>

            <!--
                Maybe FIXME: In Orbit, the superpublication may have
                both authors and editors- but MXD only caters for
                editors. Authors would get lost, but I don't think
                such source publications normally have any.
            -->
            
            <xsl:for-each select="$auxdoc/person[@role='editor']">
              <!-- 
                   Substitute the full name(s); MXD does not allow
                   further structure or a reference to a <person>
                   structure here.
              -->
              <editor>
                <xsl:value-of select="name/first"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="name/last"/>
              </editor>
            </xsl:for-each>
            
            <isbn>
              <!-- no joy
              <xsl:call-template name="replace-substring">
                <xsl:with-param name="string" select="$auxdoc/identifier[@type='ISBN']"/>
                <xsl:with-param name="substring" select="'-'"/>
                <xsl:with-param name="replacement" select="''"/>
              </xsl:call-template>
              -->
              <xsl:call-template name="subst">
                <xsl:with-param name="in" select="$auxdoc/identifier[@type='ISBN']"/>
                <xsl:with-param name="from" select="'-'"/>
                <xsl:with-param name="to" select="''"/>
              </xsl:call-template>
            </isbn>
            <place>
              <xsl:value-of select="$auxdoc/imprint/place"/>
            </place>
            <publisher>
              <xsl:value-of select="$auxdoc/imprint/publisher"/>
            </publisher>
            <year>
              <xsl:value-of select="$auxdoc/imprint/year"/>
            </year>
            <pages>
               <xsl:value-of select="$auxdoc/imprint/pages"/>
            </pages>
            <series>
              <xsl:value-of select="$auxdoc/document[@role='in series']/title/main"/>
            </series>
            <uri>
              <xsl:value-of select="document/www/url"/> <!-- NOT from aux doc! -->
            </uri>
          </xsl:when>

          <xsl:when test="$docelm = 'in_report'">
            <!-- Orbit has no chapter- or paper-in-report AFAIK. -->
            <title></title>
            <editor></editor>
            <isbn></isbn>
            <rep_no></rep_no>
            <place></place>
            <publisher></publisher>
            <year></year>
            <pages></pages>
            <uri></uri>
          </xsl:when>

          <xsl:when test="$docelm = 'book'">
            <edition>
              <xsl:value-of select="document/imprint/edition"/>
            </edition>
            <isbn>
              <xsl:call-template name="subst">
                <xsl:with-param name="in" select="document/identifier[@type='ISBN']"/>
                <xsl:with-param name="from" select="'-'"/>
                <xsl:with-param name="to" select="''"/>
              </xsl:call-template>
            </isbn>
            <place>
              <xsl:value-of select="document/imprint/place"/>
            </place>
            <publisher>
              <xsl:value-of select="document/imprint/publisher"/>
            </publisher>
            <year>
              <xsl:value-of select="document/imprint/year"/>
            </year>
            <pages>
               <xsl:value-of select="document/imprint/pages"/>
            </pages>
            <series>
              <xsl:value-of select="$auxdoc[@role='in series']/title/main"/>
            </series>
            <uri>
              <xsl:value-of select="document/www/url"/>
            </uri>
          </xsl:when>

          <xsl:when test="$docelm = 'report'">
            <isbn>
              <xsl:call-template name="subst">
                <xsl:with-param name="in" select="document/identifier[@type='ISBN']"/>
                <xsl:with-param name="from" select="'-'"/>
                <xsl:with-param name="to" select="''"/>
              </xsl:call-template>
            </isbn>
            <rep_no>
            </rep_no>
            <place>
              <xsl:value-of select="document/imprint/place"/>
            </place>
            <publisher>
              <xsl:value-of select="document/imprint/publisher"/>
            </publisher>
            <year>
              <xsl:value-of select="document/imprint/year"/>
            </year>
            <pages>
               <xsl:value-of select="document/imprint/pages"/>
            </pages>
            <uri>
              <xsl:value-of select="document/www/url"/>
            </uri>
          </xsl:when>

          <xsl:when test="$docelm = 'patent'">
            <!--TODO -->
            <country></country>
            <ipc></ipc>
            <number></number>
            <date></date>
            <uri></uri>
          </xsl:when>

          <xsl:when test="$docelm = 'inetpub'">
            <!--maybe TODO -->
            <text></text>
            <uri></uri>
          </xsl:when>
        </xsl:choose>

      </xsl:element> <!-- doc-specific element -->
    </xsl:element> <!-- </publication> -->
  </xsl:template> <!-- element-pubication -->


  <!-- utility templates -->

  <xsl:template name="replace-substring">
    <!-- This one doesn't quite work (see isbn). Use subst instead. -->
    <xsl:param name="original"/>
    <xsl:param name="substring"/>
    <xsl:param name="replacement" select="''"/>

    <xsl:variable name="first">
      <xsl:choose>
	<xsl:when test="contains($original, $substring)">
	   <xsl:value-of select="substring-before($original,$substring)"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$original"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="middle">
      <xsl:choose>
	<xsl:when test="contains($original, $substring)">
	   <xsl:value-of select="$replacement"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text></xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="last">
      <xsl:choose>
	<xsl:when test="contains($original, $substring)">
	  <xsl:choose>
	    <xsl:when test="contains(substring-after($original,$substring), $substring)">
	      <xsl:call-template name="replace-substring">
		<xsl:with-param name="original" select="substring-after($original, $substring)"/>
		<xsl:with-param name="substring" select="$substring"/>
		<xsl:with-param name="replacement" select="$replacement"/>
	      </xsl:call-template>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="substring-after($original, $substring)"/>
	    </xsl:otherwise>
	  </xsl:choose>
	   <xsl:value-of select="$replacement"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text></xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="concat($first,$middle,$last)"/>
  </xsl:template> <!-- replace-substring -->


  <xsl:template name="subst">
    <!-- Do not specify an empty thing in $from, or Sablotron will freak out -->
    <xsl:param name="in"/>
    <xsl:param name="from"/>
    <xsl:param name="to"/>
    <xsl:choose>
      <xsl:when test="contains($in,$from)">
        <xsl:value-of select="concat(substring-before($in, $from), $to)"/>
        <xsl:call-template name="subst">
          <xsl:with-param name="in" select="substring-after($in, $from)"/>
          <xsl:with-param name="from" select="$from"/>
          <xsl:with-param name="to" select="$to"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$in"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>

