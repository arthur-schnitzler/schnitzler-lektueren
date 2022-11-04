<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" version="3.0">
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:output method="xml" indent="yes"/>
    
    
    <!-- Das holt die Person neu aus der PMB -->
    <xsl:template match="tei:listPerson/tei:person">
     <xsl:element name="person" namespace="http://www.tei-c.org/ns/1.0">
         <xsl:copy-of select="@*"/>
         <xsl:variable name="nummer" select="replace(@xml:id,'pmb','')"/>
         <xsl:variable name="eintrag"
             select="fn:escape-html-uri(concat('https://pmb.acdh.oeaw.ac.at/apis/entities/tei/person/', $nummer))"
             as="xs:string"/>
         <xsl:choose>
             <xsl:when test="doc-available($eintrag)">
                 <xsl:copy-of select="document($eintrag)/child::person/*" copy-namespaces="no"/>
             </xsl:when>
             <xsl:otherwise>
                 <xsl:element name="error">
                     <xsl:attribute name="type">
                         <xsl:text>person</xsl:text>
                     </xsl:attribute>
                     <xsl:value-of select="$nummer"/>
                 </xsl:element>
             </xsl:otherwise>
         </xsl:choose>
     </xsl:element>
 </xsl:template>
    
    <!-- Das holt die Orts-Idnos neu aus der PMB -->
    <xsl:template match="tei:listPlace/tei:place">
        <xsl:element name="place" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
            <xsl:variable name="nummer" select="replace(@xml:id, 'pmb', '')"/>
            <!--<xsl:variable name="nummer" select="replace(replace(tei:idno[@type='pmb'], 'https://pmb.acdh.oeaw.ac.at/entity/', ''), '/', '')"/>-->
            <xsl:variable name="eintrag"
                select="fn:escape-html-uri(concat('https://pmb.acdh.oeaw.ac.at/apis/entities/tei/place/', $nummer))"
                as="xs:string"/>
            <xsl:copy-of select="descendant::tei:*[parent::tei:place and not(name()=idno)]"/>
            <xsl:choose>
                <xsl:when test="doc-available($eintrag)">
                    <xsl:copy-of select="document($eintrag)/descendant::place/idno"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="error">
                        <xsl:attribute name="type">
                            <xsl:text>place</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="$nummer"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    
    
 <!-- holt werke neu. pubPlace, notes werden kopiert 
 
 aus faulheit habe ich noch dieses suchen und ersetzen
 auf das ergebnis gemacht, als das mit einem xslt zu korrigieren:
 
 "person__" zu "pmb"
 
 -->
    
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
