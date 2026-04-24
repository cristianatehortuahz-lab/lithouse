<#-- $This file is distributed under the terms of the license in LICENSE$  -->

<#--  <@widget name="login" include="assets" />  -->

<#--
        With release 1.6, the home page no longer uses the "browse by" class group/classes display.
        If you prefer to use the "browse by" display, replace the import statement below with the
        following include statement:

            <#include "browse-classgroups.ftl">

        Also ensure that the homePage.geoFocusMaps flag in the runtime.properties file is commented
        out.
-->
<#import "lib-home-page.ftl" as lh>

<!DOCTYPE html>
<html lang="${country}">
    <head>
        <#include "head_page_home.ftl">
        <#if geoFocusMapsEnabled >
            <#include "geoFocusMapScripts.ftl">
        </#if>
        <script async type="text/javascript" src="${urls.base}/js/homePageUtils.js?version=x"></script>
    </head>

    <body class="${bodyClasses!}" onload="${bodyOnload!}" data-bs-py="scroll" data-bs-target="#branding" data-bs-offset="50">
    <#-- supplies the faculty count to the js function that generates a random row number for the search query -->
        <@lh.facultyMemberCount  vClassGroups! />
        <#include "identity.ftl">
        <#include "top_pic.ftl">
        <#--  <#include "menu.ftl">  -->
        
        

    <div id="wrapper-content" role="main">
    <#include "searchFilter.ftl">
        <#--  <img src="${urls.base}/themes/wilma/images/ImagenMenu/background.png" class="fondocuerpo">  -->
        <section id="galeria" class="container">
            <div class="row">
                <div class="col-lg-4 col-md-6 col-sm-12">
                    <h3>Investigadores y comunidad UR </h3>
                    <a href="${urls.base}/people">
                        <img src="${urls.base}/themes/wilma/images/ImagenMenu/InvestigadoresComunidad.png">
                    </a>
                </div>
                <div class="col-lg-4 col-md-6 col-sm-12">
                    <h3>Unidad académica, de investigacion y extensión</h3>
                    <a href="${urls.base}/organizations">
                        <img src="${urls.base}/themes/wilma/images/ImagenMenu/UnidadAcademica.png">
                    </a>
                </div>
                <div class="col-lg-4 col-md-6 col-sm-12">
                    <h3>Resultados de investigación </h3>
                    <a href="${urls.base}/research">
                        <img src="${urls.base}/themes/wilma/images/ImagenMenu/ResultadosInvestigacion.png">
                    </a>
                </div>
            </div>
        </section>

        <#include "footer.ftl">
        <!-- builds a json object that is used by js to render the academic departments section -->
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

    </div>
    </body>
</html>
