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
               <p class="personenname">
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
               </xsl:choose></p>
           </xsl:for-each>
            
            <xsl:if test=".//tei:occupation">
                <p>
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
                </p></xsl:if>
            <div id="mentions">
                <p><a href="{concat('Leseliste.html#',@xml:id)}" class="blinkwink leseliste-button">Leseliste</a></p></div>
            
            <p id="button-group">
            <xsl:for-each
                select="child::tei:idno[not(@type = 'schnitzler-lektueren') and not(@type='gnd')]">
                <xsl:choose>
                    <xsl:when test="not(.='')">
                       <span>
                        <xsl:element name="a">
                            <xsl:attribute name="class">
                                <xsl:choose>
                                    <xsl:when test="@type='gnd'">
                                        <xsl:text>wikipedia-button</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="@type='schnitzler-briefe'">
                                        <xsl:text>briefe-button</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="@type='schnitzler-tagebuch'">
                                        <xsl:text>tagebuch-button</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="@type='bahrschnitzler'">
                                        <xsl:text>bahrschnitzler-button</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@type"/><xsl:text>XXXX</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:attribute name="href">
                                        <xsl:value-of select="."/>
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
                       </span><xsl:text> </xsl:text>
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
                <xsl:attribute name="class">
                    <xsl:text>PMB-button</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:value-of select="concat('https://pmb.acdh.oeaw.ac.at/apis/entities/entity/person/', substring-after(./@xml:id,'pmb') , '/detail')"/>
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
            
            </p>

            <xsl:if test="child::tei:idno[@type='gnd']">
                <p id="button-group">
                                <xsl:element name="a">
                                    <xsl:attribute name="class">
                                                <xsl:text>wikipedia-button</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="replace(child::tei:idno[@type='gnd'], 'https://d-nb.info/gnd/', 'http://tools.wmflabs.org/persondata/redirect/gnd/de/')"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="target">
                                        <xsl:text>_blank</xsl:text>
                                    </xsl:attribute>
                                    <xsl:element name="span">
                                        <xsl:attribute name="class">
                                            <xsl:text>wikipedia-color</xsl:text>
                                        </xsl:attribute>
                                        <xsl:value-of select="mam:ahref-namen('gnd')"/>
                                    </xsl:element>
                                </xsl:element>
                </p>
            </xsl:if>
                        
                       
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