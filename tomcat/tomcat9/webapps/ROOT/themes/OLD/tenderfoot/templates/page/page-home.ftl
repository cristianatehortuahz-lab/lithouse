<#-- $This file is distributed under the terms of the license in /doc/license.txt$  -->

<@widget name="login" include="assets" />

<#--
        With release 1.6, the home page no longer uses the "browse by" class group/classes display.
        If you prefer to use the "browse by" display, replace the import statement below with the
        following include statement:

            <#include "browse-classgroups.ftl">

        Also ensure that the homePage.geoFocusMaps flag in the runtime.properties file is commented
        out.
-->
<#import "lib-home-page-custom.ftl" as lh>
<#assign isHomePage = true />

<!DOCTYPE html>
<html lang="${country}">
    <head>
        <#include "head.ftl">
        <#if geoFocusMapsEnabled >
            <#include "geoFocusMapScripts.ftl">
        </#if>
        <script async type="text/javascript" src="${urls.base}/js/homePageUtils.js?version=x"></script>
        <link rel="stylesheet" href="${urls.base}/themes/tenderfoot/css/home-page.css" />
    </head>

    <body class="${bodyClasses!}" onload="${bodyOnload!}">
        <#-- supplies the faculty count to the js function that generates a random row number for the search query -->
        <@lh.facultyMemberCount  vClassGroups! />
		<#--  <header id="branding" role="banner">  -->
			<#--  <#include "identity.ftl">  -->
        <#include "header.ftl">
		<#--  </header>  -->
        <#include "developer.ftl">
        <#--  <#include "menu.ftl">  -->
        <#include "message.ftl">
        <section id="intro" role="region" class="row">
            <section id="search-home" role="region">
                <fieldset>
                    <legend>${i18n().search_form}</legend>
                    <form id="search-homepage" action="${urls.search}" name="search-home" role="search" method="GET" class="d-flex" role="search">
                        <input class="form-control me-2" type="search" placeholder="Busque un investigador unidad o laboratorio" aria-label="Buscar en el sitio" id="searchInput" name="querytext" autocapitalize="off">
                        <input type="hidden" name="filters_category"  value="" autocapitalize="off" />
                        <button class="btn btn-outline-success" type="submit">${i18n().search_button}</button>

                        <button class="search-button" type="submit" aria-label="${i18n().search_button}">
                            <!-- Icono de Lupa SVG -->
                            <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                            </svg>
                        </button>
                    </form>
                </fieldset>
                <p>${i18n().intro_para3}</p>
            </section> 
        </section>
        <#include "UR-service-box.ftl">



        <#--  <div class="row hero">
            <div class="theme-showcase">
                <div class="col-md-12">
                    <div class="container" role="main">
                        <div class="jumbotron">
                            <h1>${i18n().intro_title}</h1>
                        </div>
                        <form id="search-homepage" action="${urls.search}" name="search-home" role="search" method="GET" class="form-horizontal">
                            <fieldset>
                                <div class="form-group pull-left" style="margin-right: 5px;">
                                    <select class="form-control" id="classgroup" name="filters_category">
                                        <option value="">${i18n().all_capitalized}</option>
                                        <#list vClassGroups as group>
                                            <#if (group.individualCount > 0)>
                                                <option value="${group.uri}">${group.displayName?capitalize}</option>
                                            </#if>
                                        </#list>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <div class="input-group">
                                        <input type="text" name="querytext" class="form-control" value="" placeholder="${i18n().search_form}" autocapitalize="off" />
                                        <span class="input-group-btn">
                                            <button class="btn btn-default" type="submit">
                                                <span class="icon-search">${i18n().search_button}</span>
                                            </button>
                                        </span>
                                    </div>
                                </div>
                            </fieldset>
                        </form>
                    </div>
                </div>
                <div class="col-md-12">
                    <div class="container">
                        <div class="jumbotron">
                            <p>${i18n().intro_para1}</p>
                            <p>${i18n().intro_para2}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>  -->


        <#if geoFocusMapsEnabled >
            <div class="row geo-focus">
                <div class="container">
                    <div class="col-md-12">
                        <!-- Map display of researchers' areas of geographic focus. Must be enabled in runtime.properties -->
                        <@lh.geographicFocusHtml />
                    </div>
                </div>
            </div>
        </#if>

        <!-- List of research classes: e.g., articles, books, collections, conference papers -->
        <div class="row research-count">
            <div class="container">
                <!-- div class="col-md-6">
                </div -->
                <div class="col-md-12">
                    <!-- Statistical information relating to property groups and their classes; displayed horizontally, not vertically-->
                    <#--  <@lh.allClassGroups vClassGroups! />  -->
                     <@lh.allClassGroupsCustom vClassGroups! />
                </div>
            </div>
        </div>

        <#include "footer.ftl">
        <#-- builds a json object that is used by js to render the academic departments section -->
        <@lh.listAcademicDepartments />
    <script>
        var i18nStrings = {
            researcherString: '${i18n().researcher?js_string}',
            researchersString: '${i18n().researchers?js_string}',
            currentlyNoResearchers: '${i18n().currently_no_researchers?js_string}',
            countriesAndRegions: '${i18n().countries_and_regions?js_string}',
            countriesString: '${i18n().countries?js_string}',
            regionsString: '${i18n().regions?js_string}',
            statesString: '${i18n().map_states_string?js_string}',
            stateString: '${i18n().map_state_string?js_string}',
            statewideLocations: '${i18n().statewide_locations?js_string}',
            researchersInString: '${i18n().researchers_in?js_string}',
            inString: '${i18n().in?js_string}',
            noFacultyFound: '${i18n().no_faculty_found?js_string}',
            placeholderImage: '${i18n().placeholder_image?js_string}',
            viewAllFaculty: '${i18n().view_all_faculty?js_string}',
            viewAllString: '${i18n().view_all?js_string}',
            viewAllDepartments: '${i18n().view_all_departments?js_string}',
            noDepartmentsFound: '${i18n().no_departments_found?js_string}'
        };
        // set the 'limmit search' text and alignment
        if  ( $('input.search-homepage').css('text-align') == "right" ) {
             $('input.search-homepage').attr("placeholder","${i18n().limit_search} \u2192");
        }
    </script>
    </body>
</html>
