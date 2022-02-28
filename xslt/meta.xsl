<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:import href="partials/osd-container.xsl"/>
    <!--<xsl:import href="partials/tei-facsimile.xsl"/>-->
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:titleStmt/tei:title[@level='a'][1]/text()"/>
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
                                <xsl:apply-templates select=".//tei:body"></xsl:apply-templates>
                            </div>
                            <div>
                            <xsl:if test="descendant::tei:note">
                                <div class="card-body-notes">
                                    <xsl:text>Anmerkungen</xsl:text>
                                    <xsl:element name="ol">
                                        <xsl:attribute name="notes">
                                            <xsl:text>list-for-notes</xsl:text>
                                        </xsl:attribute>
                                        <xsl:apply-templates select="descendant::tei:note"
                                            mode="note"/>
                                    </xsl:element>
                                </div>
                            </xsl:if>
                            </div>
                        </div>                       
                    </div>
                    <xsl:call-template name="html_footer"/>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:p">
        <xsl:choose>
            <xsl:when test="@rend='right'">
                <p id="{generate-id()}" class="rechtsbuendig"><xsl:apply-templates/></p>
            </xsl:when>
            <xsl:when test="@rend='center'">
                <p id="{generate-id()}" class="mittig"><xsl:apply-templates/></p>
            </xsl:when>
            <xsl:otherwise>
                <p id="{generate-id()}"><xsl:apply-templates/></p>
            </xsl:otherwise>
        </xsl:choose>
        
        
    </xsl:template>
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
    <xsl:template match="tei:div">
        <div id="{generate-id()}"><xsl:apply-templates/></div>
    </xsl:template>
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <xsl:template match="tei:unclear">
        <abbr title="unclear"><xsl:apply-templates/></abbr>
    </xsl:template>
    <xsl:template match="tei:del">
        <del><xsl:apply-templates/></del>
    </xsl:template>    
    <xsl:template match="tei:head">
        <xsl:choose>
            <xsl:when test="not(@level)">
                <h1><xsl:apply-templates/></h1>
            </xsl:when>
            <xsl:when test="@level">
                <xsl:element name="{concat('h',@level)}">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:note">
        <xsl:if test="preceding-sibling::*[1][name() = 'note']">
            <!-- Sonderregel für zwei Fußnoten in Folge -->
            <sup>
                <xsl:text>,</xsl:text>
            </sup>
        </xsl:if>
        <xsl:element name="a">
            <xsl:attribute name="class">
                <xsl:text>reference-black</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#note</xsl:text>
                <xsl:number level="any" count="tei:note" format="1"/>
            </xsl:attribute>
            <sup>
                <xsl:number level="any" count="tei:note" format="1"/>
            </sup>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:note" mode="note">
        <xsl:element name="li">
            <xsl:attribute name="id">
                <xsl:text>note</xsl:text>
                <xsl:number level="any" count="tei:note" format="1"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:p[ancestor::tei:note]">
        <span>
            <xsl:apply-templates/>
        </span>
        <lb/>
    </xsl:template>
    
    <xsl:template match="tei:body//tei:listBibl">
        <ul class="dashed">
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:body//tei:listBibl/tei:bibl">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
</xsl:stylesheet>