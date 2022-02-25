<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="http://dse-static.foo.bar"
    xmlns:mam="myOneAndOnly" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/osd-container.xsl"/>
    <xsl:import href="./partials/tei-facsimile.xsl"/>
    <xsl:import href="./partials/person.xsl"/>
    <xsl:import href="./partials/place.xsl"/>
    <xsl:import href="./partials/org.xsl"/>
    <xsl:variable name="prev">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')"
        />
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')"
        />
    </xsl:variable>
    <xsl:variable name="teiSource">
        <xsl:value-of select="data(tei:TEI/@xml:id)"/>
    </xsl:variable>
    <xsl:variable name="link">
        <xsl:value-of select="replace($teiSource, '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="doc_title">
        <xsl:value-of select=".//tei:title[@type = 'label'][1]/text()"/>
    </xsl:variable>
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:title[@type = 'main'][1]/text()"/>
        </xsl:variable>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html>
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container-fluid">
                        <div class="card" data-index="true">
                            <!--<div class="card-header">
                                <div class="row">
                                    <div class="col-md-2">
                                        <xsl:if test="ends-with($prev, '.html')">
                                            <h1>
                                                <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of select="$prev"/>
                                                  </xsl:attribute>
                                                  <i class="fas fa-chevron-left" title="prev"/>
                                                </a>
                                            </h1>
                                        </xsl:if>
                                    </div>
                                    <!-\-<div class="col-md-8">
                                        <h1 align="center">
                                            <xsl:value-of select="$doc_title"/>
                                        </h1>
                                        <h3 align="center">
                                            <a href="{$teiSource}">
                                                <i class="fas fa-download" title="show TEI source"/>
                                            </a>
                                        </h3>
                                    </div>-\->
                                    <div class="col-md-2" style="text-align:right">
                                        <xsl:if test="ends-with($next, '.html')">
                                            <h1>
                                                <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of select="$next"/>
                                                  </xsl:attribute>
                                                  <i class="fas fa-chevron-right" title="next"/>
                                                </a>
                                            </h1>
                                        </xsl:if>
                                    </div>
                                </div>
                            </div>-->
                            <div class="card-body">
                                <xsl:apply-templates select=".//tei:body"/>
                            </div>
                            <!--<div class="card-footer">
                                <p style="text-align:center;">
                                    <xsl:for-each select=".//tei:note[not(./tei:p)]">
                                        <div class="footnotes" id="{local:makeId(.)}">
                                            <xsl:element name="a">
                                                <xsl:attribute name="name">
                                                    <xsl:text>fn</xsl:text>
                                                    <xsl:number level="any" format="1" count="tei:note"/>
                                                </xsl:attribute>
                                                <a>
                                                    <xsl:attribute name="href">
                                                        <xsl:text>#fna_</xsl:text>
                                                        <xsl:number level="any" format="1" count="tei:note"/>
                                                    </xsl:attribute>
                                                    <span style="font-size:7pt;vertical-align:super; margin-right: 0.4em">
                                                        <xsl:number level="any" format="1" count="tei:note"/>
                                                    </span>
                                                </a>
                                            </xsl:element>
                                            <xsl:apply-templates/>
                                        </div>
                                    </xsl:for-each>
                                </p>
                            </div>-->
                        </div>
                    </div>
                    <xsl:for-each select=".//tei:listPerson/tei:person[@xml:id]">
                        <xsl:variable name="xmlId">
                            <xsl:value-of select="data(./@xml:id)"/>
                        </xsl:variable>
                        <div class="modal fade" tabindex="-1" role="dialog" aria-hidden="true"
                            id="{$xmlId}">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">
                                            <xsl:value-of
                                                select="normalize-space(string-join(.//tei:persName[1]//text()))"/>
                                            <xsl:text> </xsl:text>
                                            <a href="{concat($xmlId, '.html')}">
                                                <i class="fas fa-external-link-alt"/>
                                            </a>
                                        </h5>
                                    </div>
                                    <div class="modal-body">
                                        <xsl:call-template name="person_detail">
                                            <xsl:with-param name="showNumberOfMentions" select="5"/>
                                        </xsl:call-template>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-dismiss="modal">Schließen</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </xsl:for-each>
                    <xsl:call-template name="html_footer"/>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:p">
        <xsl:choose>
            <xsl:when test="parent::tei:div[starts-with(@xml:id, 'div')]">
                <td class="edierterText">
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
            <xsl:otherwise>
                <p id="{local:makeId(.)}" class="edierterText">
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--<xsl:template match="tei:div">
        <div id="{local:makeId(.)}" class="fake-p">
            <xsl:apply-templates/>
        </div>
    </xsl:template>-->
    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="@rend = 'italics'">
                <i>
                    <xsl:apply-templates/>
                </i>
            </xsl:when>
            <xsl:when test="@rend = 'underline'">
                <u>
                    <xsl:apply-templates/>
                </u>
            </xsl:when>
            <xsl:when test="@rend = 'strikethrough'">
                <del>
                    <xsl:apply-templates/>
                </del>
            </xsl:when>
            <xsl:when test="@rend = 'superscript'">
                <sup>
                    <xsl:apply-templates/>
                </sup>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:note[parent::tei:div[starts-with(@xml:id, 'div')]]">
        <xsl:choose>
            <xsl:when test="tei:note and not(child::*[2])">
                <td class="herausgeberText">
                    <b>
                        <xsl:text>[</xsl:text>
                        <xsl:value-of select="parent::tei:div/substring-after(@xml:id, 'div_')"/>
                        <xsl:text>]</xsl:text>
                        <br/>
                    </b>
                    <xsl:text>[</xsl:text>
                    <xsl:value-of select="tei:note"/>
                    <xsl:text>]</xsl:text>
                </td>
            </xsl:when>
            <xsl:when test="not(tei:list) and tei:listPerson[not(tei:person[2])]">
                <td class="herausgeberText">
                    <b>
                        <xsl:text>[</xsl:text>
                        <xsl:value-of select="parent::tei:div/substring-after(@xml:id, 'div_')"/>
                        <xsl:text>]</xsl:text></b>
                        <br/>
                    <xsl:apply-templates select="tei:listPerson/tei:person"/><xsl:if
                        test="tei:listPerson/tei:person/tei:idno[not(@type = 'schnitzler-lektueren') and not(@type = 'gnd')]">
                        <xsl:for-each
                            select="tei:listPerson/tei:person/tei:idno[not(@type = 'schnitzler-lektueren') and not(@type = 'gnd')]">
                            <xsl:text> &#8594;</xsl:text>
                            <xsl:choose>
                                <xsl:when test="not(.='')">
                            <xsl:element name="a">
                                <xsl:attribute name="href">
                                    <xsl:choose>
                                        <xsl:when test="@type='PMB'">
                                            <xsl:value-of select="mam:pmbChange(., 'person')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="."/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:attribute name="target">
                                    <xsl:text>_blank</xsl:text>
                                </xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">
                                        <xsl:value-of select="concat('color-', @type)"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="mam:ahref-namen(@type)"/>
                                </xsl:element>
                            </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="span">
                                        <xsl:attribute name="class">
                                            <xsl:text>color-inactive</xsl:text>
                                        </xsl:attribute>
                                        <xsl:value-of select="mam:ahref-namen(@type)"/>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:if>
                </td>
            </xsl:when>
            <xsl:when test="not(tei:list) and tei:listPerson">
                <td class="herausgeberText">
                    <b>
                        <xsl:text>[</xsl:text>
                        <xsl:value-of select="parent::tei:div/substring-after(@xml:id, 'div_')"/>
                        <xsl:text>]</xsl:text></b>
                        <br/>
                    <ul class="dashed">
                        <xsl:for-each select="tei:listPerson/tei:person">
                            <li>
                                <xsl:apply-templates select="."/><xsl:if
                                    test="./tei:idno[not(@type = 'schnitzler-lektueren') and not(@type = 'gnd')]">
                                    <xsl:for-each
                                        select="./tei:idno[not(@type = 'schnitzler-lektueren') and not(@type = 'gnd')]">
                                        <xsl:text> &#8594;</xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="not(.='')">
                                                <xsl:element name="a">
                                                    
                                                        <xsl:attribute name="href">
                                                            <xsl:choose>
                                                                <xsl:when test="@type='PMB'">
                                                                    <xsl:value-of select="mam:pmbChange(., 'person')"/>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                    <xsl:value-of select="."/>
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                        </xsl:attribute>
                                                    
                                                    <xsl:attribute name="target">
                                                        <xsl:text>_blank</xsl:text>
                                                    </xsl:attribute>
                                                    <xsl:element name="span">
                                                        <xsl:attribute name="class">
                                                            <xsl:value-of select="concat('color-', @type)"/>
                                                        </xsl:attribute>
                                                        <xsl:value-of select="mam:ahref-namen(@type)"/>
                                                    </xsl:element>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:element name="span">
                                                    <xsl:attribute name="class">
                                                        <xsl:text>color-inactive</xsl:text>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="mam:ahref-namen(@type)"/>
                                                </xsl:element>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </xsl:if>
                            </li>
                        </xsl:for-each>
                    </ul>
                </td>
            </xsl:when>
            <xsl:when test="tei:list">
                <xsl:choose>
                    <xsl:when test="parent::tei:div[tei:note[2]]">
                        <tr>
                            <td class="herausgeberText">
                                <xsl:apply-templates select="tei:list"/>
                            </td>
                        </tr>
                    </xsl:when>
                    <xsl:when test="parent::tei:div">
                        <td class="herausgeberText">
                            <b>
                                <xsl:text>[</xsl:text>
                                <xsl:value-of
                                    select="parent::tei:div/substring-after(@xml:id, 'div_')"/>
                                <xsl:text>]</xsl:text>
                            </b>
                            <xsl:if
                                test="tei:listPerson/tei:person/tei:idno[not(@type = 'schnitzler-lektueren') and not(@type = 'gnd')]">
                                <xsl:for-each
                                    select="tei:listPerson/tei:person/tei:idno[not(@type = 'schnitzler-lektueren') and not(@type = 'gnd')]">
                                    <xsl:text> &#8594;</xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="not(.='')">
                                            <xsl:element name="a">
                                                <xsl:attribute name="href">
                                                    <xsl:choose>
                                                        <xsl:when test="@type='PMB'">
                                                            <xsl:value-of select="mam:pmbChange(., 'person')"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="."/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:attribute>
                                                <xsl:attribute name="target">
                                                    <xsl:text>_blank</xsl:text>
                                                </xsl:attribute>
                                                <xsl:element name="span">
                                                    <xsl:attribute name="class">
                                                        <xsl:value-of select="concat('color-', @type)"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="mam:ahref-namen(@type)"/>
                                                </xsl:element>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:element name="span">
                                                <xsl:attribute name="class">
                                                    <xsl:text>color-inactive</xsl:text>
                                                </xsl:attribute>
                                                <xsl:value-of select="mam:ahref-namen(@type)"/>
                                            </xsl:element>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:if>
                            <br/>
                            <xsl:apply-templates select="tei:list"/>
                        </td>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>XXXX1</xsl:text>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="*"/>
                <xsl:text>XXXX2</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:function name="mam:ahref-namen">
        <xsl:param name="typityp" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$typityp = 'schnitzler-tagebuch'">
                <xsl:text> Tagebuch</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'schnitzler-briefe'">
                <xsl:text> Briefe</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'PMB'">
                <xsl:text> PMB</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'briefe_i'">
                <xsl:text> Briefe 1875–1912</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'briefe_ii'">
                <xsl:text> Briefe 1913–1931</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'DLAwidmund'">
                <xsl:text> Widmungsexemplar Deutsches Literaturarchiv</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp ='jugend-in-wien'">
                <xsl:text> Jugend in Wien</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$typityp"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="mam:pmbChange">
        <xsl:param name="url" as="xs:string"/>
        <xsl:param name="entitytyp" as="xs:string"/>
        <xsl:value-of select="concat('https://pmb.acdh.oeaw.ac.at/apis/entities/entity/',$entitytyp, '/',
            substring-after($url, 'https://pmb.acdh.oeaw.ac.at/entity/'), '/detail')"/>
    </xsl:function>
    <xsl:template match="tei:note[not(parent::tei:div[starts-with(@xml:id, 'div')])]">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
    </xsl:template>
    <xsl:template match="tei:div[starts-with(@type, 'liste')]">
        <xsl:apply-templates select="tei:head"/>
        <table>
            <xsl:apply-templates select="*[not(self::tei:head)]"/>
        </table>
    </xsl:template>
    <xsl:template match="tei:div[starts-with(@xml:id, 'div_')]">
        <tr>
            <xsl:choose>
                <xsl:when test="tei:note[2]">
                    <xsl:apply-templates select="tei:p"/>
                    <td class="herausgeberText">
                        <table>
                            <xsl:for-each select="tei:note">
                                <xsl:apply-templates/>
                            </xsl:for-each>
                        </table>
                    </td>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </tr>
    </xsl:template>
    <xsl:template match="tei:div[starts-with(@type, 'div_')]/tei:p">
        <td class="edierterText">
            <xsl:apply-templates/>
        </td>
    </xsl:template>
    <xsl:template match="tei:list">
        <ul class="dashed">
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="tei:listBibl">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:listPerson">
        <xsl:choose>
            <xsl:when test="tei:listPerson[2]">
                <ul class="dashed">
                    <xsl:apply-templates/>
                </ul>
            </xsl:when>
            <xsl:otherwise>
                <ul class="no-bullets">
                    <xsl:apply-templates/>
                </ul>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:person">
        <xsl:if test="@cert">
            <xsl:text>[?] </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="tei:persName"/>
        <xsl:choose>
            <xsl:when test="tei:birth/tei:date and tei:death/tei:date">
                <xsl:text> (</xsl:text>
                <xsl:value-of select="tei:birth/tei:date"/>
                <xsl:if test="tei:birth/tei:date/@cert">
                    <xsl:text>?</xsl:text>
                </xsl:if>
                <xsl:text> – </xsl:text>
                <xsl:value-of select="tei:death/tei:date"/>
                <xsl:if test="tei:death/tei:date/@cert">
                    <xsl:text>?</xsl:text>
                </xsl:if>
                <xsl:text>)</xsl:text>
            </xsl:when>
            <xsl:when test="tei:birth/tei:date">
                <xsl:text> (*</xsl:text>
                <xsl:value-of select="tei:birth/tei:date"/>
                <xsl:if test="tei:birth/tei:date/@cert">
                    <xsl:text>?</xsl:text>
                </xsl:if>
                <xsl:text>)</xsl:text>
            </xsl:when>
            <xsl:when test="tei:death/tei:date">
                <xsl:text> (†</xsl:text>
                <xsl:value-of select="tei:death/tei:date"/>
                <xsl:if test="tei:death/tei:date/@cert">
                    <xsl:text>?</xsl:text>
                </xsl:if>
                <xsl:text>)</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:persName">
        <span class="autorname">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:function name="mam:biblsetzen">
        <xsl:param name="bobl" as="node()"/>
        <xsl:if test="$bobl/tei:title/@cert">
            <xsl:text>[?] </xsl:text>
        </xsl:if>
        <xsl:for-each select="$bobl/tei:rs[@type='person']">
            <xsl:element name="a">
                <xsl:attribute name="data-toggle">
                    <xsl:text>modal</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="data-target">
                    <xsl:value-of select="@ref"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
            <xsl:if test="@cert">
                <xsl:text>[?] </xsl:text>
            </xsl:if>
            <xsl:if test="not(position() = last())">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>: </xsl:text>
        <xsl:if test="$bobl/tei:title[@level = 'a']">
            <i>
                <xsl:value-of select="$bobl/tei:title[@level = 'a']"/>
            </i>
            <xsl:text>. In: </xsl:text>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$bobl/tei:title[@level = 'm'] and $bobl/tei:title[@level = 's']">
                <i>
                    <xsl:value-of select="normalize-space($bobl/tei:title[(@level = 'm')])"/>
                </i>
                <xsl:text>.</xsl:text>
                <xsl:if test="$bobl/tei:editor[@role = 'hrsg']">
                    <xsl:text>Herausgegeben von </xsl:text>
                </xsl:if>
                <xsl:for-each select="$bobl/tei:editor[@role = 'hrsg']">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:choose>
                        <xsl:when test="not(position() = last())">
                            <xsl:text>,</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>.</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:choose>
                    <xsl:when
                        test="$bobl/tei:editor[@role = 'translator' and @subtype = 'anonymous']">
                        <xsl:text> [Ohne Übersetzerangabe.] </xsl:text>
                    </xsl:when>
                    <xsl:when test="$bobl/tei:editor[@role = 'translator']">
                        <xsl:text> Übersetzt von </xsl:text>
                        <xsl:for-each select="$bobl/tei:editor[@role = 'translator']">
                            <xsl:value-of select="."/>
                            <xsl:choose>
                                <xsl:when test="not(position() = last())">
                                    <xsl:text>, </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>.</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
                <xsl:for-each select="$bobl/tei:pubPlace">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:choose>
                        <xsl:when test="not(position() = last())">
                            <xsl:text>,</xsl:text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:if test="$bobl/tei:date">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$bobl/tei:date"/>
                    <xsl:text>.</xsl:text>
                </xsl:if>
                <xsl:text> (</xsl:text>
                <i>
                    <xsl:value-of select="$bobl/tei:title[@level = 's']"/>
                </i>
                <xsl:text>)</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <i>
                    <xsl:value-of select="normalize-space($bobl/tei:title[not(@level = 'a')])"/>
                </i>
                <xsl:text>.</xsl:text>
                <xsl:if test="$bobl/tei:editor[@role = 'hrsg']">
                    <xsl:text>Herausgegeben von </xsl:text>
                </xsl:if>
                <xsl:for-each select="$bobl/tei:editor[@role = 'hrsg']">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:choose>
                        <xsl:when test="not(position() = last())">
                            <xsl:text>,</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>.</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:choose>
                    <xsl:when
                        test="$bobl/tei:editor[@role = 'translator' and @subtype = 'anonymous']">
                        <xsl:text> [Ohne Übersetzerangabe.] </xsl:text>
                    </xsl:when>
                    <xsl:when test="$bobl/tei:editor[@role = 'translator']">
                        <xsl:text> Übersetzt von </xsl:text>
                        <xsl:for-each select="$bobl/tei:editor[@role = 'translator']">
                            <xsl:value-of select="."/>
                            <xsl:choose>
                                <xsl:when test="not(position() = last())">
                                    <xsl:text>, </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>.</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
                <xsl:for-each select="$bobl/tei:pubPlace">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:choose>
                        <xsl:when test="not(position() = last())">
                            <xsl:text>,</xsl:text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:if test="$bobl/tei:date">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$bobl/tei:date"/>
                    <xsl:text>.</xsl:text>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$bobl/tei:note">
            <xsl:text> [</xsl:text>
            <xsl:value-of select="$bobl/tei:note"/>
            <xsl:text>]</xsl:text>
        </xsl:if>
        <xsl:if test="$bobl/tei:ref">
            <xsl:for-each select="$bobl/tei:ref">
                <xsl:text> &#8594;</xsl:text>
                <xsl:choose>
                    <xsl:when test="@type='briefe_i'">
                        <a href="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/1981_Briefe-1875–1912.pdf"><span class="color-schnitzler-briefe">Briefe 1875–1912</span></a>
                    </xsl:when>
                    <xsl:when test="@type='briefe_ii'">
                        <a href="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/1981_Briefe-1913–1931.pdf"><span class="color-schnitzler-briefe">Briefe 1913–1931</span></a>
                    </xsl:when>
                    <xsl:when test="@type='jugend-in-wien'">
                        <a href="http://www.zeno.org/Literatur/M/Schnitzler,+Arthur/Autobiographisches/Jugend+in+Wien">Jugend in Wien</a>
                    </xsl:when>
                    <xsl:when test="@target and not(@target='')">
                        <xsl:element name="a">
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="@type='PMB'">
                                        <xsl:value-of select="mam:pmbChange(., 'work')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="."/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:attribute name="target">
                                <xsl:text>_blank</xsl:text>
                            </xsl:attribute>
                            <xsl:element name="span">
                                <xsl:attribute name="class">
                                    <xsl:value-of select="concat('color-', @type)"/>
                                </xsl:attribute>
                                <xsl:value-of select="mam:ahref-namen(@type)"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="span">
                            <xsl:attribute name="class">
                                <xsl:text>color-inactive</xsl:text>
                            </xsl:attribute>
                            <xsl:value-of select="mam:ahref-namen(@type)"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:function>
    <xsl:template match="tei:item/tei:bibl">
        <xsl:copy-of select="mam:biblsetzen(.)"/>
    </xsl:template>
    <xsl:template
        match="tei:item/tei:listBibl[not(tei:bibl/@type = 'translation')]/tei:bibl[@type = 'original']">
        <xsl:if test="count(preceding-sibling::tei:bibl) &gt; 0">
            <br/>
            <xsl:text>[oder]</xsl:text>
            <br/>
        </xsl:if>
        <xsl:copy-of select="mam:biblsetzen(.)"/>
    </xsl:template>
    <xsl:template
        match="tei:item/tei:listBibl[tei:bibl/@type = 'translation' and tei:bibl/@type = 'original']">
        <xsl:for-each select="tei:bibl[@type = 'translation']">
            <xsl:copy-of select="mam:biblsetzen(.)"/>
            <xsl:if test="not(position() = last())">
                <br/>
                <xsl:text>[oder]</xsl:text>
                <br/>
            </xsl:if>
        </xsl:for-each>
        <xsl:text> [</xsl:text>
        <xsl:for-each select="tei:bibl[@type = 'original']">
            <xsl:copy-of select="mam:biblsetzen(.)"/>
            <xsl:if test="not(position() = last())">
                <xsl:text> {oder} </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>
    <xsl:template
        match="tei:item/tei:listBibl[tei:bibl/@type = 'translation' and tei:bibl/@type = 'original']/tei:bibl[@type = 'translation']">
        <xsl:copy-of select="mam:biblsetzen(.)"/>
    </xsl:template>
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <xsl:template match="tei:head">
        <h1 class="edierterText">
            <xsl:apply-templates/>
        </h1>
    </xsl:template>
    <xsl:template match="tei:supplied">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
    </xsl:template>
</xsl:stylesheet>
