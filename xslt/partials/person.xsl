<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mam="personalShit"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    
    <xsl:template match="tei:person" name="person_detail">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="50000" />
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <div class="card-body">
           <xsl:for-each select="tei:persName[not(position()=1)]">
               <span class="personenname">
               <xsl:choose>
                   <xsl:when test="./tei:forename/text() and ./tei:surname/text()">
                       <xsl:value-of select="concat(./tei:forename/text(),' ',./tei:surname/text())"/>
                   </xsl:when>
                   <xsl:when test="./tei:forename/text()">
                       <xsl:value-of select="./tei:forename/text()"/>
                   </xsl:when>
                   <xsl:otherwise>
                       <xsl:value-of select="./tei:surname/text()"/>
                   </xsl:otherwise>
               </xsl:choose></span>
               <br/>
           </xsl:for-each>
            <xsl:choose>
                <xsl:when test=".//tei:birth and .//tei:death">
                    <span class="lebensdaten"><xsl:text>(</xsl:text>
                    <xsl:choose>
                        <xsl:when test=".//tei:birth/tei:date and .//tei:birth/tei:placeName/tei:settlement">
                            <xsl:value-of select="concat(.//tei:birth/tei:date, ' ', .//tei:birth/tei:placeName/tei:settlement)"/>
                        </xsl:when>
                        <xsl:when test=".//tei:birth/tei:date">
                            <xsl:value-of select=".//tei:birth/tei:date"/>
                        </xsl:when>
                        <xsl:when test=".//tei:birth/tei:placeName/tei:settlement">
                            <xsl:value-of select="concat('geboren in ',.//tei:birth/tei:placeName/tei:settlement)"/>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:text> – </xsl:text>  
                        <xsl:choose>
                            <xsl:when test=".//tei:death/tei:date and .//tei:death/tei:placeName/tei:settlement">
                                <xsl:value-of select="concat(.//tei:death/tei:date, ' ', .//tei:death/tei:placeName/tei:settlement)"/>
                            </xsl:when>
                            <xsl:when test=".//tei:death/tei:date">
                                <xsl:value-of select=".//tei:death/tei:date"/>
                            </xsl:when>
                            <xsl:when test=".//tei:death/tei:placeName/tei:settlement">
                                <xsl:value-of select="concat('geboren in ',.//tei:death/tei:placeName/tei:settlement)"/>
                            </xsl:when>
                        </xsl:choose>   
                        <xsl:text>)</xsl:text><br/>
                    </span>
                </xsl:when>
                <xsl:when test=".//tei:birth">
                    <span class="lebensdaten"><xsl:text>(geboren </xsl:text>
                        <xsl:choose>
                            <xsl:when test=".//tei:birth/tei:date and .//tei:birth/tei:placeName/tei:settlement">
                                <xsl:value-of select="concat(.//tei:birth/tei:date, ' ', .//tei:birth/tei:placeName/tei:settlement)"/>
                            </xsl:when>
                            <xsl:when test=".//tei:birth/tei:date">
                                <xsl:value-of select=".//tei:birth/tei:date"/>
                            </xsl:when>
                            <xsl:when test=".//tei:birth/tei:placeName/tei:settlement">
                                <xsl:value-of select="concat('geboren in ',.//tei:birth/tei:placeName/tei:settlement)"/>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:text>)</xsl:text><br/>
                    </span>
                </xsl:when>
                <xsl:when test=".//tei:death">
                    <span class="lebensdaten"><xsl:text>(† </xsl:text>
                        <xsl:choose>
                            <xsl:when test=".//tei:death/tei:date and .//tei:death/tei:placeName/tei:settlement">
                                <xsl:value-of select="concat(.//tei:death/tei:date, ' ', .//tei:death/tei:placeName/tei:settlement)"/>
                            </xsl:when>
                            <xsl:when test=".//tei:death/tei:date">
                                <xsl:value-of select=".//tei:death/tei:date"/>
                            </xsl:when>
                            <xsl:when test=".//tei:death/tei:placeName/tei:settlement">
                                <xsl:value-of select="concat('geboren in ',.//tei:death/tei:placeName/tei:settlement)"/>
                            </xsl:when>
                        </xsl:choose>   
                        <xsl:text>)</xsl:text><br/>
                    </span>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>ERROR 287 Lebensdaten</xsl:text><br/>
                </xsl:otherwise>
            </xsl:choose>
           <xsl:for-each select=".//tei:occupation">
               <xsl:value-of select="."/>
               <xsl:choose>
                   <xsl:when test="not(position()=last())">
                       <xsl:text>, </xsl:text>
                   </xsl:when>
                   <xsl:otherwise>
                       <xsl:text>.</xsl:text><br/>
                   </xsl:otherwise>
               </xsl:choose>
           </xsl:for-each>
            <xsl:text>LINKS: </xsl:text>
            <xsl:for-each
                select="child::tei:idno[not(@type = 'schnitzler-lektueren')]">
                <xsl:choose>
                    <xsl:when test="not(.='')">
                        <xsl:element name="a">
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="@type='PMB'">
                                        <xsl:value-of select="mam:pmbChange(., 'person')"/>
                                    </xsl:when>
                                    <xsl:when test="@type='gnd'">
                                        <xsl:value-of select="replace(., 'https://d-nb.info/gnd/', 'http://tools.wmflabs.org/persondata/redirect/gnd/de/')"/>
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
                <xsl:if test="position()=last()">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:element name="a">
                <xsl:attribute name="href">
                    <xsl:value-of select="concat('https://pmb.acdh.oeaw.ac.at/apis/entities/entity/person', ./@xml:id , '/detail')"/>
                </xsl:attribute>
                <xsl:attribute name="target">
                    <xsl:text>_blank</xsl:text>
                </xsl:attribute>
                <xsl:element name="span">
                    <xsl:attribute name="class">
                        <xsl:text>color-PMB</xsl:text>
                    </xsl:attribute>
                    <xsl:text>PMB</xsl:text>
                </xsl:element>
            </xsl:element>
            <br/>
            <div id="mentions">
                <legend>erwähnt in</legend>
                <ul>
                    <xsl:for-each select=".//tei:event">
                        <xsl:variable name="linkToDocument">
                            <xsl:value-of select="replace(tokenize(data(.//@target), '/')[last()], '.xml', '.html')"/>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="position() lt $showNumberOfMentions + 1">
                                <li>
                                    <xsl:value-of select=".//tei:title"/><xsl:text> </xsl:text>
                                    <a href="{$linkToDocument}">
                                        <i class="fas fa-external-link-alt"></i>
                                    </a>
                                </li>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </ul>
                <xsl:if test="count(.//tei:event) gt $showNumberOfMentions + 1">
                    <p>Anzahl der Erwähnungen eingeschränkt, klicke <a href="{$selfLink}">hier</a> für eine vollständige Auflistung</p>
                </xsl:if>
            </div>
        </div>
    </xsl:template>
    <xsl:function name="mam:pmbChange">
        <xsl:param name="url" as="xs:string"/>
        <xsl:param name="entitytyp" as="xs:string"/>
        <xsl:value-of select="concat('https://pmb.acdh.oeaw.ac.at/apis/entities/entity/',$entitytyp, '/',
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
            <xsl:when test="$typityp ='gnd'">
                <xsl:text> Wikipedia?</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$typityp"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>