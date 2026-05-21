<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0"
    exclude-result-prefixes="xsl tei xs local">

    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>

    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>

    <xsl:variable name="teiSource" select="data(tei:TEI/@xml:id)"/>
    <xsl:variable name="doc_title" select=".//tei:title[@level = 'a'][1]/text()"/>

    <!-- Which letters are present across all list entries -->
    <xsl:variable name="present_letters" as="xs:string*" select="
        distinct-values(
            for $div in .//tei:div[starts-with(@xml:id, 'div_')]
            return translate(
                upper-case(substring(normalize-space(string-join($div/tei:p//text(), '')), 1, 1)),
                'ÄÖÜß', 'AOUS'
            )
        )
    "/>

    <xsl:variable name="entry_count" select="count(.//tei:div[starts-with(@xml:id, 'div_')])"/>

    <!-- =============================================================
         MAIN TEMPLATE
         ============================================================= -->
    <xsl:template match="/">
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <body class="page lektueren-edition">

                <!-- Google Fonts (placed in body to avoid modifying html_head.xsl) -->
                <link rel="preconnect" href="https://fonts.googleapis.com"/>
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin=""/>
                <link rel="stylesheet"
                    href="https://fonts.googleapis.com/css2?family=Courier+Prime:ital,wght@0,400;0,700;1,400&amp;family=Source+Sans+3:ital,wght@0,400;0,500;0,600;1,400&amp;family=Source+Serif+4:ital,opsz,wght@0,8..60,400;0,8..60,500;0,8..60,600;1,8..60,400;1,8..60,500&amp;display=swap"
                    type="text/css"/>

                <style type="text/css">
body.lektueren-edition {
  --lk-ink:       #1a1814;
  --lk-ink-soft:  #4a463f;
  --lk-muted:     #8a8378;
  --lk-rule:      #e6e1d6;
  --lk-rule-soft: #f0ecdf;
  --lk-accent:    #7d3325;
  --lk-accent-soft: #9b5048;
  --lk-editor:    #6b6359;
  --lk-serif: "Source Serif 4", "EB Garamond", Georgia, serif;
  --lk-sans:  "Source Sans 3", "Helvetica Neue", system-ui, sans-serif;
  --lk-mono:  "Courier Prime", "Courier New", ui-monospace, monospace;
}

/* ---------- Alpha navigation bar ---------- */
.lk-alpha-bar {
  position: sticky;
  top: 56px;
  z-index: 1020;
  background: rgba(255,255,255,0.96);
  backdrop-filter: saturate(140%) blur(8px);
  -webkit-backdrop-filter: saturate(140%) blur(8px);
  border-bottom: 1px solid var(--lk-rule);
}
.lk-alpha-nav {
  max-width: 1280px;
  margin: 0 auto;
  padding: 10px 48px 12px;
  display: flex;
  flex-wrap: wrap;
  gap: 2px 0;
  font-family: var(--lk-sans);
  font-size: 13px;
  letter-spacing: 0.02em;
}
.lk-alpha-nav a {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 28px;
  height: 26px;
  padding: 0 6px;
  color: var(--lk-ink-soft);
  border-right: 1px solid var(--lk-rule-soft);
  text-decoration: none;
}
.lk-alpha-nav a:first-child { border-left: 1px solid var(--lk-rule-soft); }
.lk-alpha-nav a.lk-empty { color: var(--lk-rule); pointer-events: none; }
.lk-alpha-nav a:hover:not(.lk-empty) { color: var(--lk-accent); background: #f7f3e8; }

/* ---------- Masthead ---------- */
.lk-masthead {
  max-width: 1280px;
  margin: 0 auto;
  padding: 64px 48px 28px;
  display: grid;
  grid-template-columns: 1fr auto;
  gap: 48px;
  align-items: end;
}
.lk-eyebrow {
  font-family: var(--lk-sans);
  font-size: 12px;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: var(--lk-accent);
  margin: 0 0 12px;
}
.lk-title {
  font-family: var(--lk-serif);
  font-weight: 500;
  font-size: clamp(40px, 5.5vw, 84px);
  line-height: 0.96;
  letter-spacing: -0.018em;
  margin: 0;
  color: var(--lk-ink);
}
.lk-title em {
  font-style: italic;
  color: var(--lk-accent);
  font-weight: 400;
}
.lk-meta-count {
  font-family: var(--lk-sans);
  font-size: 12px;
  color: var(--lk-muted);
  text-align: right;
  line-height: 1.7;
  letter-spacing: 0.04em;
  text-transform: uppercase;
}
.lk-num {
  font-family: var(--lk-serif);
  font-size: 52px;
  color: var(--lk-accent);
  line-height: 1;
  display: block;
  margin-bottom: 4px;
  letter-spacing: -0.02em;
}

/* ---------- Index list ---------- */
.lk-index {
  max-width: 1280px;
  margin: 0 auto;
  padding: 40px 48px 80px;
}
.lk-letter-anchor {
  display: block;
  position: relative;
  height: 0;
  scroll-margin-top: 130px;
}

/* ---------- Entry row ---------- */
.lk-row {
  display: grid;
  grid-template-columns: minmax(0, 1.6fr) minmax(0, 1fr) 72px;
  gap: 32px;
  padding: 14px 0;
  align-items: baseline;
  border-top: 1px solid var(--lk-rule-soft);
}
.lk-row:first-of-type { border-top: none; }

/* Edition text column */
.lk-note {
  font-size: 18px;
  line-height: 1.55;
  color: var(--lk-ink);
  hyphens: auto;
  word-break: break-word;
}
.lk-note.handwritten {
  font-family: var(--lk-serif);
  font-size: 19px;
  font-feature-settings: "onum" 1;
}
.lk-note.typewritten {
  font-family: var(--lk-mono);
  font-size: 16px;
  letter-spacing: -0.01em;
}
.lk-note s {
  color: #b8b0a3;
  text-decoration-thickness: 1px;
}
.lk-supplied { color: var(--lk-muted); }

/* Authors column */
.lk-authors {
  font-family: var(--lk-sans);
  display: flex;
  flex-direction: column;
  gap: 4px;
  padding-top: 5px;
}
.lk-author-link {
  color: var(--lk-editor);
  font-size: 14px;
  font-weight: 400;
  line-height: 1.4;
  border-bottom: 1px solid transparent;
  transition: color 120ms, border-color 120ms;
  display: inline;
  text-decoration: none;
}
.lk-author-link:hover {
  color: var(--lk-accent);
  border-bottom-color: var(--lk-accent);
}
.lk-arrow {
  color: var(--lk-muted);
  margin-right: 4px;
  font-size: 13px;
}
.lk-author-link:hover .lk-arrow { color: var(--lk-accent); }
.lk-meta-tag {
  font-family: var(--lk-sans);
  font-size: 11.5px;
  color: var(--lk-muted);
  letter-spacing: 0.04em;
  margin-top: 4px;
}
.lk-meta-tag.unident { color: var(--lk-accent-soft); }
.lk-no-authors {
  font-family: var(--lk-sans);
  font-size: 12px;
  color: var(--lk-muted);
  font-style: italic;
  letter-spacing: 0.02em;
}

/* Tag column */
.lk-tag {
  font-family: var(--lk-sans);
  font-size: 12px;
  font-weight: 500;
  letter-spacing: 0.04em;
  color: var(--lk-accent);
  text-align: right;
  padding-top: 7px;
  white-space: nowrap;
}

/* ---------- Colophon ---------- */
.lk-colophon {
  max-width: 1280px;
  margin: 0 auto;
  padding: 48px 48px 64px;
  border-top: 1px solid var(--lk-rule);
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 48px;
  font-family: var(--lk-sans);
  font-size: 13.5px;
  color: var(--lk-muted);
  line-height: 1.7;
}
.lk-colophon h3 {
  font-family: var(--lk-sans);
  font-size: 11px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.16em;
  color: var(--lk-ink);
  margin: 0 0 12px;
}
.lk-colophon a { color: var(--lk-ink-soft); border-bottom: 1px solid var(--lk-rule); text-decoration: none; }
.lk-colophon a:hover { color: var(--lk-accent); border-bottom-color: var(--lk-accent); }

/* ---------- Back to top ---------- */
.lk-totop {
  position: fixed;
  right: 28px;
  bottom: 28px;
  width: 44px;
  height: 44px;
  border-radius: 50%;
  background: var(--lk-ink);
  color: #fff;
  display: grid;
  place-items: center;
  font-family: var(--lk-sans);
  font-size: 16px;
  opacity: 0;
  pointer-events: none;
  transition: opacity 200ms;
  z-index: 30;
  border: none;
  cursor: pointer;
}
.lk-totop.show { opacity: 1; pointer-events: auto; }
.lk-totop:hover { background: var(--lk-accent); }

/* ---------- Responsive ---------- */
@media (max-width: 900px) {
  .lk-alpha-nav, .lk-masthead, .lk-index, .lk-colophon { padding-left: 24px; padding-right: 24px; }
  .lk-masthead { grid-template-columns: 1fr; gap: 20px; }
  .lk-meta-count { text-align: left; }
  .lk-row { grid-template-columns: 1fr 64px; row-gap: 6px; gap: 16px; padding: 18px 0; }
  .lk-note { grid-column: 1; }
  .lk-tag { grid-column: 2; grid-row: 1; padding-top: 7px; }
  .lk-authors { grid-column: 1 / -1; padding-top: 0; }
  .lk-colophon { grid-template-columns: 1fr; }
}
@media (max-width: 540px) {
  .lk-note { font-size: 17px; }
  .lk-note.handwritten { font-size: 18px; }
}
@media print {
  .lk-alpha-bar, .lk-totop { display: none; }
  .lk-row { break-inside: avoid; }
}
                </style>

                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>

                    <xsl:choose>
                        <xsl:when test=".//tei:div[starts-with(@type, 'liste')]">
                            <!-- Alphabet navigation bar -->
                            <div class="lk-alpha-bar">
                                <nav class="lk-alpha-nav" aria-label="Alphabetische Navigation">
                                    <xsl:call-template name="render-alpha-bar"/>
                                </nav>
                            </div>
                            <xsl:apply-templates select=".//tei:div[starts-with(@type, 'liste')]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- Fallback layout for non-list documents (e.g. Lectuere.xml) -->
                            <div class="container-fluid">
                                <div class="card" style="margin-top:2em" data-index="true">
                                    <div class="card-body">
                                        <xsl:apply-templates select=".//tei:body"/>
                                    </div>
                                </div>
                            </div>
                        </xsl:otherwise>
                    </xsl:choose>

                    <button class="lk-totop" id="lk-totop" aria-label="Nach oben">↑</button>

                    <xsl:call-template name="html_footer"/>
                </div>

                <script type="text/javascript">
(function () {
  var btn = document.getElementById('lk-totop');
  if (!btn) return;
  window.addEventListener('scroll', function () {
    btn.classList.toggle('show', window.scrollY > 600);
  }, { passive: true });
  btn.addEventListener('click', function () {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });
}());
                </script>
            </body>
        </html>
    </xsl:template>

    <!-- =============================================================
         ALPHABET BAR
         ============================================================= -->
    <xsl:template name="render-alpha-bar">
        <xsl:for-each select="('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z')">
            <xsl:variable name="L" select="."/>
            <xsl:choose>
                <xsl:when test="$L = $present_letters">
                    <a href="#letter-{$L}">
                        <xsl:value-of select="$L"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <a class="lk-empty">
                        <xsl:value-of select="$L"/>
                    </a>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <!-- =============================================================
         LISTE DIV — masthead + entries + colophon
         ============================================================= -->
    <xsl:template match="tei:div[starts-with(@type, 'liste')]">
        <xsl:variable name="title_words" select="tokenize(normalize-space(tei:head), '\s+')"/>

        <div class="lk-masthead">
            <div>
                <p class="lk-eyebrow">Schnitzler-Lektüren · Leseliste</p>
                <h1 class="lk-title">
                    <xsl:if test="count($title_words) &gt; 1">
                        <xsl:value-of select="string-join($title_words[position() != last()], ' ')"/>
                        <xsl:text> </xsl:text>
                    </xsl:if>
                    <em>
                        <xsl:value-of select="$title_words[last()]"/>
                    </em>
                </h1>
            </div>
            <xsl:if test="$entry_count &gt; 0">
                <div class="lk-meta-count">
                    <span class="lk-num">
                        <xsl:value-of select="$entry_count"/>
                    </span>
                    Einträge
                </div>
            </xsl:if>
        </div>

        <main class="lk-index" data-index="true">
            <xsl:apply-templates select="tei:div[starts-with(@xml:id, 'div_')]"/>
        </main>

        <div class="lk-colophon">
            <div>
                <h3>Edition</h3>
                Aus der Mikroverfilmung der Lektüreliste, bearbeitet im Rahmen des Projekts
                <i>Schnitzler-Lektüren</i> am Austrian Centre for Digital Humanities and
                Cultural Heritage (ACDH-CH).
            </div>
            <div>
                <h3>Weiterführend</h3>
                <a href="about.html">Vorwort</a> ·
                <a href="einleitung.html">Einleitung</a> ·
                <a href="edition.html">Zur Edition</a> ·
                <a href="literatur.html">Literatur</a>
            </div>
        </div>
    </xsl:template>

    <!-- =============================================================
         ENTRY DIV (div_D1, div_D2, …)
         ============================================================= -->
    <xsl:template match="tei:div[starts-with(@xml:id, 'div_')]">
        <!-- Determine first letter of this entry for alphabet anchor -->
        <xsl:variable name="my_letter" select="
            translate(
                upper-case(substring(normalize-space(string-join(tei:p//text(), '')), 1, 1)),
                'ÄÖÜß', 'AOUS'
            )
        "/>
        <xsl:variable name="prev_entry"
            select="preceding-sibling::tei:div[starts-with(@xml:id, 'div_')][1]"/>
        <xsl:variable name="prev_letter" select="
            if ($prev_entry)
            then translate(
                upper-case(substring(normalize-space(string-join($prev_entry/tei:p//text(), '')), 1, 1)),
                'ÄÖÜß', 'AOUS'
            )
            else ''
        "/>

        <!-- Insert invisible anchor at letter transitions -->
        <xsl:if test="$my_letter != $prev_letter">
            <span class="lk-letter-anchor" id="letter-{$my_letter}"/>
        </xsl:if>

        <!-- 3-column row: edition text | authors | [D##] -->
        <div class="lk-row">
            <div>
                <xsl:attribute name="class">
                    <xsl:text>lk-note</xsl:text>
                    <xsl:choose>
                        <xsl:when test="tei:p//tei:hi[@rend = 'manual']"> handwritten</xsl:when>
                        <xsl:otherwise> typewritten</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:apply-templates select="tei:p" mode="edition"/>
            </div>
            <xsl:call-template name="render-authors"/>
            <div class="lk-tag">
                <xsl:value-of select="concat('[', substring-after(@xml:id, 'div_'), ']')"/>
            </div>
        </div>
    </xsl:template>

    <!-- =============================================================
         EDITION TEXT (mode="edition")
         ============================================================= -->
    <xsl:template match="tei:p" mode="edition">
        <xsl:apply-templates mode="edition"/>
    </xsl:template>

    <!-- Identifier element: suppress -->
    <xsl:template match="tei:idno" mode="edition"/>

    <!-- Explicit space -->
    <xsl:template match="tei:space" mode="edition">
        <xsl:text> </xsl:text>
    </xsl:template>

    <!-- Line break -->
    <xsl:template match="tei:lb" mode="edition">
        <br/>
    </xsl:template>

    <!-- Handwritten marker: transparent wrapper -->
    <xsl:template match="tei:hi[@rend = 'manual']" mode="edition">
        <xsl:apply-templates mode="edition"/>
    </xsl:template>

    <xsl:template match="tei:hi[@rend = 'italics']" mode="edition">
        <i>
            <xsl:apply-templates mode="edition"/>
        </i>
    </xsl:template>

    <xsl:template match="tei:hi[@rend = 'underline']" mode="edition">
        <u>
            <xsl:apply-templates mode="edition"/>
        </u>
    </xsl:template>

    <xsl:template match="tei:hi[@rend = 'strikethrough']" mode="edition">
        <s>
            <xsl:apply-templates mode="edition"/>
        </s>
    </xsl:template>

    <xsl:template match="tei:hi[@rend = 'superscript']" mode="edition">
        <sup>
            <xsl:apply-templates mode="edition"/>
        </sup>
    </xsl:template>

    <xsl:template match="tei:supplied" mode="edition">
        <span class="lk-supplied">
            <xsl:text>[</xsl:text>
            <xsl:apply-templates mode="edition"/>
            <xsl:text>]</xsl:text>
        </span>
    </xsl:template>

    <!-- =============================================================
         AUTHORS COLUMN (named template, context = div_*)
         ============================================================= -->
    <xsl:template name="render-authors">
        <div class="lk-authors">
            <xsl:choose>
                <xsl:when test="exists(tei:note//tei:person[@xml:id])">
                    <!-- Person links -->
                    <xsl:for-each select="tei:note//tei:person[@xml:id]">
                        <a href="{concat(./@xml:id, '.html')}" class="lk-author-link">
                            <xsl:if test="@cert">
                                <xsl:text>[?] </xsl:text>
                            </xsl:if>
                            <span class="lk-arrow">→</span>
                            <xsl:value-of select="normalize-space(tei:persName)"/>
                        </a>
                    </xsl:for-each>
                    <!-- Editorial annotations on the note itself -->
                    <xsl:for-each select="tei:note/tei:note">
                        <div>
                            <xsl:attribute name="class">
                                <xsl:text>lk-meta-tag</xsl:text>
                                <xsl:if test="contains(lower-case(normalize-space(.)), 'nicht ermittelt')">
                                    <xsl:text> unident</xsl:text>
                                </xsl:if>
                            </xsl:attribute>
                            <xsl:text>※ </xsl:text>
                            <xsl:value-of select="normalize-space(.)"/>
                        </div>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <!-- No person identified: show note text or placeholder -->
                    <span class="lk-no-authors">
                        <xsl:text>— </xsl:text>
                        <xsl:variable name="meta"
                            select="normalize-space(string-join(tei:note//tei:note/text(), ' '))"/>
                        <xsl:choose>
                            <xsl:when test="$meta != ''">
                                <xsl:value-of select="$meta"/>
                            </xsl:when>
                            <xsl:otherwise>ohne Zuordnung</xsl:otherwise>
                        </xsl:choose>
                    </span>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

    <!-- =============================================================
         FALLBACK TEMPLATES (for non-list documents, e.g. Lectuere.xml)
         ============================================================= -->
    <xsl:template match="tei:p">
        <p class="edierterText">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="tei:head">
        <h1 class="edierterText">
            <xsl:apply-templates/>
        </h1>
    </xsl:template>

    <xsl:template match="tei:hi[@rend = 'manual']">
        <span class="handschriftlich">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:hi[@rend = 'italics']">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>

    <xsl:template match="tei:hi[@rend = 'underline']">
        <u>
            <xsl:apply-templates/>
        </u>
    </xsl:template>

    <xsl:template match="tei:hi[@rend = 'strikethrough']">
        <del>
            <xsl:apply-templates/>
        </del>
    </xsl:template>

    <xsl:template match="tei:hi[@rend = 'superscript']">
        <sup>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>

    <xsl:template match="tei:supplied">
        <span class="herausgeberErgaenzung">
            <xsl:text>[</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>]</xsl:text>
        </span>
    </xsl:template>

    <xsl:template match="tei:space">
        <xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template match="tei:idno"/>

    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>

    <!-- Notes outside div_* context (rare; render inline in brackets) -->
    <xsl:template
        match="tei:note[not(parent::tei:div[starts-with(@xml:id, 'div_')])]">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
    </xsl:template>

</xsl:stylesheet>
