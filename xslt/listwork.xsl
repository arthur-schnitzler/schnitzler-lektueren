<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs"
    xmlns:mam="whatever">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/entities.xsl"/>
    <xsl:import href="./partials/tabulator_js.xsl"/>
    <xsl:param name="work-day" select="document('../data/indices/index_work_day.xml')"/>
    <xsl:key name="work-day-lookup" match="item/@when" use="ref"/>
    <xsl:variable name="teiSource" select="'listwork.xml'"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Verzeichnis erwähnter Werke'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <script src="https://code.highcharts.com/highcharts.js"/>
            <script src="https://code.highcharts.com/modules/networkgraph.js"/>
            <script src="https://code.highcharts.com/modules/exporting.js"/>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container">
                        <div class="card">
                            <div class="card-header" style="text-align:center">
                                <h1>
                                    <xsl:value-of select="$doc_title"/>
                                </h1>
                            </div>
                            <div class="card-body">
                                <div id="container"
                                    style="padding-bottom: 20px; width:100%; margin: auto"/>
                                <div id="chart-buttons" class="text-center mt-3"
                                    style="margin: auto; padding-bottom: 20px">
                                    <button class="btn mx-1 chart-btn"
                                        style="background-color: #A63437; color: white; border: none; padding: 5px 10px; font-size: 0.875rem;"
                                        data-csv="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/work_freq_corp_weights_directed/work_freq_corp_weights_directed_top30.csv"
                                        >Top 30</button>
                                    <button class="btn mx-1 chart-btn"
                                        style="background-color: #A63437; color: white; border: none; padding: 5px 10px; font-size: 0.875rem;"
                                        data-csv="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/work_freq_corp_weights_directed/work_freq_corp_weights_directed_top100.csv"
                                        >Top 100</button>
                                    <button class="btn mx-1 chart-btn"
                                        style="background-color: #A63437; color: white; border: none; padding: 5px 10px; font-size: 0.875rem;"
                                        data-csv="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/work_freq_corp_weights_directed/work_freq_corp_weights_directed_top500.csv"
                                        >Top 500</button>
                                </div>
                                <script src="js/work_freq_corp_weights_directed.js"/>
                                <table class="table table-sm display" id="tabulator-table-work">
                                    <thead>
                                        <tr>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Titel</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Urheber_in</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                >Datum</th>
                                            <th scope="col" tabulator-headerFilter="input">Typ</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each
                                            select="descendant::tei:listBibl/tei:bibl[@xml:id]">
                                            <xsl:variable name="id">
                                                <xsl:value-of select="data(@xml:id)"/>
                                            </xsl:variable>
                                            <xsl:variable name="titel"
                                                select="normalize-space(tei:title[1]/text())"/>
                                            <xsl:variable name="datum">
                                                <xsl:choose>
                                                  <xsl:when test="tei:date = 'None'"/>
                                                  <xsl:when test="contains(tei:date, ' – ')">
                                                  <xsl:variable name="datum1"
                                                  select="substring-before(tei:date/text(), ' – ')"/>
                                                  <xsl:variable name="datum2"
                                                  select="substring-after(tei:date/text(), ' – ')"/>
                                                  <xsl:choose>
                                                  <xsl:when test="$datum1 = $datum2">
                                                  <xsl:value-of
                                                  select="mam:normalize-date-to-standard($datum1)"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="concat(mam:normalize-date-to-standard($datum1), ' – ', mam:normalize-date-to-standard($datum2))"
                                                  />
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:if test="tei:date != '' and tei:date">
                                                  <xsl:value-of
                                                  select="mam:normalize-date-to-standard(tei:date/text())"
                                                  />
                                                  </xsl:if>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:variable>
                                            <xsl:variable name="work-kind"
                                                select="descendant::tei:note[@type = 'work_kind'][1]"/>
                                            <xsl:choose>
                                                <xsl:when test="tei:author">
                                                  <xsl:for-each select="tei:author">
                                                  <tr>
                                                  <td>
                                                  <span hidden="true">
                                                  <xsl:value-of
                                                  select="mam:sonderzeichen-entfernen($titel)"/>
                                                  </span>
                                                  <xsl:element name="a">
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of select="concat($id, '.html')"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="normalize-space($titel)"/>
                                                  </xsl:element>
                                                  </td>
                                                  <td>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of select="concat(@ref, '.html')"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="."/>
                                                  </a>
                                                  <xsl:if
                                                  test="@role = 'editor' or @role = 'hat-herausgegeben'">
                                                  <xsl:text> (Hrsg.)</xsl:text>
                                                  </xsl:if>
                                                  <xsl:if
                                                  test="@role = 'translator' or @role = 'hat-ubersetzt'">
                                                  <xsl:text> (Übersetzung)</xsl:text>
                                                  </xsl:if>
                                                  <xsl:if
                                                  test="@role = 'illustrator' or @role = 'hat-illustriert'">
                                                  <xsl:text> (Illustrationen)</xsl:text>
                                                  </xsl:if>
                                                  <xsl:if
                                                  test="@role = 'hat-einen-beitrag-geschaffen-zu'">
                                                  <xsl:text> (Beitrag)</xsl:text>
                                                  </xsl:if>
                                                  <xsl:if
                                                  test="@role = 'hat-ein-vorwortnachwort-verfasst-zu'">
                                                  <xsl:text> (Vor-/Nachwort)</xsl:text>
                                                  </xsl:if>
                                                  </td>
                                                  <td>
                                                  <xsl:value-of select="$datum"/>
                                                  </td>
                                                  <td>
                                                  <xsl:value-of select="$work-kind"/>
                                                  </td>
                                                  </tr>
                                                  </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <tr>
                                                  <td>
                                                  <span hidden="true">
                                                  <xsl:value-of
                                                  select="mam:sonderzeichen-entfernen($titel)"/>
                                                  </span>
                                                  <xsl:element name="a">
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of select="concat($id, '.html')"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="normalize-space($titel)"/>
                                                  </xsl:element>
                                                  </td>
                                                  <td/>
                                                  <td>
                                                  <xsl:value-of select="$datum"/>
                                                  </td>
                                                  <td>
                                                  <xsl:value-of select="$work-kind"/>
                                                  </td>
                                                  </tr>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </tbody>
                                </table>
                                <xsl:call-template name="tabulator_dl_buttons"/>
                            </div>
                        </div>
                        <div class="modal" tabindex="-1" role="dialog" id="exampleModal">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Info zum Verzeichnis der
                                            Arbeiten</h5>
                                    </div>
                                    <div class="modal-body">
                                        <p>Das Register verzeichnet alle - unter Einschluss der
                                            indirekten Erwähnungen, wie etwa durch die Namen
                                            einzelner Figuren oder durch Verweise auf Proben,
                                            Vorlesungen u. a. – identifizierte Kunstwerke. </p>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-dismiss="modal">Schließen</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                    <xsl:call-template name="tabulator_work_js"/>
                </div>
            </body>
        </html>
        <xsl:for-each select="descendant::tei:listBibl/tei:bibl[@xml:id]">
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')"/>
            <xsl:variable name="name" select="./tei:title[1]/text()"/>
            <xsl:result-document href="{$filename}">
                <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
                <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
                    <xsl:call-template name="html_head">
                        <xsl:with-param name="html_title" select="$name"/>
                    </xsl:call-template>
                    <body class="page">
                        <div class="hfeed site" id="page">
                            <xsl:call-template name="nav_bar"/>
                            <div class="container-fluid">
                                <div class="card">
                                    <div class="card-header">
                                        <h1 align="center">
                                            <xsl:value-of select="$name"/>
                                        </h1>
                                    </div>
                                    <div class="card-body">
                                        <xsl:call-template name="work_detail"/>
                                    </div>
                                </div>
                            </div>
                            <xsl:call-template name="html_footer"/>
                        </div>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <xsl:function name="mam:sonderzeichen-entfernen" as="xs:string">
        <xsl:param name="input-string" as="xs:string"/>
        <!-- Ersetzen der Umlaute und Sonderzeichen Schritt für Schritt -->
        <xsl:variable name="string0"
            select="replace(replace(replace(replace(replace(replace(replace($input-string, '»', ''), '«', ''), '’', ''), '\?\?\s\[', ''), '\[', ''), '\(', ''), '\*', '')"/>
        <xsl:variable name="string1" select="replace($string0, 'ä', 'ae')"/>
        <xsl:variable name="string2" select="replace($string1, 'ö', 'oe')"/>
        <xsl:variable name="string3" select="replace($string2, 'ü', 'ue')"/>
        <xsl:variable name="string4" select="replace($string3, 'ß', 'ss')"/>
        <xsl:variable name="string5" select="replace($string4, 'Ä', 'Ae')"/>
        <xsl:variable name="string6" select="replace($string5, 'Ü', 'Ue')"/>
        <xsl:variable name="string7" select="replace($string6, 'Ö', 'Oe')"/>
        <xsl:variable name="string8" select="replace($string7, 'é', 'e')"/>
        <xsl:variable name="string9" select="replace($string8, 'è', 'e')"/>
        <xsl:variable name="string10" select="replace($string9, 'É', 'E')"/>
        <xsl:variable name="string11" select="replace($string10, 'È', 'E')"/>
        <xsl:variable name="string12" select="replace($string11, 'ò', 'o')"/>
        <xsl:variable name="string13" select="replace($string12, 'Č', 'C')"/>
        <xsl:variable name="string14" select="replace($string13, 'D’', 'D')"/>
        <xsl:variable name="string15" select="replace($string14, 'd’', 'd')"/>
        <xsl:variable name="string16" select="replace($string15, 'Ś', 'S')"/>
        <xsl:variable name="string17" select="replace($string16, '’', ' ')"/>
        <xsl:variable name="string18" select="replace($string17, '&amp;', 'und')"/>
        <xsl:variable name="string19" select="replace($string18, 'ë', 'e')"/>
        <xsl:variable name="string20" select="replace($string19, '!', '')"/>
        <xsl:variable name="string21" select="replace($string20, 'č', 'c')"/>
        <xsl:variable name="string22" select="replace($string21, 'Ł', 'L')"/>
        <xsl:variable name="string23">
            <xsl:choose>
                <xsl:when test="starts-with($string22, 'Der ')">
                    <xsl:value-of select="substring-after($string22, 'Der ')"/>
                </xsl:when>
                <xsl:when test="starts-with($string22, 'Die ')">
                    <xsl:value-of select="substring-after($string22, 'Die ')"/>
                </xsl:when>
                <xsl:when test="starts-with($string22, 'Das ')">
                    <xsl:value-of select="substring-after($string22, 'Das ')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$string22"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="$string23"/>
    </xsl:function>
    <xsl:function name="mam:normalize-date-to-standard">
        <xsl:param name="input" as="xs:string"/>
        <xsl:analyze-string select="$input" regex="^(\d{{4}})-(\d{{1,2}})-(\d{{1,2}})$">
            <xsl:matching-substring>
                <xsl:value-of
                    select="concat(mam:remove-leading-zeros(regex-group(3)), '. ', mam:remove-leading-zeros(regex-group(2)), '. ', mam:remove-leading-zeros(regex-group(1)))"
                />
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:analyze-string select="." regex="^(\d{{1,2}}).(\d{{1,2}}).(\d{{4}})$">
                    <xsl:matching-substring>
                        <xsl:value-of
                            select="concat(mam:remove-leading-zeros(regex-group(1)), '. ', mam:remove-leading-zeros(regex-group(2)), '. ', mam:remove-leading-zeros(regex-group(3)))"
                        />
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    <xsl:function name="mam:remove-leading-zeros">
        <xsl:param name="input" as="xs:string"/>
        <xsl:variable name="spitze-weg">
            <xsl:choose>
                <xsl:when test="contains($input, '>&lt;')">
                    <xsl:value-of select="substring-before($input, '>&lt;')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$input"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="replace($spitze-weg, '^0+', '')"/>
    </xsl:function>
</xsl:stylesheet>
