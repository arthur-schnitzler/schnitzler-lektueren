<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/person.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select="concat(.//tei:listPerson/tei:persName[1]/tei:forename/text(), ' ', .//tei:listPerson/tei:persName[1]/tei:surname/text())"/>
        </xsl:variable>
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
        <html>
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
            </xsl:call-template>
            
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    
                    <div class="container-fluid">                        
                        <div class="card">
                            <div class="card-header">
                                <h1><xsl:value-of select="$doc_title"/></h1>
                            </div>
                            <div class="card-body">                                
                                <table class="table table-striped display" id="tocTable" style="width:100%">
                                    <thead>
                                        <tr>
                                            <th scope="col">Nachname</th>
                                            <th scope="col">Vorname</th>
                                            <th scope="col">Lebensdaten</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each select=".//tei:person[@xml:id]">
                                            <xsl:variable name="id">
                                                <xsl:value-of select="data(@xml:id)"/>
                                            </xsl:variable>
                                            <tr>
                                                <td>
                                                    <a>
                                                        <xsl:attribute name="href">
                                                            <xsl:value-of select="concat($id, '.html')"/>
                                                        </xsl:attribute>
                                                    <xsl:value-of select="tei:persName[1]/tei:surname/text()"/>
                                                    </a>
                                                </td>
                                                <td>     
                                                    <a>
                                                        <xsl:attribute name="href">
                                                            <xsl:value-of select="concat($id, '.html')"/>
                                                        </xsl:attribute>
                                                    <xsl:value-of select="tei:persName[1]/tei:forename/text()"/>
                                                    </a>
                                                </td>
                                                <td>
                                                    <a>
                                                        <xsl:attribute name="href">
                                                            <xsl:value-of select="concat($id, '.html')"/>
                                                        </xsl:attribute>
                                                        <xsl:choose>
                                                            <xsl:when test="tei:birth/tei:date and tei:death/tei:date">
                                                                <xsl:choose>
                                                                    <xsl:when test="contains(tei:birth/tei:date/text(), '.') or contains(tei:death/tei:date/text(), '.')">
                                                                        <xsl:value-of select="concat(tei:birth/tei:date, ' – ', tei:death/tei:date)"/>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:value-of select="concat(tei:birth/tei:date, '–', tei:death/tei:date)"/>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:when>
                                                            <xsl:when test="tei:birth/tei:date">
                                                                <xsl:text>* </xsl:text>
                                                                <xsl:value-of select="tei:birth/tei:date"/>
                                                            </xsl:when>
                                                            <xsl:when test="tei:death/tei:date">
                                                                <xsl:text>† </xsl:text>
                                                                <xsl:value-of select="tei:death/tei:date"/>
                                                            </xsl:when>
                                                        </xsl:choose>
                                                    </a> 
                                                </td>
                                            </tr>
                                        </xsl:for-each>
                                    </tbody>
                                </table>
                            </div>
                        </div>                       
                    </div>
                    <xsl:call-template name="html_footer"/>
                    <script>
                        $(document).ready(function () {
                        createDataTable('tocTable')
                        });
                    </script>
                </div>
            </body>
        </html>
        <xsl:for-each select=".//tei:person[@xml:id]">
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')"/>
            <xsl:variable name="name" select="normalize-space(string-join(./tei:persName[1]//text()))"/>
            <xsl:variable name="lebensdaten_geburtsdatum-und-ort" select="./tei:birth[1]/tei:date[1]//text()"/>
            
            <xsl:result-document href="{$filename}">
                <html xmlns="http://www.w3.org/1999/xhtml">
                    <xsl:call-template name="html_head">
                        <xsl:with-param name="html_title" select="$name"></xsl:with-param>
                    </xsl:call-template>
                    
                    <body class="page">
                        <div class="hfeed site" id="page">
                            <xsl:call-template name="nav_bar"/>
                            
                            <div class="container-fluid">
                                <div class="card">
                                    <div class="card-header">
                                        <h1>
                                            <xsl:value-of select="$name"/><xsl:text> </xsl:text>
                                            <xsl:choose>
                                                <xsl:when test="./tei:birth and ./tei:death">
                                                    <span class="lebensdaten"><xsl:text>(</xsl:text>
                                                        <xsl:choose>
                                                            <xsl:when test="./tei:birth/tei:date and ./tei:birth/tei:placeName/tei:settlement">
                                                                <xsl:value-of select="concat(./tei:birth/tei:date, ' ', ./tei:birth/tei:placeName/tei:settlement)"/>
                                                            </xsl:when>
                                                            <xsl:when test="./tei:birth/tei:date">
                                                                <xsl:value-of select="./tei:birth/tei:date"/>
                                                            </xsl:when>
                                                            <xsl:when test="./tei:birth/tei:placeName/tei:settlement">
                                                                <xsl:value-of select="concat('geboren in ',./tei:birth/tei:placeName/tei:settlement)"/>
                                                            </xsl:when>
                                                        </xsl:choose>
                                                        <xsl:text> – </xsl:text>  
                                                        <xsl:choose>
                                                            <xsl:when test="./tei:death/tei:date and ./tei:death/tei:placeName/tei:settlement">
                                                                <xsl:value-of select="concat(./tei:death/tei:date, ' ', ./tei:death/tei:placeName/tei:settlement)"/>
                                                            </xsl:when>
                                                            <xsl:when test="./tei:death/tei:date">
                                                                <xsl:value-of select="./tei:death/tei:date"/>
                                                            </xsl:when>
                                                            <xsl:when test="./tei:death/tei:placeName/tei:settlement">
                                                                <xsl:value-of select="concat('geboren in ',./tei:death/tei:placeName/tei:settlement)"/>
                                                            </xsl:when>
                                                        </xsl:choose>   
                                                        <xsl:text>)</xsl:text>
                                                    </span>
                                                </xsl:when>
                                                <xsl:when test="./tei:birth">
                                                    <span class="lebensdaten"><xsl:text>(geboren </xsl:text>
                                                        <xsl:choose>
                                                            <xsl:when test="./tei:birth/tei:date and ./tei:birth/tei:placeName/tei:settlement">
                                                                <xsl:value-of select="concat(./tei:birth/tei:date, ' ', ./tei:birth/tei:placeName/tei:settlement)"/>
                                                            </xsl:when>
                                                            <xsl:when test="./tei:birth/tei:date">
                                                                <xsl:value-of select="./tei:birth/tei:date"/>
                                                            </xsl:when>
                                                            <xsl:when test="./tei:birth/tei:placeName/tei:settlement">
                                                                <xsl:value-of select="concat('geboren in ',./tei:birth/tei:placeName/tei:settlement)"/>
                                                            </xsl:when>
                                                        </xsl:choose>
                                                        <xsl:text>)</xsl:text>
                                                    </span>
                                                </xsl:when>
                                                <xsl:when test="./tei:death">
                                                    <span class="lebensdaten"><xsl:text>(† </xsl:text>
                                                        <xsl:choose>
                                                            <xsl:when test="./tei:death/tei:date and ./tei:death/tei:placeName/tei:settlement">
                                                                <xsl:value-of select="concat(./tei:death/tei:date, ' ', ./tei:death/tei:placeName/tei:settlement)"/>
                                                            </xsl:when>
                                                            <xsl:when test="./tei:death/tei:date">
                                                                <xsl:value-of select="./tei:death/tei:date"/>
                                                            </xsl:when>
                                                            <xsl:when test="./tei:death/tei:placeName/tei:settlement">
                                                                <xsl:value-of select="concat('geboren in ',./tei:death/tei:placeName/tei:settlement)"/>
                                                            </xsl:when>
                                                        </xsl:choose>   
                                                        <xsl:text>)</xsl:text>
                                                    </span>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <span class="lebensdaten"><xsl:text>ERROR 287 Lebensdaten</xsl:text></span>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            
                                            
                                        </h1>
                                    </div>
                                    <xsl:call-template name="person_detail"/>
                                </div>
                            </div>
                            
                            <xsl:call-template name="html_footer"/>
                        </div>
                    </body>
                </html>
            </xsl:result-document>
            
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>