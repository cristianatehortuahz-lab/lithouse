<#-- $This file is distributed under the terms of the license in LICENSE$  -->

<@widget name="login" include="assets" />

<#--
        With release 1.6, the home page no longer uses the "browse by" class group/classes display.
        If you prefer to use the "browse by" display, replace the import statement below with the
        following include statement:

            <#include "browse-classgroups.ftl">

        Also ensure that the homePage.geoFocusMaps flag in the runtime.properties file is commented
        out.
-->
<#--  <#import "lib-home-page.ftl" as lh>  -->
<#import "lib-home-page-custom.ftl" as lh>
<#assign isHomePage = true>

<!DOCTYPE html>
<html lang="${country}">
    <head>
        <#include "head.ftl">
        <#if geoFocusMapsEnabled >
            <#include "geoFocusMapScripts.ftl">
        </#if>
        <script defer type="text/javascript" src="${urls.base}/js/homePageUtils.js?version=x"></script>
        <link rel="stylesheet" href="${urls.theme}/css/home-page.css" media="print" onload="this.media='all'">
        <noscript><link rel="stylesheet" href="${urls.theme}/css/home-page.css"></noscript>
    </head>

    <body class="${bodyClasses!}" onload="${bodyOnload!}">
        <#-- supplies the faculty count to the js function that generates a random row number for the search query -->
        <@lh.facultyMemberCount  vClassGroups! />
        <#--  <#include "identity.ftl">  -->
        <#include "header.ftl"> 

        <#include "menu.ftl">
        
        <div id="intro-container">
        <section id="intro" role="region" class="container">
            <section id="search-home" role="region">
                <fieldset>
                    <legend class="sr-only">${i18n().search_form}</legend>
                    <form id="search-homepage" action="${urls.search}" name="search-home" role="search" method="GET">
                        <input class="form-control" type="search" placeholder="Busque un investigador, unidad o laboratorio" aria-label="Buscar en el sitio" id="searchInput" name="querytext" autocapitalize="off">
                        <input type="hidden" name="filters_category" value="" autocapitalize="off">
                        <button class="search-button" type="submit" aria-label="${i18n().search_button}">
                            <!-- Icono de Lupa SVG -->
                            <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                            </svg>
                        </button>
                    </form>
                </fieldset>
                <p>${i18n().intro_para3}</p>
            </section> <!-- #search-home -->
        </section> <!-- #intro -->
    </div>


        

       <#--   <@widget name="login" />  -->

        <!-- List of research classes: e.g., articles, books, collections, conference papers -->
        <#--  <@lh.researchClasses />  -->

        <!-- List of four randomly selected faculty members -->
       <#--   <@lh.facultyMbrHtml />  -->

        <!-- List of randomly selected academic departments -->
       <#--   <@lh.academicDeptsHtml />  -->

        <#if geoFocusMapsEnabled >
            <!-- Map display of researchers' areas of geographic focus. Must be enabled in runtime.properties -->
            <@lh.geographicFocusHtml />
        </#if>

        <!-- Statistical information relating to property groups and their classes; displayed horizontally, not vertically-->
        <#--  <@lh.allClassGroups vClassGroups! />  -->

        <#include "UR-service-box.ftl">

        <@lh.allClassGroupsCustom vClassGroups! />

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
        // Optimized Vanilla JS for limit-search placeholder
        document.addEventListener('DOMContentLoaded', function() {
            var searchInput = document.querySelector('input.search-homepage');
            if (searchInput && window.getComputedStyle(searchInput).textAlign === 'right') {
                searchInput.setAttribute('placeholder', '${i18n().limit_search} \u2192');
            }
        });
    </script>
    </body>
</html>
