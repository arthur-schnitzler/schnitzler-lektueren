<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:df="http://example.com/df"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    
    
    <xsl:template match="tei:bibl" name="work_detail">
        <xsl:param name="showNumberOfMentions" as="xs:integer" select="50000" />
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
         <div class="card-body-tagebuch w-75">
            <div>
                <span class="infodesc mr-2">Titel</span>
                <span><xsl:value-of select=".//tei:title/text()"/></span>
            </div>
            <div class="mt-2">
                <span class="infodesc mr-2">Verfasser:in</span>
                <span><xsl:value-of select=".//tei:surname/text()"/>, <xsl:value-of select=".//tei:forename/text()"/></span> 
            </div>          
            <div id="mentions" class="mt-2">
                <span class="infodesc mr-2">Erwähnt am</span>
                
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>