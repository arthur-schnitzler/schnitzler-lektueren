<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsl tei xs" version="2.0">
    <xsl:template match="/" name="nav_bar">
        <div class="wrapper-fluid wrapper-navbar sticky-navbar" id="wrapper-navbar" itemscope=""
            itemtype="http://schema.org/WebSite">
            <a class="skip-link screen-reader-text sr-only" href="#content">Skip to content</a>
            <nav class="navbar navbar-expand-lg navbar-light">
                <div class="container-fluid">
                    <!-- Your site title as branding in the menu -->
                    <a href="index.html" class="navbar-brand custom-logo-link" rel="home"
                        itemprop="url">
                        <img
                            src="https://shared.acdh.oeaw.ac.at/schnitzler-lektueren/lektueren-logo.jpg"
                            class="img-fluid" alt="Schnitzler Lektueren" itemprop="logo"/>
                    </a>
                    <!-- end custom logo -->
                    <button class="navbar-toggler" type="button" data-toggle="collapse"
                        data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown"
                        aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"/>
                    </button>
                    <div class="collapse navbar-collapse justify-content-end" id="navbarNavDropdown">
                        <!-- Your menu goes here -->
                        <ul id="main-menu" class="navbar-nav">
                            <li class="nav-item dropdown">
                                <a title="Papers" href="#" data-toggle="dropdown"
                                    class="nav-link dropdown-toggle">Projekt <span class="caret"
                                    /></a>
                                <ul class=" dropdown-menu" role="menu">
                                    <li class="nav-item dropdown-submenu">
                                        <a title="Schnitzler-Lektueren" href="about.html"
                                            class="nav-link">Vorwort</a>
                                        <a title="Schnitzler-Lektueren" href="einleitung.html"
                                            class="nav-link">Einleitung</a>
                                        <a title="Schnitzler-Lektueren" href="edition.html"
                                            class="nav-link">Zur Edition</a>
                                        <a title="Schnitzler-Lektueren" href="literatur.html"
                                            class="nav-link">Literatur</a>
                                        <a title="Schnitzler-Lektueren" href="https://shared.acdh.oeaw.ac.at/schnitzler-lektueren/2013_Aurnhammer_Lektueren_print.pdf" class="nav-link">PDF der Buchausgabe</a>
                                        <a title="Schnitzler-Lektueren" href="https://shared.acdh.oeaw.ac.at/schnitzler-lektueren/Mikrofilm_O1_Deutschsprachig.pdf" class="nav-link">Mikroverfilmung der Lektüreliste I</a>
                                        <a title="Schnitzler-Lektueren" href="https://shared.acdh.oeaw.ac.at/schnitzler-lektueren/Mikrofilm_O2_Fremdsprachig.pdf" class="nav-link">Mikroverfilmung der Lektüreliste II</a>
                                    </li>
                                </ul>
                            </li>
                            <li class="nav-item dropdown">
                                <a title="Inhalt" href="#" data-toggle="dropdown"
                                    class="nav-link dropdown-toggle">Inhalt <span class="caret"
                                    /></a>
                                <ul class=" dropdown-menu" role="menu">
                                    <li class="nav-item dropdown-submenu">
                                        <a title="Schnitzler-Lektueren" href="Lectuere.html"
                                            class="nav-link">Lectüre</a>
                                        <a title="Schnitzler-Lektueren"
                                            href="Deutschsprachige-Literatur.html" class="nav-link"
                                            >Deutschsprachige Literatur</a>
                                        <a title="Schnitzler-Lektueren" href="Frankreich.html"
                                            class="nav-link">Frankreich</a>
                                        <a title="Schnitzler-Lektueren" href="Italien.html"
                                            class="nav-link">Italien</a>
                                        <a title="Schnitzler-Lektueren" href="Spanien.html"
                                            class="nav-link">Spanien</a>
                                        <a title="Schnitzler-Lektueren" href="England.html"
                                            class="nav-link">England</a>
                                        <a title="Schnitzler-Lektueren" href="Ungarn-etc.html"
                                            class="nav-link">Ungarn.. etc.</a>
                                        <a title="Schnitzler-Lektueren" href="Polen-Czechen.html"
                                            class="nav-link">Polen.. Czechen..</a>
                                        <a title="Schnitzler-Lektueren" href="Norden.html"
                                            class="nav-link">Norden</a>
                                        <a title="Schnitzler-Lektueren" href="Russland.html"
                                            class="nav-link">Russland</a>
                                        <a title="Schnitzler-Lektueren" href="Griechenland.html"
                                            class="nav-link">Griechenland</a>
                                        <a title="Schnitzler-Lektueren" href="Rom.html"
                                            class="nav-link">Rom</a>
                                    </li>
                                </ul>
                            </li>
                            <li class="nav-item dropdown">
                                <a title="Indexes" href="#" data-toggle="dropdown"
                                    class="nav-link dropdown-toggle">Register <span class="caret"
                                    /></a>
                                <ul class=" dropdown-menu" role="menu">
                                    <li class="nav-item dropdown-submenu">
                                        <a title="Personen" href="listperson.html" class="nav-link"
                                            >Personen</a>
                                    </li>
                                    <li class="nav-item dropdown-submenu">
                                        <a title="Werke" href="listwork.html" class="nav-link"
                                            >Werke</a>
                                    </li>
                                    <div class="dropdown-divider"/>
                                    <li class="nav-item dropdown-submenu">
                                        <a title="GND-BEACON" href="beacon.txt" class="nav-link"
                                            >GND-BEACON</a>
                                    </li>
                                </ul>
                            </li>
                            <li class="nav-item dropdown">
                                <a title="Indexes" href="#" data-toggle="dropdown"
                                    class="nav-link dropdown-toggle">Links <span class="caret"/></a>
                                <ul class=" dropdown-menu" role="menu">
                                    <li class="nav-item dropdown-submenu">
                                        <a title="Links"
                                            href="http://portal.uni-freiburg.de/ndl/personen/achimaurnhammer/schnitzlerarchiv.html/startseite"
                                            class="nav-link">Arthur-Schnitzler-Archiv</a>
                                    </li>
                                    <li class="nav-item dropdown-submenu">
                                        <a title="Links" href="https://schnitzler.acdh.oeaw.ac.at"
                                            class="nav-link">Schnitzler am ACDH-CH</a>
                                    </li>
                                    <li class="nav-item dropdown-submenu">
                                        <a title="Links"
                                            href="https://github.com/acdh-oeaw/schnitzler-lektueren"
                                            class="nav-link">Daten auf gitHub</a>
                                    </li>
                                </ul>
                            </li>
                            
                        </ul>
                        <form class="form-inline my-2 my-lg-0 navbar-search-form" method="get"
                            action="search.html" role="search">
                            <input class="form-control navbar-search" id="s" name="q" type="text"
                                placeholder="Suche" value="" autocomplete="off"/>
                            <button type="submit" class="navbar-search-icon">
                                <i data-feather="Suche"/>
                            </button>
                        </form>
                    </div>
                    <!-- .collapse navbar-collapse -->
                </div>
                <!-- .container -->
            </nav>
            <!-- .site-navigation -->
        </div>
    </xsl:template>
</xsl:stylesheet>
