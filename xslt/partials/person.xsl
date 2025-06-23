<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mam="whatever" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:import href="LOD-idnos.xsl"/>
    <xsl:param name="relevant-uris" select="document('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-chronik-static/refs/heads/main/xslt/export/list-of-relevant-uris.xml')"/>
    <xsl:key name="only-relevant-uris" match="item" use="abbr"/>
    <xsl:param name="works"
        select="document('../../data/indices/listwork.xml')"/>
    <xsl:key name="authorwork-lookup" match="tei:bibl"
        use="tei:author/@key/replace(., 'pmb', 'pmb')"/>
    <xsl:key name="authorwork-lookup-ref" match="tei:bibl"
        use="tei:author/@ref/replace(., 'pmb', 'pmb')"/>
    <xsl:key name="work-lookup" match="tei:bibl" use="tei:relatedItem/@target"/>
    <xsl:param name="konkordanz"
        select="document('../../data/indices/konkordanz.xml')"/>
    <xsl:key name="konk-lookup" match="ref" use="@xml:id"/>
    <xsl:template match="tei:person" name="person_detail">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="50000"/>
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="card-body-index">
            <div id="mentions">
                <xsl:if test="key('only-relevant-uris', tei:idno/@subtype, $relevant-uris)[1]">
                    <p class="buttonreihe" >
                        <xsl:variable name="link"
                            select="key('konk-lookup', @xml:id, $konkordanz)[1]/@target"/>
                        <a href="{concat($link, '#',@xml:id)}">
                            <xsl:element name="span">
                                <xsl:attribute name="class">
                                    <xsl:text>badge rounded-pill</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="style">
                                    <xsl:text>background-color: #022954; color: white</xsl:text>
                                </xsl:attribute>
                                <xsl:text>Leseliste</xsl:text>
                            </xsl:element>
                        </a>
                    </p>
                    <p class="buttonreihe">
                        <xsl:variable name="idnos-of-current" as="node()">
                            <xsl:element name="nodeset_person">
                                <xsl:for-each select="tei:idno">
                                    <xsl:copy-of select="."/>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:variable>
                        <xsl:call-template name="mam:idnosToLinks">
                            <xsl:with-param name="idnos-of-current" select="$idnos-of-current"/>
                        </xsl:call-template>
                    </p>
                </xsl:if>
            </div>
            <xsl:variable name="lemma-name" select="tei:persName[(position() = 1)]" as="node()"/>
            <xsl:variable name="namensformen" as="node()">
                <xsl:element name="listPerson">
                    <xsl:for-each select="descendant::tei:persName[not(position() = 1)]">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </xsl:element>
            </xsl:variable>
            <xsl:for-each select="$namensformen//tei:persName">
                <p class="personenname">
                    <xsl:choose>
                        <xsl:when test="descendant::*">
                            <!-- den Fall dürfte es eh nicht geben, aber löschen braucht man auch nicht -->
                            <xsl:choose>
                                <xsl:when test="./tei:forename/text() and ./tei:surname/text()">
                                    <xsl:value-of
                                        select="concat(./tei:forename/text(), ' ', ./tei:surname/text())"
                                    />
                                </xsl:when>
                                <xsl:when test="./tei:forename/text()">
                                    <xsl:value-of select="./tei:forename/text()"/>
                                </xsl:when>
                                <xsl:when test="./tei:surname/text()">
                                    <xsl:value-of select="./tei:surname/text()"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="."/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when
                                    test="@type = 'person_geburtsname-vorname' and $namensformen/descendant::tei:persName[@type = 'person_geburtsname_nachname']">
                                    <xsl:text>geboren </xsl:text>
                                    <xsl:value-of
                                        select="concat(., ' ', $namensformen/descendant::tei:persName[@type = 'person_geburtsname_nachname'][1])"
                                    />
                                </xsl:when>
                                <xsl:when
                                    test="@type = 'person_geburtsname-nachname' and $namensformen/descendant::tei:persName[@type = 'person_geburtsname_vorname'][1]"/>
                                <xsl:when test="@type = 'person_adoptierter-nachname'">
                                    <xsl:text>Nachname durch Adoption </xsl:text>
                                    <xsl:value-of select="."/>
                                </xsl:when>
                                <xsl:when test="@type = 'person_variante-nachname-vorname'">
                                    <xsl:text>Namensvariante </xsl:text>
                                    <xsl:value-of select="."/>
                                </xsl:when>
                                <xsl:when test="@type = 'person_namensvariante'">
                                    <xsl:text>Namensvariante </xsl:text>
                                    <xsl:value-of select="."/>
                                </xsl:when>
                                <xsl:when test="@type = 'person_rufname'">
                                    <xsl:text>Rufname </xsl:text>
                                    <xsl:value-of select="."/>
                                </xsl:when>
                                <xsl:when test="@type = 'person_pseudonym'">
                                    <xsl:text>Pseudonym </xsl:text>
                                    <xsl:value-of select="."/>
                                </xsl:when>
                                <xsl:when test="@type = 'person_ehename'">
                                    <xsl:text>Ehename </xsl:text>
                                    <xsl:value-of select="."/>
                                </xsl:when>
                                <xsl:when test="@type = 'person_geschieden'">
                                    <xsl:text>geschieden </xsl:text>
                                    <xsl:value-of select="."/>
                                </xsl:when>
                                <xsl:when test="@type = 'person_verwitwet'">
                                    <xsl:text>verwitwet </xsl:text>
                                    <xsl:value-of select="."/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </p>
            </xsl:for-each>
            <xsl:if test=".//tei:occupation">
                <xsl:variable name="entity" select="."/>
                <p>
                    <xsl:if test="$entity/descendant::tei:occupation">
                        <i>
                            <xsl:for-each select="$entity/descendant::tei:occupation">
                                <xsl:variable name="beruf" as="xs:string">
                                    <xsl:choose>
                                        <xsl:when test="contains(., '&gt;&gt;')">
                                            <xsl:value-of select="tokenize(., '&gt;&gt;')[last()]"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="."/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:choose>
                                    <xsl:when test="$entity/tei:sex/@value = 'male'">
                                        <xsl:value-of select="tokenize($beruf, '/')[1]"/>
                                    </xsl:when>
                                    <xsl:when test="$entity/tei:sex/@value = 'female'">
                                        <xsl:value-of select="tokenize($beruf, '/')[2]"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$beruf"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:if test="not(position() = last())">
                                    <xsl:text>, </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </i>
                    </xsl:if>
                </p>
            </xsl:if>
            <div class="werke">
                <xsl:if test="key('authorwork-lookup', @xml:id, $works)[1]">
                    <h2>Werke</h2>
                </xsl:if>
                <p/>
                <ul class="dashed">
                    <xsl:variable name="author-ref" select="@xml:id"/>
                    <xsl:for-each
                        select="key('authorwork-lookup', @xml:id, $works)[not(tei:relatedItem)]">
                        <li>
                            <xsl:if test="tei:author[2]">
                                <xsl:text>(mit </xsl:text>
                                <xsl:for-each select="tei:author[not(@key = $author-ref)]">
                                    <xsl:value-of select="."/>
                                    <xsl:choose>
                                        <xsl:when test="position() = last()">
                                            <xsl:text>: </xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>, </xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                                <xsl:text>) </xsl:text>
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when test="tei:title[@type ='main' and tei:title[@level='m']]"/>
                                <xsl:when test="tei:title[@type ='main'] and tei:title[@level]">
                                <span class="titel">
                                    <xsl:value-of select="tei:title[@type ='main']"/>
                                </span>
                                <xsl:if
                                    test="not(ends-with(tei:title[@type ='main'], '?') or ends-with(tei:title[@type ='main'], '!') or ends-with(tei:title[@type ='main'], '.'))">
                                    <xsl:text>. </xsl:text>
                                </xsl:if>
                                <xsl:text>In: </xsl:text>
                                </xsl:when>
                                <xsl:when test="tei:title[@type ='main']">
                                    <span class="titel">
                                        <xsl:value-of select="tei:title[@type ='main']"/>
                                    </span>
                                    <xsl:if
                                        test="not(ends-with(tei:title[@type ='main'], '?') or ends-with(tei:title[@type ='main'], '!') or ends-with(tei:title[@type ='main'], '.'))">
                                        <xsl:text>. </xsl:text>
                                    </xsl:if>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="tei:title[@level = 'm']">
                                    <span class="titel">
                                        <xsl:value-of select="tei:title[@level = 'm']"/>
                                    </span>
                                    <xsl:if
                                        test="not(ends-with(tei:title[@level = 'm'], '?') or ends-with(tei:title[@level = 'm'], '!') or ends-with(tei:title[@level = 'm'], '.'))">
                                        <xsl:text>. </xsl:text>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:when test="tei:title[@level = 'j']">
                                    <span class="titel">
                                        <xsl:value-of select="tei:title[@level = 'j']"/>
                                    </span>
                                    <xsl:if
                                        test="not(ends-with(tei:title[@level = 'j'], '?') or ends-with(tei:title[@level = 'j'], '!') or ends-with(tei:title[@level = 'j'], '.'))">
                                        <xsl:text>. </xsl:text>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:when test="tei:title[@level = 's']">
                                    <span class="titel">
                                        <xsl:value-of select="tei:title[@level = 's']"/>
                                    </span>
                                    <xsl:if
                                        test="not(ends-with(tei:title[@level = 's'], '?') or ends-with(tei:title[@level = 's'], '!') or ends-with(tei:title[@level = 's'], '.'))">
                                        <xsl:text>. </xsl:text>
                                    </xsl:if>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:if test="tei:editor[@role = 'hrsg']">
                                <xsl:text>Hrsg. </xsl:text>
                                <xsl:for-each select="tei:editor[@role = 'hrsg']">
                                    <xsl:value-of select="."/>
                                    <xsl:choose>
                                        <xsl:when test="position() = last()">
                                            <xsl:text>:</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>, </xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:if>
                            <xsl:if test="tei:editor[@role = 'translator']">
                                <xsl:choose>
                                    <xsl:when test="tei:editor[@role = 'translator']/text() = ''">
                                        <xsl:text>[Ohne Übersetzerangabe.] </xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>Übersetzt von </xsl:text>
                                        <xsl:for-each select="tei:editor[@role = 'translator']">
                                            <xsl:value-of select="."/>
                                            <xsl:choose>
                                                <xsl:when test="position() = last()">
                                                  <xsl:text>. </xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:text>, </xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <xsl:if test="not(tei:editor[@role = 'translator']) and tei:relatedItem">
                                <xsl:text>[Ohne Übersetzerangabe.] </xsl:text>
                            </xsl:if>
                            <xsl:if test="tei:pubPlace">
                                <xsl:for-each select="tei:pubPlace">
                                    <xsl:apply-templates/>
                                    <xsl:choose>
                                        <xsl:when test="position() = last()">
                                            <xsl:text> </xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>, </xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:if>
                            <xsl:if test="tei:date">
                                <xsl:choose>
                                    <xsl:when test="contains(tei:date[1], '–')">
                                        <xsl:choose>
                                            <xsl:when test="normalize-space(tokenize(tei:date[1], '–')[1]) = normalize-space(tokenize(tei:date[1], '–')[2])">
                                                <xsl:value-of select="mam:normalize-date(normalize-space((tokenize(tei:date[1], '–')[1])))"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="mam:normalize-date(normalize-space(tei:date[1]))"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="mam:normalize-date(tei:date[1])"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when test="tei:title[@level = 'm'] and tei:title[@level = 's']">
                                    <xsl:text> (</xsl:text>
                                    <span class="titel">
                                        <xsl:value-of select="tei:title[@level = 's']"/>
                                    </span>
                                    <xsl:text>)</xsl:text>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:if test="tei:note">
                                <xsl:if test="parent::*/child::*[2]">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:text>[</xsl:text>
                                <xsl:for-each select="tei:note[@type='work_kind']">
                                    <xsl:value-of select="normalize-space(tokenize(., '&gt;&gt;')[last()])"/>
                                    <xsl:if test="not(position()=last())">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:if test="tei:note[@type='work_kind'] and tei:note[not(@type='work_kind')]"><xsl:text>; </xsl:text></xsl:if>
                                <xsl:value-of select="normalize-space(tei:note[not(@type='work_kind')][1])"/>
                                <xsl:text>]</xsl:text>
                            </xsl:if><xsl:text> </xsl:text>
                                    <xsl:variable name="idnos-of-current" as="node()">
                                        <xsl:element name="nodeset_person">
                                            <xsl:for-each select="tei:idno">
                                                <xsl:copy-of select="."/>
                                            </xsl:for-each>
                                        </xsl:element>
                                    </xsl:variable>
                                    <xsl:call-template name="mam:idnosToLinks">
                                        <xsl:with-param name="idnos-of-current" select="$idnos-of-current"/>
                                    </xsl:call-template>
                        </li>
                    </xsl:for-each>
                    <!-- schneller hack für den fall, dass @ref statt @key verwendet wird: einfach code verdoppelt -->
                    <xsl:for-each
                        select="key('authorwork-lookup-ref', @xml:id, $works)[not(tei:relatedItem)]">
                        <li>
                            <xsl:if test="tei:author[2]">
                                <xsl:text>(mit </xsl:text>
                                <xsl:for-each select="tei:author[not(@ref = $author-ref)]">
                                    <xsl:value-of select="."/>
                                    <xsl:choose>
                                        <xsl:when test="position() = last()">
                                            <xsl:text>: </xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>, </xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                                <xsl:text>) </xsl:text>
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when test="tei:title[@type ='main'] and tei:title[@level='m']"/>
                                <xsl:when test="tei:title[@type ='main'] and tei:title[@level]">
                                    <span class="titel">
                                        <xsl:value-of select="tei:title[@type ='main']"/>
                                    </span>
                                    <xsl:if
                                        test="not(ends-with(tei:title[@type ='main'], '?') or ends-with(tei:title[@type ='main'], '!') or ends-with(tei:title[@type ='main'], '.'))">
                                        <xsl:text>. </xsl:text>
                                    </xsl:if>
                                    <xsl:text>In: </xsl:text>
                                </xsl:when>
                                <xsl:when test="tei:title[@type ='main']">
                                    <span class="titel" >
                                        <xsl:value-of select="tei:title[@type ='main']"/>
                                    </span>
                                    <xsl:if
                                        test="not(ends-with(tei:title[@type ='main'], '?') or ends-with(tei:title[@type ='main'], '!') or ends-with(tei:title[@type ='main'], '.'))">
                                        <xsl:text>. </xsl:text>
                                    </xsl:if>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="tei:title[@level = 'm']">
                                    <span class="titel">
                                        <xsl:value-of select="tei:title[@level = 'm']"/>
                                    </span>
                                    <xsl:if
                                        test="not(ends-with(tei:title[@level = 'm'], '?') or ends-with(tei:title[@level = 'm'], '!') or ends-with(tei:title[@level = 'm'], '.'))">
                                        <xsl:text>. </xsl:text>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:when test="tei:title[@level = 'j']">
                                    <span class="titel">
                                        <xsl:value-of select="tei:title[@level = 'j']"/>
                                    </span>
                                    <xsl:if
                                        test="not(ends-with(tei:title[@level = 'j'], '?') or ends-with(tei:title[@level = 'j'], '!') or ends-with(tei:title[@level = 'j'], '.'))">
                                        <xsl:text>. </xsl:text>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:when test="tei:title[@level = 's']">
                                    <span class="titel">
                                        <xsl:value-of select="tei:title[@level = 's']"/>
                                    </span>
                                    <xsl:if
                                        test="not(ends-with(tei:title[@level = 's'], '?') or ends-with(tei:title[@level = 's'], '!') or ends-with(tei:title[@level = 's'], '.'))">
                                        <xsl:text>. </xsl:text>
                                    </xsl:if>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:if test="tei:editor[@role = 'hrsg']">
                                <xsl:text>Hrsg. </xsl:text>
                                <xsl:for-each select="tei:editor[@role = 'hrsg']">
                                    <xsl:value-of select="."/>
                                    <xsl:choose>
                                        <xsl:when test="position() = last()">
                                            <xsl:text>:</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>, </xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:if>
                            <xsl:if test="tei:editor[@role = 'translator']">
                                <xsl:choose>
                                    <xsl:when test="tei:editor[@role = 'translator']/text() = ''">
                                        <xsl:text>[Ohne Übersetzerangabe.] </xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>Übersetzt von </xsl:text>
                                        <xsl:for-each select="tei:editor[@role = 'translator']">
                                            <xsl:value-of select="."/>
                                            <xsl:choose>
                                                <xsl:when test="position() = last()">
                                                    <xsl:text>. </xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:text>, </xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <xsl:if test="not(tei:editor[@role = 'translator']) and tei:relatedItem">
                                <xsl:text>[Ohne Übersetzerangabe.] </xsl:text>
                            </xsl:if>
                            <xsl:if test="tei:pubPlace">
                                <xsl:for-each select="tei:pubPlace">
                                    <xsl:apply-templates/>
                                    <xsl:choose>
                                        <xsl:when test="position() = last()">
                                            <xsl:text> </xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>, </xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:if>
                            <xsl:if test="tei:date">
                                <xsl:choose>
                                    <xsl:when test="contains(tei:date[1], '–')">
                                        <xsl:choose>
                                            <xsl:when test="normalize-space(tokenize(tei:date[1], '–')[1]) = normalize-space(tokenize(tei:date[1], '–')[2])">
                                                <xsl:value-of select="mam:normalize-date(normalize-space((tokenize(tei:date[1], '–')[1])))"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="mam:normalize-date(normalize-space(tei:date[1]))"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="mam:normalize-date(tei:date[1])"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when test="tei:title[@level = 'm'] and tei:title[@level = 's']">
                                    <xsl:text> (</xsl:text>
                                    <span class="titel">
                                        <xsl:value-of select="tei:title[@level = 's']"/>
                                    </span>
                                    <xsl:text>)</xsl:text>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:if test="tei:note">
                                <xsl:if test="parent::*/child::*[2]">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:text>[</xsl:text>
                                <xsl:for-each select="tei:note[@type='work_kind']">
                                    <xsl:value-of select="normalize-space(tokenize(., '&gt;&gt;')[last()])"/>
                                    <xsl:if test="not(position()=last())">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:if test="tei:note[@type='work_kind'] and tei:note[not(@type='work_kind')]"><xsl:text>; </xsl:text></xsl:if>
                                <xsl:for-each select="tei:note[not(@type='work_kind')]">
                                    <xsl:value-of select="normalize-space(tokenize(., '&gt;&gt;')[last()])"/>
                                    <xsl:if test="not(position()=last())">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:text>]</xsl:text>
                            </xsl:if><xsl:text> </xsl:text>
                            <xsl:variable name="idnos-of-current" as="node()">
                                <xsl:element name="nodeset_work">
                                    <xsl:for-each select="tei:idno">
                                        <xsl:copy-of select="."/>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:variable>
                            <xsl:call-template name="mam:idnosToLinks">
                                <xsl:with-param name="idnos-of-current" select="$idnos-of-current"/>
                            </xsl:call-template>
                        </li>
                    </xsl:for-each>
                </ul>
            </div>
        </div>
    </xsl:template>
    <xsl:function name="mam:pmbChange">
        <xsl:param name="url" as="xs:string"/>
        <xsl:param name="entitytyp" as="xs:string"/>
        <xsl:value-of select="
                concat('https://pmb.acdh.oeaw.ac.at/apis/entities/entity/', $entitytyp, '/',
                substring-after($url, 'https://pmb.acdh.oeaw.ac.at/entity/'), '/detail')"/>
    </xsl:function>
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
            <xsl:when test="$typityp = 'pmb'">
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
            <xsl:when test="$typityp = 'jugend-in-wien'">
                <xsl:text> Jugend in Wien</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'gnd'">
                <xsl:text> Wikipedia?</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'schnitzler-bahr'">
                <xsl:text> Bahr/Schnitzler</xsl:text>
            </xsl:when>
            <xsl:when test="$typityp = 'widmungDLA'">
                <xsl:text> Widmung DLA</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$typityp"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:template match="tei:supplied">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
    </xsl:template>
</xsl:stylesheet>
