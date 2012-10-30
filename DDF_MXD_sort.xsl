<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mx="http://mx.forskningsdatabasen.dk/ns/documents/1.3" version="1.0">

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="no" encoding="UTF-8"/>

    <xsl:template match="/">
        <xsl:copy>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc">
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
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:title"/>
            <xsl:apply-templates select="mx:description"/>
            <xsl:apply-templates select="mx:person"/>
            <xsl:apply-templates select="mx:organisation"/>
            <xsl:apply-templates select="mx:project"/>
            <xsl:apply-templates select="mx:event"/>
            <xsl:apply-templates select="mx:local_field"/>
            <xsl:apply-templates select="mx:publication"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:description">
        <xsl:copy>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:abstract"/>
            <xsl:apply-templates select="mx:note"/>
            <xsl:apply-templates select="mx:thesis"/>
            <xsl:apply-templates select="mx:subject"/>
            <xsl:apply-templates select="mx:research_area"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:description/mx:abstract">
        <xsl:copy>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:description/mx:note">
        <xsl:copy>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:description/mx:research_area">
        <xsl:copy>
            <xsl:apply-templates select="@area_code"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:description/mx:subject">
        <xsl:copy>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:keyword"/>
            <xsl:apply-templates select="mx:class"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:description/mx:subject/mx:class">
        <xsl:copy>
            <xsl:apply-templates select="@class_type"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:description/mx:subject/mx:keyword">
        <xsl:copy>
            <xsl:apply-templates select="@key_type"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:description/mx:thesis">
        <xsl:copy>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:institution"/>
            <xsl:apply-templates select="mx:advisor"/>
            <xsl:apply-templates select="mx:aw_date"/>
            <xsl:apply-templates select="mx:other"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:event">
        <xsl:copy>
            <xsl:apply-templates select="@event_role"/>
            <xsl:apply-templates select="@bfi_conference_no"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:title"/>
            <xsl:apply-templates select="mx:dates"/>
            <xsl:apply-templates select="mx:place"/>
            <xsl:apply-templates select="mx:sub_event"/>
            <xsl:apply-templates select="mx:id"/>
            <xsl:apply-templates select="mx:uri"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:event/mx:dates">
        <xsl:copy>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:start"/>
            <xsl:apply-templates select="mx:end"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:event/mx:id">
        <xsl:copy>
            <xsl:apply-templates select="@id_type"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:event/mx:sub_event">
        <xsl:copy>
            <xsl:apply-templates select="@event_type"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:title"/>
            <xsl:apply-templates select="mx:acronym"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:event/mx:sub_event/mx:title">
        <xsl:copy>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:event/mx:title">
        <xsl:copy>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:full"/>
            <xsl:apply-templates select="mx:acronym"/>
            <xsl:apply-templates select="mx:number"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:event/mx:uri">
        <xsl:copy>
            <xsl:apply-templates select="@access"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:local_field">
        <xsl:copy>
            <xsl:apply-templates select="@tag_type"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:code"/>
            <xsl:apply-templates select="mx:data"/>
            <xsl:apply-templates select="mx:subfield"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:local_field/mx:subfield">
        <xsl:copy>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:code"/>
            <xsl:apply-templates select="mx:data"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:organisation">
        <xsl:copy>
            <xsl:apply-templates select="@org_role"/>
            <xsl:apply-templates select="@aff_no"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:name"/>
            <xsl:apply-templates select="mx:id"/>
            <xsl:apply-templates select="mx:country"/>
            <xsl:apply-templates select="mx:uri"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:organisation/mx:id">
        <xsl:copy>
            <xsl:apply-templates select="@id_type"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:organisation/mx:name">
        <xsl:copy>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:level1"/>
            <xsl:apply-templates select="mx:level2"/>
            <xsl:apply-templates select="mx:level3"/>
            <xsl:apply-templates select="mx:level4"/>
            <xsl:apply-templates select="mx:acronym"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:organisation/mx:uri">
        <xsl:copy>
            <xsl:apply-templates select="@access"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:person">
        <xsl:copy>
            <xsl:apply-templates select="@pers_role"/>
            <xsl:apply-templates select="@aff_no"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:name"/>
            <xsl:apply-templates select="mx:id"/>
            <xsl:apply-templates select="mx:title"/>
            <xsl:apply-templates select="mx:birthdate"/>
            <xsl:apply-templates select="mx:country"/>
            <xsl:apply-templates select="mx:address"/>
            <xsl:apply-templates select="mx:email"/>
            <xsl:apply-templates select="mx:uri"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:person/mx:id">
        <xsl:copy>
            <xsl:apply-templates select="@id_type"/>
            <xsl:apply-templates select="@id_source"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:person/mx:name">
        <xsl:copy>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:first"/>
            <xsl:apply-templates select="mx:last"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:person/mx:uri">
        <xsl:copy>
            <xsl:apply-templates select="@access"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:project">
        <xsl:copy>
            <xsl:apply-templates select="@proj_role"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:title"/>
            <xsl:apply-templates select="mx:id"/>
            <xsl:apply-templates select="mx:uri"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:project/mx:id">
        <xsl:copy>
            <xsl:apply-templates select="@id_type"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:project/mx:title">
        <xsl:copy>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:main"/>
            <xsl:apply-templates select="mx:sub"/>
            <xsl:apply-templates select="mx:acronym"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:project/mx:uri">
        <xsl:copy>
            <xsl:apply-templates select="@access"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication">
        <xsl:copy>
            <xsl:apply-templates select="@bfi_serial_no"/>
            <xsl:apply-templates select="@bfi_publisher_no"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:in_journal"/>
            <xsl:apply-templates select="mx:in_book"/>
            <xsl:apply-templates select="mx:in_report"/>
            <xsl:apply-templates select="mx:book"/>
            <xsl:apply-templates select="mx:report"/>
            <xsl:apply-templates select="mx:patent"/>
            <xsl:apply-templates select="mx:inetpub"/>
            <xsl:apply-templates select="mx:digital_object"/>
            <xsl:apply-templates select="mx:other"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:book">
        <xsl:copy>
            <xsl:apply-templates select="@pub_status"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:edition"/>
            <xsl:apply-templates select="mx:isbn"/>
            <xsl:apply-templates select="mx:place"/>
            <xsl:apply-templates select="mx:publisher"/>
            <xsl:apply-templates select="mx:year"/>
            <xsl:apply-templates select="mx:pages"/>
            <xsl:apply-templates select="mx:doi"/>
            <xsl:apply-templates select="mx:series"/>
            <xsl:apply-templates select="mx:uri"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:book/mx:isbn">
        <xsl:copy>
            <xsl:apply-templates select="@type"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:book/mx:uri">
        <xsl:copy>
            <xsl:apply-templates select="@access"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:digital_object">
        <xsl:copy>
            <xsl:apply-templates select="@id"/>
            <xsl:apply-templates select="@role"/>
            <xsl:apply-templates select="@access"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:description"/>
            <xsl:apply-templates select="mx:embargo_end"/>
            <xsl:apply-templates select="mx:file"/>
            <xsl:apply-templates select="mx:uri"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:digital_object/mx:file">
        <xsl:copy>
            <xsl:apply-templates select="@lang"/>
            <xsl:apply-templates select="@size"/>
            <xsl:apply-templates select="@mime_type"/>
            <xsl:apply-templates select="@timestamp"/>
            <xsl:apply-templates select="@filename"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:description"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:digital_object/mx:uri">
        <xsl:copy>
            <xsl:apply-templates select="@access"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:in_book">
        <xsl:copy>
            <xsl:apply-templates select="@pub_status"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:title"/>
            <xsl:apply-templates select="mx:sub_title"/>
            <xsl:apply-templates select="mx:part"/>
            <xsl:apply-templates select="mx:edition"/>
            <xsl:apply-templates select="mx:editor"/>
            <xsl:apply-templates select="mx:isbn"/>
            <xsl:apply-templates select="mx:issn"/>
            <xsl:apply-templates select="mx:place"/>
            <xsl:apply-templates select="mx:publisher"/>
            <xsl:apply-templates select="mx:year"/>
            <xsl:apply-templates select="mx:doi"/>
            <xsl:apply-templates select="mx:pages"/>
            <xsl:apply-templates select="mx:series"/>
            <xsl:apply-templates select="mx:uri"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:in_book/mx:isbn">
        <xsl:copy>
            <xsl:apply-templates select="@type"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:in_book/mx:issn">
        <xsl:copy>
            <xsl:apply-templates select="@type"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:in_book/mx:uri">
        <xsl:copy>
            <xsl:apply-templates select="@access"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:in_journal">
        <xsl:copy>
            <xsl:apply-templates select="@pub_status"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:title"/>
            <xsl:apply-templates select="mx:title_alternative"/>
            <xsl:apply-templates select="mx:issn"/>
            <xsl:apply-templates select="mx:year"/>
            <xsl:apply-templates select="mx:vol"/>
            <xsl:apply-templates select="mx:issue"/>
            <xsl:apply-templates select="mx:pages"/>
            <xsl:apply-templates select="mx:paperid"/>
            <xsl:apply-templates select="mx:doi"/>
            <xsl:apply-templates select="mx:uri"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:in_journal/mx:issn">
        <xsl:copy>
            <xsl:apply-templates select="@type"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:in_journal/mx:uri">
        <xsl:copy>
            <xsl:apply-templates select="@access"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:in_report">
        <xsl:copy>
            <xsl:apply-templates select="@pub_status"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:title"/>
            <xsl:apply-templates select="mx:sub_title"/>
            <xsl:apply-templates select="mx:part"/>
            <xsl:apply-templates select="mx:editor"/>
            <xsl:apply-templates select="mx:isbn"/>
            <xsl:apply-templates select="mx:series"/>
            <xsl:apply-templates select="mx:rep_no"/>
            <xsl:apply-templates select="mx:place"/>
            <xsl:apply-templates select="mx:publisher"/>
            <xsl:apply-templates select="mx:year"/>
            <xsl:apply-templates select="mx:vol"/>
            <xsl:apply-templates select="mx:issue"/>
            <xsl:apply-templates select="mx:pages"/>
            <xsl:apply-templates select="mx:paperid"/>
            <xsl:apply-templates select="mx:doi"/>
            <xsl:apply-templates select="mx:uri"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:in_report/mx:isbn">
        <xsl:copy>
            <xsl:apply-templates select="@type"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:in_report/mx:uri">
        <xsl:copy>
            <xsl:apply-templates select="@access"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:inetpub">
        <xsl:copy>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:text"/>
            <xsl:apply-templates select="mx:uri"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:inetpub/mx:uri">
        <xsl:copy>
            <xsl:apply-templates select="@access"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:patent">
        <xsl:copy>
            <xsl:apply-templates select="@pub_status"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:country"/>
            <xsl:apply-templates select="mx:ipc"/>
            <xsl:apply-templates select="mx:number"/>
            <xsl:apply-templates select="mx:date"/>
            <xsl:apply-templates select="mx:uri"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:patent/mx:uri">
        <xsl:copy>
            <xsl:apply-templates select="@access"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:report">
        <xsl:copy>
            <xsl:apply-templates select="@pub_status"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:isbn"/>
            <xsl:apply-templates select="mx:series"/>
            <xsl:apply-templates select="mx:rep_no"/>
            <xsl:apply-templates select="mx:place"/>
            <xsl:apply-templates select="mx:publisher"/>
            <xsl:apply-templates select="mx:year"/>
            <xsl:apply-templates select="mx:pages"/>
            <xsl:apply-templates select="mx:uri"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:report/mx:isbn">
        <xsl:copy>
            <xsl:apply-templates select="@type"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:publication/mx:report/mx:uri">
        <xsl:copy>
            <xsl:apply-templates select="@access"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:title">
        <xsl:copy>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:original"/>
            <xsl:apply-templates select="mx:translated"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:title/mx:original">
        <xsl:copy>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:main"/>
            <xsl:apply-templates select="mx:sub"/>
            <xsl:apply-templates select="mx:part"/>
            <xsl:apply-templates select="mx:other"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/mx:ddf_doc/mx:title/mx:translated">
        <xsl:copy>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="mx:main"/>
            <xsl:apply-templates select="mx:sub"/>
            <xsl:apply-templates select="mx:part"/>
            <xsl:apply-templates select="mx:other"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | text()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
