<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <!-- This stylesheet was generated with schema_sort.pl MXD_ddf_doc.xsd.
       Do not edit (other than indentation perhaps). -->

  <!-- schema version 1.2.0.0 -->

  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="no" encoding="UTF-8"/>

  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="*"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc">
    <xsl:copy>
      <xsl:apply-templates select="@format_version"/>
      <xsl:apply-templates select="@doc_type"/>
      <xsl:apply-templates select="@doc_lang"/>
      <xsl:apply-templates select="@doc_year"/>
      <xsl:apply-templates select="@doc_review"/>
      <xsl:apply-templates select="@doc_level"/>
      <xsl:apply-templates select="@rec_source"/>
      <xsl:apply-templates select="@rec_id"/>
      <xsl:apply-templates select="@rec_created"/>
      <xsl:apply-templates select="@rec_upd"/>
      <xsl:apply-templates select="@rec_status"/>
      <xsl:apply-templates select="title"/>
      <xsl:apply-templates select="description"/>
      <xsl:apply-templates select="person"/>
      <xsl:apply-templates select="organisation"/>
      <xsl:apply-templates select="project"/>
      <xsl:apply-templates select="event"/>
      <xsl:apply-templates select="local_field"/>
      <xsl:apply-templates select="publication"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/description">
    <xsl:copy>
      <xsl:apply-templates select="abstract"/>
      <xsl:apply-templates select="note"/>
      <xsl:apply-templates select="thesis"/>
      <xsl:apply-templates select="subject"/>
      <xsl:apply-templates select="research_area"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/description/research_area">
    <xsl:copy>
      <xsl:apply-templates select="@area_code"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/description/subject">
    <xsl:copy>
      <xsl:apply-templates select="keyword"/>
      <xsl:apply-templates select="class"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/description/subject/class">
    <xsl:copy>
      <xsl:apply-templates select="@class_type"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/description/subject/keyword">
    <xsl:copy>
      <xsl:apply-templates select="@key_type"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/description/thesis">
    <xsl:copy>
      <xsl:apply-templates select="institution"/>
      <xsl:apply-templates select="advisor"/>
      <xsl:apply-templates select="aw_date"/>
      <xsl:apply-templates select="other"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/event">
    <xsl:copy>
      <xsl:apply-templates select="@event_role"/>
      <xsl:apply-templates select="title"/>
      <xsl:apply-templates select="dates"/>
      <xsl:apply-templates select="place"/>
      <xsl:apply-templates select="uri"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/event/dates">
    <xsl:copy>
      <xsl:apply-templates select="start"/>
      <xsl:apply-templates select="end"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/event/title">
    <xsl:copy>
      <xsl:apply-templates select="full"/>
      <xsl:apply-templates select="acronym"/>
      <xsl:apply-templates select="number"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/event/uri">
    <xsl:copy>
      <xsl:apply-templates select="@access"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/local_field">
    <xsl:copy>
      <xsl:apply-templates select="@tag_type"/>
      <xsl:apply-templates select="code"/>
      <xsl:apply-templates select="data"/>
      <xsl:apply-templates select="subfield"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/local_field/subfield">
    <xsl:copy>
      <xsl:apply-templates select="code"/>
      <xsl:apply-templates select="data"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/organisation">
    <xsl:copy>
      <xsl:apply-templates select="@org_role"/>
      <xsl:apply-templates select="@aff_no"/>
      <xsl:apply-templates select="name"/>
      <xsl:apply-templates select="id"/>
      <xsl:apply-templates select="country"/>
      <xsl:apply-templates select="uri"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/organisation/id">
    <xsl:copy>
      <xsl:apply-templates select="@id_type"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/organisation/name">
    <xsl:copy>
      <xsl:apply-templates select="level1"/>
      <xsl:apply-templates select="level2"/>
      <xsl:apply-templates select="level3"/>
      <xsl:apply-templates select="level4"/>
      <xsl:apply-templates select="acronym"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/organisation/uri">
    <xsl:copy>
      <xsl:apply-templates select="@access"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/person">
    <xsl:copy>
      <xsl:apply-templates select="@pers_role"/>
      <xsl:apply-templates select="@aff_no"/>
      <xsl:apply-templates select="name"/>
      <xsl:apply-templates select="id"/>
      <xsl:apply-templates select="title"/>
      <xsl:apply-templates select="birthdate"/>
      <xsl:apply-templates select="country"/>
      <xsl:apply-templates select="address"/>
      <xsl:apply-templates select="email"/>
      <xsl:apply-templates select="uri"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/person/id">
    <xsl:copy>
      <xsl:apply-templates select="@id_type"/>
      <xsl:apply-templates select="@id_source"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/person/name">
    <xsl:copy>
      <xsl:apply-templates select="first"/>
      <xsl:apply-templates select="last"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/person/uri">
    <xsl:copy>
      <xsl:apply-templates select="@access"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/project">
    <xsl:copy>
      <xsl:apply-templates select="@proj_role"/>
      <xsl:apply-templates select="title"/>
      <xsl:apply-templates select="id"/>
      <xsl:apply-templates select="uri"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/project/id">
    <xsl:copy>
      <xsl:apply-templates select="@id_type"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/project/title">
    <xsl:copy>
      <xsl:apply-templates select="main"/>
      <xsl:apply-templates select="sub"/>
      <xsl:apply-templates select="acronym"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/project/uri">
    <xsl:copy>
      <xsl:apply-templates select="@access"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication">
    <xsl:copy>
      <xsl:apply-templates select="in_journal"/>
      <xsl:apply-templates select="in_book"/>
      <xsl:apply-templates select="in_report"/>
      <xsl:apply-templates select="book"/>
      <xsl:apply-templates select="report"/>
      <xsl:apply-templates select="patent"/>
      <xsl:apply-templates select="inetpub"/>
      <xsl:apply-templates select="digital_object"/>
      <xsl:apply-templates select="other"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/book">
    <xsl:copy>
      <xsl:apply-templates select="@pub_status"/>
      <xsl:apply-templates select="edition"/>
      <xsl:apply-templates select="isbn"/>
      <xsl:apply-templates select="place"/>
      <xsl:apply-templates select="publisher"/>
      <xsl:apply-templates select="year"/>
      <xsl:apply-templates select="pages"/>
      <xsl:apply-templates select="doi"/>
      <xsl:apply-templates select="series"/>
      <xsl:apply-templates select="publisher_no"/>
      <xsl:apply-templates select="uri"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/book/isbn">
    <xsl:copy>
      <xsl:apply-templates select="@type"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/book/uri">
    <xsl:copy>
      <xsl:apply-templates select="@access"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/digital_object">
    <xsl:copy>
      <xsl:apply-templates select="@id"/>
      <xsl:apply-templates select="@role"/>
      <xsl:apply-templates select="@access"/>
      <xsl:apply-templates select="description"/>
      <xsl:apply-templates select="file"/>
      <xsl:apply-templates select="uri"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/digital_object/file">
    <xsl:copy>
      <xsl:apply-templates select="@lang"/>
      <xsl:apply-templates select="@size"/>
      <xsl:apply-templates select="@mime_type"/>
      <xsl:apply-templates select="@timestamp"/>
      <xsl:apply-templates select="@filename"/>
      <xsl:apply-templates select="description"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/digital_object/uri">
    <xsl:copy>
      <xsl:apply-templates select="@access"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/in_book">
    <xsl:copy>
      <xsl:apply-templates select="@pub_status"/>
      <xsl:apply-templates select="title"/>
      <xsl:apply-templates select="sub_title"/>
      <xsl:apply-templates select="part"/>
      <xsl:apply-templates select="edition"/>
      <xsl:apply-templates select="editor"/>
      <xsl:apply-templates select="isbn"/>
      <xsl:apply-templates select="issn"/>
      <xsl:apply-templates select="place"/>
      <xsl:apply-templates select="publisher"/>
      <xsl:apply-templates select="year"/>
      <xsl:apply-templates select="doi"/>
      <xsl:apply-templates select="pages"/>
      <xsl:apply-templates select="series"/>
      <xsl:apply-templates select="publisher_no"/>
      <xsl:apply-templates select="uri"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/in_book/isbn">
    <xsl:copy>
      <xsl:apply-templates select="@type"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/in_book/issn">
    <xsl:copy>
      <xsl:apply-templates select="@type"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/in_book/uri">
    <xsl:copy>
      <xsl:apply-templates select="@access"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/in_journal">
    <xsl:copy>
      <xsl:apply-templates select="@pub_status"/>
      <xsl:apply-templates select="title"/>
      <xsl:apply-templates select="title_alternative"/>
      <xsl:apply-templates select="issn"/>
      <xsl:apply-templates select="year"/>
      <xsl:apply-templates select="vol"/>
      <xsl:apply-templates select="issue"/>
      <xsl:apply-templates select="pages"/>
      <xsl:apply-templates select="paperid"/>
      <xsl:apply-templates select="doi"/>
      <xsl:apply-templates select="journal_no"/>
      <xsl:apply-templates select="uri"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/in_journal/issn">
    <xsl:copy>
      <xsl:apply-templates select="@type"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/in_journal/uri">
    <xsl:copy>
      <xsl:apply-templates select="@access"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/in_report">
    <xsl:copy>
      <xsl:apply-templates select="@pub_status"/>
      <xsl:apply-templates select="title"/>
      <xsl:apply-templates select="sub_title"/>
      <xsl:apply-templates select="part"/>
      <xsl:apply-templates select="editor"/>
      <xsl:apply-templates select="isbn"/>
      <xsl:apply-templates select="rep_no"/>
      <xsl:apply-templates select="place"/>
      <xsl:apply-templates select="publisher"/>
      <xsl:apply-templates select="year"/>
      <xsl:apply-templates select="vol"/>
      <xsl:apply-templates select="issue"/>
      <xsl:apply-templates select="pages"/>
      <xsl:apply-templates select="paperid"/>
      <xsl:apply-templates select="doi"/>
      <xsl:apply-templates select="uri"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/in_report/isbn">
    <xsl:copy>
      <xsl:apply-templates select="@type"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/in_report/uri">
    <xsl:copy>
      <xsl:apply-templates select="@access"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/inetpub">
    <xsl:copy>
      <xsl:apply-templates select="text"/>
      <xsl:apply-templates select="uri"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/inetpub/uri">
    <xsl:copy>
      <xsl:apply-templates select="@access"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/patent">
    <xsl:copy>
      <xsl:apply-templates select="@pub_status"/>
      <xsl:apply-templates select="country"/>
      <xsl:apply-templates select="ipc"/>
      <xsl:apply-templates select="number"/>
      <xsl:apply-templates select="date"/>
      <xsl:apply-templates select="uri"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/patent/uri">
    <xsl:copy>
      <xsl:apply-templates select="@access"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/report">
    <xsl:copy>
      <xsl:apply-templates select="@pub_status"/>
      <xsl:apply-templates select="isbn"/>
      <xsl:apply-templates select="rep_no"/>
      <xsl:apply-templates select="place"/>
      <xsl:apply-templates select="publisher"/>
      <xsl:apply-templates select="year"/>
      <xsl:apply-templates select="pages"/>
      <xsl:apply-templates select="uri"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/report/isbn">
    <xsl:copy>
      <xsl:apply-templates select="@type"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/publication/report/uri">
    <xsl:copy>
      <xsl:apply-templates select="@access"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/title">
    <xsl:copy>
      <xsl:apply-templates select="original"/>
      <xsl:apply-templates select="translated"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/title/original">
    <xsl:copy>
      <xsl:apply-templates select="main"/>
      <xsl:apply-templates select="sub"/>
      <xsl:apply-templates select="part"/>
      <xsl:apply-templates select="other"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/ddf_doc/title/translated">
    <xsl:copy>
      <xsl:apply-templates select="main"/>
      <xsl:apply-templates select="sub"/>
      <xsl:apply-templates select="part"/>
      <xsl:apply-templates select="other"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
