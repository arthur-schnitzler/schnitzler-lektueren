<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" version="3.0">
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:output method="xml" indent="yes"/>
    
  <!-- Bei Werken werden nur die Idnos neu geholt, der Rest bleibt -->
    
   
    <xsl:template match="tei:listBibl/tei:bibl">
        <xsl:element name="bibl" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
        <xsl:variable name="nummer" select="replace(@xml:id,'pmb','')"/>
        <xsl:variable name="eintrag"
            select="fn:escape-html-uri(concat('https://pmb.acdh.oeaw.ac.at/apis/entities/tei/work/', $nummer))"
            as="xs:string"/>
            <xsl:choose>
                <xsl:when test="doc-available($eintrag)">
                    <xsl:copy-of select="document($eintrag)/child::bibl/*" copy-namespaces="no"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="error">
                        <xsl:attribute name="type">
                            <xsl:text>bibl</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="$nummer"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:copy-of select="tei:pubPlace|tei:note[not(@type='collections')]|tei:ref|tei:relatedItem|tei:editor|tei:title[not(@level='a')]"/>
            <xsl:if test="tei:ref">
                <xsl:for-each select="tei:ref">
                    <xsl:element name="idno">
                        <xsl:attribute name="type">
                            <xsl:text>URL</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="subtype">
                            <xsl:value-of select="@type"/>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    
    
    
    
    
</xsl:stylesheet>
