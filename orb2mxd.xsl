<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:fit="http://toolxite.net/ns/metatoo/fit/"
                xmlns:ext="http://exslt.org/common"
                xmlns:datetime="http://exslt.org/dates-and-times"
                xmlns:func="http://exslt.org/functions"
                xmlns:my="http://www.dtv.dk/ns"
                xmlns:str="http://exslt.org/strings"
                xmlns:re="http://exslt.org/regular-expressions"
                extension-element-prefixes="ext func str my re">

  <!-- Description:

       This stylesheet transforms the ORBIT research database XML 
       to the Danish national Exchange Format for Documents MXD
        
       Usage: sabcmd xsl2xsl.xsl records.xml result.xml
       where 
       xsl2xsl.xsl is the current stylesheet
       records.xml contains the orbit records (with /ddf as root and fit: authorities expanded)
       result.xml is the resulting xml in exchange format

       You can also use xsltproc, but 4xslt doesn't like me creating
       an xmlns attribute, so I'll have to figure that one out.

       BUGS

       Metatoo inserts spurious empty elements (event, person) if a
       single attribute in its input form has a default, leading this
       script to think that there is something where there's nothing.
  -->

  <!--
      TODO: things that must be done
      FIXME: problem that must be fixed to comply with MXD standard
      EXTRA: things that should be added when time allows
  -->

  <!-- Version numbers -->
  <xsl:variable name="schemaversion">1.2</xsl:variable>
  <xsl:variable name="formatversion">1.2.0</xsl:variable>
  <!-- if you want absolute includes, fill in a URL ending in a slash here, like
       http://urbit.cvt.dk/orbit2mxd/1.2.0-2/abs/ -->
  <xsl:variable name="baseurl"></xsl:variable>

  <!-- Mapping files for specific element -->
  <xsl:variable name="config"            select="document(concat($baseurl, 'config.xml'))/*"/>
  <xsl:variable name="docTypeMapping"    select="document(concat($baseurl, 'docTypeMapping.xml'))/*"/>
  <xsl:variable name="keyTypeMapping"    select="document(concat($baseurl, 'keyTypeMapping.xml'))/*"/>
  <xsl:variable name="pubStatusMapping"  select="document(concat($baseurl, 'pubStatusMapping.xml'))/*"/>
  <xsl:variable name="indicatorMapping"  select="document(concat($baseurl, 'indicatorMapping.xml'))/*"/>
  <xsl:variable name="langMapping"       select="document(concat($baseurl, 'langMapping.xml'))/*"/>
  <xsl:variable name="personRoleMapping" select="document(concat($baseurl, 'personRoleMapping.xml'))/*"/>

  <!-- Some vars we need time and again, globally -->
  <xsl:variable name="ddftype" select="/ddf/@type"/>
  <xsl:variable name="ddfdoctype" select="/ddf/document/@type"/>

  <!-- 
       I'd like to define mxdtype and mxdpubelm globally here from
       $doctypeMapping, something which works in older Libxslt and
       Sablotron, but not any more in newer Libxslt. So We'll have to
       define these inside the toplevel template and transfer them to
       other templates with xsl-param. Sigh.
  -->

  <xsl:output method="xml" indent="yes" encoding="utf-8"/>

  <xsl:variable name="datasource">
    <xsl:choose>
      <xsl:when test="starts-with(/ddf/@user_group, 'fak')">fak</xsl:when>
      <xsl:otherwise>dtu</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="/ddf">
    <!-- optionally cast out non-DTU; personal records are already
         omitted in SQL -->
    <xsl:if test="$datasource='dtu' and $config/include-department-records = 0">
      <xsl:if test="(/ddf/document/@status and /ddf/document/@status != 'published')
                    or $ddfdoctype='master thesis' or $ddfdoctype='bachelor thesis'
                    or $ddfdoctype='slide show' or $ddfdoctype='unpublished papers'
                    or $ddfdoctype='lecture'
                    or starts-with(/ddf/document/@fit:authority_type_eng, '[')">
        <xsl:message terminate="yes">Record <xsl:value-of select="/ddf/@id"/>: not a DTU public record</xsl:message>
      </xsl:if>
    </xsl:if>

    <xsl:variable name="whichmap" 
                  select="$docTypeMapping/rule[in = $ddftype and 
                          (type = '' or type = $ddfdoctype)]"/>

    <!-- for ddf_doc/@doc_type -->
    <xsl:variable name="mxdtype" select="$whichmap/out/text()"/>

    <!-- for ddf_doc/publication/thingy: in_journal, in_book etc. -->
    <xsl:variable name="premxdpubelm" select="$whichmap/name/text()"/>
    <xsl:variable name="mxdpubelm">
      <xsl:choose>
        <xsl:when test="$premxdpubelm"><xsl:value-of select="$premxdpubelm"/></xsl:when>
        <xsl:otherwise>
          <xsl:message terminate="yes">Record <xsl:value-of select="/ddf/@id"/>: could not establish pubelm</xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- handy note: xsltproc sends message to STDERR and sets return
         code != 0 when terminated like this -->

    <!-- <ddf_doc> -->

    <xsl:element name="ddf_doc">
      <!-- begin attributes -->
      <!-- Actually. it's forbidden to create an xmlns attrib, but if
           you use the element/@namespace attr, all nested elements
           are created in the empty namespace - hateful piece of crap -->
      <xsl:attribute name="xmlns">
        <xsl:text>http://mx.forskningsdatabasen.dk/ns/mxd/</xsl:text>
        <xsl:value-of select="$schemaversion"/>
      </xsl:attribute>
      <xsl:attribute name="format_version">
        <xsl:value-of select="$formatversion"/>
      </xsl:attribute>
      <xsl:attribute name="doc_type">
        <xsl:value-of select="$mxdtype"/>
      </xsl:attribute>
      <xsl:attribute name="doc_lang">
        <xsl:variable name="doclang" select="string(/ddf/document/language)"/>
        <xsl:value-of select="$langMapping/rule[in=$doclang]/out"/>
      </xsl:attribute>
      <xsl:attribute name="rec_created">
        <xsl:value-of select="substring(fit:admin/fit:system/fit:created,1,10)"/>
      </xsl:attribute>
      <xsl:attribute name="doc_year">
        <!-- 
             maybe FIXME: Orbit/ddf uses local, local2, local4 etc. in
             the cataloguing record, but (Zebra) export formats have
             the more sensible <local num="3"> construct. I'll presume
             the sensible one.

             Any which way, Metatoo tends to export them even without
             sensible text content.
        -->
        <xsl:choose>
          <xsl:when test="document/local/field[@tag='Annual report year']">
            <xsl:value-of select="normalize-space(document/local/field[@tag='Annual report year'])"/>
          </xsl:when>
          <xsl:when test="/ddf/document/event/dates/year">
            <!-- FIXME records without annual report year must be fixed in Orbit -->
            <!-- this workaround works fairly well for conference types -->
            <xsl:value-of select="normalize-space(/ddf/document/event/dates/year)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>1900</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="doc_review">
        <xsl:variable name="rev" select="string(document/indicator/review)"/>
        <xsl:value-of select="$indicatorMapping/rule[in=$rev]/out"/>
      </xsl:attribute>
      <xsl:attribute name="doc_level">
        <xsl:variable name="lev" select="string(document/indicator/level)"/>
        <xsl:value-of select="$indicatorMapping/rule[in=$lev]/out"/>
      </xsl:attribute>
      <xsl:attribute name="rec_source">
        <xsl:value-of select="$datasource"/>
      </xsl:attribute>
      <xsl:attribute name="rec_id"><xsl:value-of select="@id"/></xsl:attribute>
      <!-- rec_upd holds a fix for MySQL's date format change in 4.1 -->
      <xsl:attribute name="rec_upd">
        <xsl:variable name="upd" select="/ddf/fit:admin/fit:system/fit:updated"/>
        <xsl:choose>
          <xsl:when test="contains ($upd, ' ')">
            <xsl:value-of select="substring-before ($upd, ' ')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat(
               substring($upd, 1, 4), '-',
               substring($upd, 5, 2), '-',
               substring($upd, 7, 2))" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <!-- rec_status makes no sense without context -->
      <xsl:attribute name="rec_status">c</xsl:attribute>

      <!-- end attributes - do not insert elements before this line -->

      <!-- <title> -->
      <xsl:call-template name="element-title"/>

      <!-- <description> -->
      <xsl:call-template name="element-description"/>

      <!-- <person>, <organistion> repeat -->
      <xsl:call-template name="element-person-organisation"/>

      <!-- <project> repeats -->
      <xsl:call-template name="element-project"/>

      <!-- <event> repeats -->
      <xsl:call-template name="element-event"/>

      <!-- <local_field> repeats -->
      <xsl:call-template name="element-local_field"/>

      <!-- <publication> -->
      <xsl:call-template name="element-publication">
        <xsl:with-param name="mxdpubelm" select="$mxdpubelm"/>
        <xsl:with-param name="mxdtype" select="$mxdtype"/>
      </xsl:call-template>

    </xsl:element> <!-- </ddf_doc> -->
  </xsl:template> <!-- match=/ddf -->


  <xsl:template match="* | @*">
    <!-- never reached. --> 
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
        <xsl:variable name="lang" select="string(@lang)"/>
        <xsl:element name="abstract">
          <xsl:attribute name="xml:lang">
            <xsl:value-of select="$langMapping/rule[in=$lang]/out"/>
          </xsl:attribute>
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:for-each>      

      <xsl:for-each select="document/note">
        <xsl:variable name="lang" select="string(@lang)"/>
        <xsl:element name="note">
          <xsl:attribute name="xml:lang">
            <xsl:value-of select="$langMapping/rule[in=$lang]/out"/>
          </xsl:attribute>
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:for-each>
     
      <!-- maybe TODO: <thesis>. however, there is no explicit
           awarding institution in Orbit, so for now I won't bother. -->
      <!--
      <xsl:if test="starts-with($mxdtype, 'dt')">
        <xsl:element name="thesis">
        </xsl:element>
      </xsl:if>
      -->

      <xsl:element name="subject">
        <!-- neither keywords nor classes have a language. -->

        <!-- virtually all keywords in Orbit are 'free', a few are 'local' -->
        <xsl:for-each select="document/keyword">
          <xsl:variable name="type" select="string(@type)"/>          
          <xsl:element name="keyword">
            <xsl:attribute name="key_type">
              <xsl:value-of select="$keyTypeMapping/rule[in=$type]/out"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
          </xsl:element>
        </xsl:for-each>

        <!-- class is seldom used in Orbit; only @type=local is in use -->
        <xsl:for-each select="document/class">
          <xsl:variable name="type" select="string(@type)"/>
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
        <!-- maybe TODO: no projects are used in Orbit literature -->
      </xsl:element> <!-- </project> -->
    </xsl:if>
  </xsl:template>


  <xsl:template name="element-event">
    <xsl:if test="normalize-space(document/event) != ''">
      <xsl:element name="event">
        <!-- Let's just use 'presented at' here -->
        <xsl:attribute name="event_role">ep</xsl:attribute>

        <xsl:variable name="event" select="document/event"/>
      
        <title>
          <full>
            <xsl:choose>
              <xsl:when test="$event/name/main">
                <xsl:value-of select="$event/name/main"/>
              </xsl:when>
              <!-- FIXME missing event titles must be fixed in Orbit -->
              <xsl:when test="($ddftype = 'lalc' or $ddftype = 'lbralc' or $ddftype='lc')
                              and document/document/title/main">
                <!-- hopefully the aux title is the conference title-->
                [<xsl:value-of select="document/document/title/main"/>]
              </xsl:when>
            </xsl:choose>
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

         Metatoo tends to export <local> even without sensible text
         content.

    -->
    <xsl:for-each select="document/local/field">
      <xsl:if test="normalize-space(./text())">
        <xsl:element name="local_field">
          <xsl:attribute name="tag_type">
            <xsl:value-of select="@type"/>
          </xsl:attribute>
          <xsl:if test="@lang">
            <xsl:variable name="lang" select="string(@lang)"/>
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
      </xsl:if>
    </xsl:for-each>
  </xsl:template>


  <xsl:template name="element-publication">
    <xsl:param name="mxdpubelm"/>
    <xsl:param name="mxdtype"/>

    <xsl:variable name="auxdoc" select="document/document[@object='aux']"/>

    <xsl:element name="publication">
      <!-- <in_journal|in_book|in_report|book|report|patent|inetpub|digital_object|other> -->
      <xsl:element name="{$mxdpubelm}">
        <xsl:variable name="pubstatus"> <!-- E.g. unpublished, published -->
          <xsl:value-of select="document/@status"/>
        </xsl:variable>
        <xsl:if test="$mxdpubelm != 'other'">
          <xsl:attribute name="pub_status">
            <xsl:value-of select="$pubStatusMapping/rule[in = $pubstatus]/out"/>
          </xsl:attribute>
        </xsl:if>

        <!-- 
             The various <document> elements contain a small truckload
             of subelements, but they only overlap partly between each
             other and are only 1 level deep.
        -->

        <xsl:choose>
          <xsl:when test="$mxdpubelm = 'in_journal'">
            <title>
              <xsl:choose>
                <xsl:when test="$auxdoc/title/main">
                  <xsl:value-of select="$auxdoc/title/main"/>
                </xsl:when>
                <xsl:otherwise>
                  <!-- FIXME in Orbit -->
                  [source title could not be established]
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="$auxdoc/title/sub">
                : <xsl:value-of select="$auxdoc/title/sub"/>
              </xsl:if>
            </title>
            <!-- FIXME ISSN must be fixed in Orbit -->
            <issn>
              <xsl:value-of select="my:replace($auxdoc/identifier[@type='ISSN'], '-', '')"/>
            </issn>
            <year><xsl:value-of select="$auxdoc/@year"/></year>
            <vol><xsl:value-of select="$auxdoc/@vol"/></vol>
            <issue><xsl:value-of select="$auxdoc/@issue"/></issue>
            <pages><xsl:value-of select="my:cleanpages($auxdoc/@pages)"/></pages>
            <!-- TODO: what's this? <paperid></paperid> -->
            <!-- <doi></doi> -->
            <uri>
              <xsl:value-of select="document/www/url"/> <!-- NOT from aux doc! -->
            </uri>
          </xsl:when>  <!-- in_journal -->

          <xsl:when test="$mxdpubelm = 'in_book'">
            <title>
              <!-- FIXME: esp. conferences that lack an aux title must
                   be fixed in Orbit. We'll take the event name as
                   book title for now. -->
              <xsl:choose>
                <xsl:when test="$auxdoc/title/main">
                  <xsl:value-of select="$auxdoc/title/main"/>
                  <xsl:if test="$auxdoc/title/sub">
                    : <xsl:value-of select="$auxdoc/title/sub"/>
                  </xsl:if>
                </xsl:when>
                <xsl:when test="($ddftype = 'lalc' or $ddftype = 'lbralc' or $ddftype='lc')
                                and /ddf/document/event/name">
                  [<xsl:value-of select="/ddf/document/event/name/main"/>]
                </xsl:when>
                <xsl:otherwise>
                  <!-- FIXME in Orbit -->
                  [a source title could not be established]
                </xsl:otherwise>
              </xsl:choose>
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
            
            <xsl:if test="$auxdoc/person[@role='editor']">
              <editor>
                <xsl:for-each select="$auxdoc/person[@role='editor']">
                  <!-- 
                       Substitute the full name(s); MXD does not allow
                       further structure or a reference to a <person>
                       structure here.
                  -->
                  <xsl:value-of select="name/first"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="name/last"/>
                  <xsl:if test="not(last())">
                    <xsl:text>; </xsl:text>
                  </xsl:if>
                </xsl:for-each>
              </editor>
            </xsl:if>
            
            <isbn>
              <xsl:value-of select="my:replace($auxdoc/identifier[@type='ISBN'], '-', '')"/>
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
              <xsl:value-of select="my:cleanpages($auxdoc/@pages)"/>
              <!--xsl:value-of select="$auxdoc/imprint/pages"/-->
            </pages>
            <series>
              <xsl:value-of select="$auxdoc/document[@role='in series']/title/main"/>
            </series>
            <uri>
              <xsl:value-of select="document/www/url"/> <!-- NOT from aux doc! -->
            </uri>
          </xsl:when>   <!-- in_book -->

          <xsl:when test="$mxdpubelm = 'in_report'">
            <!-- Orbit has no chapter- or paper-in-report -->
            <title></title>
            <editor></editor>
            <isbn></isbn>
            <rep_no></rep_no>
            <place></place>
            <publisher></publisher>
            <year></year>
            <pages></pages>
            <uri></uri>
          </xsl:when>  <!-- in_report -->

          <xsl:when test="$mxdpubelm = 'book'">
            <!-- FIXME some records in Orbit seem to lack any of imprint or aux document,
            leading to an empty <book> which does not validate -->
            <edition>
              <xsl:value-of select="document/imprint/edition"/>
            </edition>
            <isbn>
              <!-- FIXME ISBN must be fixed in Orbit -->
              <xsl:value-of select="my:replace(document/identifier[@type='ISBN'], '-', '')"/>
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
          </xsl:when> <!-- book -->

          <xsl:when test="$mxdpubelm = 'report'">
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
          </xsl:when>  <!-- report -->

          <xsl:when test="$mxdpubelm = 'patent'">
            <!--TODO -->
            <country>
              <!-- seldom used -->
              <xsl:value-of select="document/patent/country"/>
            </country>
            <ipc></ipc>
            <number>
              <xsl:value-of select="document/patent/number"/>
            </number>
            <!-- 200605 there's either a date or a year here, think
                 date's most recent; its format is freeform :-( -->
            <date>
              <xsl:if test="document/patent/year">
                <xsl:value-of select="document/patent/year"/>
              </xsl:if>
              <xsl:if test="document/patent/date">
                <xsl:value-of select="document/patent/date"/>
              </xsl:if>
            </date>
            <uri></uri>
          </xsl:when>  <!-- patent -->

          <xsl:when test="$mxdpubelm = 'inetpub'">
            <!--maybe TODO later -->
            <text></text>
            <uri></uri>
          </xsl:when>  <!-- inetpub -->

          <xsl:when test="$mxdpubelm = 'other'">
            <!-- FIXME: This is to get rid of conference
                 abstracts/posters for now. -->
            <xsl:text>&#160;</xsl:text>
            <!--
              <xsl:text>Origin: </xsl:text>
              <xsl:text>ddftype=</xsl:text>
              <xsl:value-of select="$ddftype"/>
              <xsl:text>; ddfdoctype=</xsl:text>
              <xsl:value-of select="$ddfdoctype"/>
              <xsl:text>; ddfauxtype=</xsl:text>
              <xsl:value-of select="/ddf/document/document/@type"/>
            -->
          </xsl:when> <!-- other -->
        </xsl:choose>
      </xsl:element> <!-- doc-specific element -->

      <!--
          <object> in Orbit-ddf is always present even if it
          contains no sensible data. It can contain empty
          subelements (like <file>) which nonetheless can hold
          significant attributes. Therefore it causes all sorts of
          problems with filterempty.xsl, so we test it explicitly
          here.
      -->

      <xsl:for-each select="/ddf/document/object[version/file]">
        <xsl:variable name="ddfrole">
          <xsl:choose>
            <xsl:when test="version/description='preprint'">pre</xsl:when>
            <xsl:when test="version/description='postprint'">pos</xsl:when>
            <xsl:when test="version/description='published'">pub</xsl:when>
            <xsl:otherwise>oth</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ddfaccess">
          <xsl:choose>
            <xsl:when test="version/@access='all'">oa</xsl:when>
            <xsl:when test="version/@access='campus'">ca</xsl:when>
            <xsl:when test="version/@access='owner'">na</xsl:when>
          </xsl:choose>
        </xsl:variable>

        <xsl:element name="digital_object">
          <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
          <xsl:attribute name="role"><xsl:value-of select="$ddfrole"/></xsl:attribute>
          <xsl:attribute name="access"><xsl:value-of select="$ddfaccess"/></xsl:attribute>
          <!--<xsl:element name="description"><xsl:value-of select=""/></xsl:element>-->
          <xsl:element name="file">
            <!--<xsl:attribute name="lang"><xsl:value-of select=""/></xsl:attribute>-->
            <xsl:attribute name="size"><xsl:value-of select="version/file/@size"/></xsl:attribute>
            <xsl:attribute name="mime_type"><xsl:value-of select="version/file/@mime_type"/></xsl:attribute>
            <!-- unix2iso seems to have gone broken somewhere. No time to fix it. -->
            <xsl:attribute name="timestamp">1970-01-01T00:00:00</xsl:attribute>
            <xsl:attribute name="filename"><xsl:value-of select="version/file/@filename"/></xsl:attribute>
            <!-- 1.2.0.1 forge description or filterempty will eat the whole file element -->
            <xsl:element name="description"><xsl:value-of select="version/file/@filename"/></xsl:element>
          </xsl:element>
          <!-- http://orbit.dtu.dk/getResource?recordId=220328&objectId=1&versionId=1 -->
          <!-- http://forskningsdatabasen.fak.dk/insight_fak/getResource?recordId=456&objectId=1&versionId=1 -->
          <xsl:variable name="objuri">
            <xsl:choose>
              <xsl:when test="$datasource='dtu'">http://orbit.dtu.dk/getResource?</xsl:when>
              <xsl:otherwise>http://forskningsdatabasen.fak.dk/insight_fak/getResource?</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:element name="uri"><xsl:value-of select="concat($objuri, 'recordId=', /ddf/@id, '&amp;objectId=', @id, '&amp;versionId=', version/@id)"/></xsl:element>
        </xsl:element> 
      </xsl:for-each> <!-- object -->

    </xsl:element> <!-- publication -->
  </xsl:template> <!-- element-pubication -->


  <!-- person/affiliation handling templates (formerly mxdPersonOrg.xsl) -->

  <!-- 
       NOTE: requires EXSLT

       Somewhat frobbed code to segregate <person>s and their
       affiliate <organisation>s to obey the MXD format. 
       This is not as straightforward in XSL as you'd like it to be,
       unless you resort to the node-set() extension- which we do.

       We only take persons from the /ddf/document element, which in
       practice always is the object="main" doc. MXD doesn't allow for
       complex person data in for example the 'editor of the book in
       which this chapter appears'.
  -->

  <xsl:template name="element-person-organisation">

    <!-- I do not expect more than 1 org per person... -->
    <xsl:variable name="preorgs-rtf">
      <xsl:for-each select="document/person/organisation">
        <organisation>
          <xsl:attribute name="hash">
            <xsl:value-of select="normalize-space(concat(name/main, name/sub, name/sub2))"/>
          </xsl:attribute>
          <xsl:copy-of select="./*"/>
        </organisation>
      </xsl:for-each>
      <!-- see if there's anyone without org -->
      <xsl:if test="document/person[not(organisation/name/main)]">
        <organisation hash="undef">
          <name>
            <main>[affiliation unknown]</main>
          </name>
        </organisation>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="preorgs" select="ext:node-set($preorgs-rtf)"/>
    <!-- You may hit me with a salmon and call me Jeryll if I understand
         how preceding-sibling:: works, but this seems to do the trick
    -->
    <xsl:variable name="orgs" select="$preorgs/organisation[not(@hash=preceding-sibling::*/@hash)]"/>

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
    <!-- must be called from a for-each loop -->
    <xsl:element name="organisation">
      <xsl:attribute name="org_role">oaf</xsl:attribute>
      <xsl:attribute name="aff_no">
        <xsl:value-of select="position()"/>
      </xsl:attribute>
      <name>
        <level1>
          <xsl:choose>
            <xsl:when test="normalize-space(./name/main)">
              <!-- This MAY result in affiliation unknown -->
              <xsl:value-of select="./name/main"/>
            </xsl:when>
            <xsl:otherwise>
              <!-- FIXME missing organisation/name/main must be fixed in Orbit -->
              <xsl:text>[affiliation name could not be established]</xsl:text>
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
        <xsl:variable name="role" select="string(@role)"/>
        <xsl:value-of select="$personRoleMapping/rule[in=$role]/out"/>
      </xsl:attribute>
      <xsl:variable name="thisorg" select="organisation/name"/>
      <xsl:variable name="thisorg-hash">
        <xsl:choose>
          <xsl:when test="$thisorg/main">
            <xsl:value-of select="normalize-space(concat($thisorg/main,$thisorg/sub,$thisorg/sub2))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>undef</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:attribute name="aff_no">
        <xsl:for-each select="$orgs">
          <xsl:if test="$thisorg-hash = ./@hash">
            <xsl:value-of select="position()"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:attribute> 

      <name>
        <first><xsl:value-of select="./name/first"/></first>
        <last><xsl:value-of select="./name/last"/></last>
      </name>
      <xsl:if test="identifier[@type='cwisno']/text()">
        <id id_type="loc_per">
          <xsl:value-of select="concat('DTU-', identifier[@type='cwisno'])"/>
        </id>
      </xsl:if>

    </xsl:element>
  </xsl:template>
    

  <!-- utility templates -->

  <xsl:template name="subst">
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


  <func:function name="my:replace">
    <!-- NOTE: requires EXSLT -->
    <xsl:param name="in"/>
    <xsl:param name="from"/>
    <xsl:param name="to"/>
    <func:result>
      <xsl:choose>
        <xsl:when test="contains($in,$from)">
          <xsl:value-of select="concat(substring-before($in, $from), $to, 
                                my:replace(substring-after($in,$from), $from, $to))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$in"/>
        </xsl:otherwise>
      </xsl:choose>
    </func:result>
  </func:function>


  <func:function name="my:cleanpages">
  <!--xsl:template name="dummy"-->
    <!-- 
         try to make page ranges fit to the schema PagesType. FIXME in
         Orbit later. 
    -->
    <xsl:param name="pages"/>
    <xsl:variable name="pp" select="normalize-space($pages)"/>
    
    <func:result>
      <xsl:choose>
        <xsl:when test="not($pp)">
          <!-- this is because Exslt screws up parameters when the
               first one is undef or empty, or so -->
          <xsl:text></xsl:text>
        </xsl:when>
        <xsl:when test="re:test($pp,'^pp?\.? ?[0-9]','i')">
          <xsl:value-of select="re:replace($pp, '^pp?\.? ?', 'i', '')"/>
        </xsl:when>
        <xsl:when test="re:test($pp,' ?pp?\.?$','i')">
          <xsl:value-of select="re:replace($pp, ' ?pp?\.?$', 'i', '')"/>
        </xsl:when>
        <xsl:when test="re:test($pp,' - ', 'i')">
          <xsl:value-of select="re:replace($pp, ' - ', 'i', '-')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$pp"/>
        </xsl:otherwise>
      </xsl:choose>
    </func:result>
  <!--/xsl:template-->
  </func:function>

  <func:function name="my:unix2iso">
    <xsl:param name="unix" />

    <!--  snatched from http://www.djkaty.com/drupal/xsl-date-time -->
    
    <xsl:variable name="year" select="floor($unix div 31536000) + 1970" />
    <xsl:variable name="hour" select="floor(($unix mod 86400) div 3600)" />
    <xsl:variable name="minute" select="floor(($unix mod 3600) div 60)" />
    <xsl:variable name="second" select="$unix mod 60" />
    
    <xsl:variable name="yday" select="floor(($unix - ($year - 1970)*31536000 - floor(($year - 1972) div 4)*86400) div 86400)" />
    <xsl:variable name="yday-leap">
      <xsl:choose>
        <xsl:when test="$yday >= 59 or $year mod 4 != 0">
          <xsl:value-of select="$yday" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$yday + 1" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="month">
      <xsl:choose>
        <xsl:when test="$yday-leap &lt;= 31">1</xsl:when>
        <xsl:when test="$yday-leap &lt;= 59">2</xsl:when>
        <xsl:when test="$yday-leap &lt;= 90">3</xsl:when>
        <xsl:when test="$yday-leap &lt;= 120">4</xsl:when>
        <xsl:when test="$yday-leap &lt;= 151">5</xsl:when>
        <xsl:when test="$yday-leap &lt;= 181">6</xsl:when>
        <xsl:when test="$yday-leap &lt;= 212">7</xsl:when>
        <xsl:when test="$yday-leap &lt;= 243">8</xsl:when>
        <xsl:when test="$yday-leap &lt;= 273">9</xsl:when>
        <xsl:when test="$yday-leap &lt;= 304">10</xsl:when>
        <xsl:when test="$yday-leap &lt;= 334">11</xsl:when>
        <xsl:otherwise>12</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="date">
      <xsl:choose>
        <xsl:when test="$yday != 59 or $year mod 4 != 0">
          <xsl:value-of select="$yday-leap - substring('000031059090120151181212243273304334', 3 * $month - 2, 3)" />
        </xsl:when>
        <xsl:otherwise>29</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <func:result select="concat($year, '-',
                         format-number($month, '00'), '-',
                         format-number($date, '00'), 'T',
                         format-number($hour, '00'), ':',
                         format-number($minute, '00'), ':',
                         format-number($second, '00'))" />
  </func:function>
  
</xsl:stylesheet>

