<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:df="http://example.com/df"
    xmlns:mam="whatever" version="3.0" exclude-result-prefixes="xsl tei xs">
    <xsl:import href="LOD-idnos.xsl"/>
    <xsl:param name="relevant-uris" select="document('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-chronik-static/refs/heads/main/xslt/export/list-of-relevant-uris.xml')"/>
    <xsl:key name="only-relevant-uris" match="item" use="abbr"/>
    <xsl:param name="works"
        select="document('../../data/indices/listwork.xml')"/>
    <xsl:key name="work-lookup" match="tei:bibl" use="tei:relatedItem/@target"/>
    <xsl:param name="konkordanz"
        select="document('../../data/indices/konkordanz.xml')"/>
    <xsl:key name="konk-lookup" match="ref" use="@xml:id"/>
    <xsl:template match="tei:bibl" name="work_detail">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="50000"/>
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="card-body-tagebuch w-75">
            <div id="mentions">
                <xsl:if test="key('only-relevant-uris', tei:idno/@subtype, $relevant-uris)[1]">
                    <p class="buttonreihe">
                        <xsl:variable name="link"
                            select="key('konk-lookup', tei:author[1]/@key, $konkordanz)[1]/@target"/>
                        <a href="{concat($link, '#', tei:author[1]/@key)}">
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
                        <xsl:text> </xsl:text>
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
                    </p>
                </xsl:if>
            </div>
            <div class="mt-2">
                <span class="infodesc mr-2"><xs:text>&#8594;</xs:text></span>
                <span>
                    <xsl:for-each select="tei:author[@role='hat-geschaffen']">
                        <xsl:variable name="autor-ref">
                            <xsl:choose>
                                <xsl:when test="@ref">
                                    <xsl:value-of select="@ref"/>
                                </xsl:when>
                                <xsl:when test="@key">
                                    <xsl:value-of select="@key"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <a href="{concat($autor-ref,'.html')}">
                            <xsl:value-of select="."/>
                        </a>
                        <xsl:variable name="link"
                            select="key('konk-lookup', $autor-ref, $konkordanz)[1]/@target"/>
                        <xsl:text> </xsl:text>
                        <xsl:if test="not(position() = last())">
                           <br/>
                        </xsl:if>
                    </xsl:for-each>
                </span>
            </div>
            <p/>
            <div>
                <xsl:choose>
                    <xsl:when test="tei:title[@type='main'] and tei:title[@level ='m']"/>
                    <xsl:when test="tei:title[@type='main'] and tei:title[@level]">
                        <span class="titel">
                            <xsl:value-of select="tei:title[@type='main']"/>
                        </span>
                        <xsl:if
                            test="not(ends-with(tei:title[@type='main'], '?') or ends-with(tei:title[@type='main'], '!') or ends-with(tei:title[@type='main'], '.'))">
                            <xsl:text>. </xsl:text>
                        </xsl:if>
                        <xsl:text>In: </xsl:text>
                    </xsl:when>
                    <xsl:when test="tei:title[@type='main'] != tei:title[@level='m']">
                        <span class="titel">
                            <xsl:value-of select="tei:title[@type='main']"/>
                        </span>
                        <xsl:if
                            test="not(ends-with(tei:title[@type='main'], '?') or ends-with(tei:title[@type='main'], '!') or ends-with(tei:title[@type='main'], '.'))">
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
                    <xsl:value-of select="tei:note"/>
                    <xsl:text>]</xsl:text>
                </xsl:if>
                <xsl:if test="key('work-lookup', concat('#', @xml:id), $works)">
                    <ul class="dashed">
                        <xsl:for-each select="key('work-lookup', concat('#', @xml:id), $works)">
                            <li>
                                
                                <xsl:if test="tei:title[@type='main']">
                                    <span class="titel">
                                        <xsl:value-of select="tei:title[@type='main']"/>
                                    </span>
                                    <xsl:if
                                        test="not(ends-with(tei:title[@type='main'], '?') or ends-with(tei:title[@type='main'], '!') or ends-with(tei:title[@type='main'], '.'))">
                                        <xsl:text>. </xsl:text>
                                    </xsl:if>
                                    <xsl:text>In: </xsl:text>
                                </xsl:if>
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
                                        <xsl:when
                                            test="tei:editor[@role = 'translator']/text() = ''">
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
                                <xsl:if
                                    test="not(tei:editor[@role = 'translator']) and tei:relatedItem">
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
                                    <xsl:when
                                        test="tei:title[@level = 'm'] and tei:title[@level = 's']">
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
                                    <xsl:value-of select="tei:note"/>
                                    <xsl:text>]</xsl:text>
                                </xsl:if>
                                
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:supplied">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
    </xsl:template>
</xsl:stylesheet>
