<#-- $This file is distributed under the terms of the license in LICENSE$ -->
    <#import "lib-list.ftl" as l>
        <!DOCTYPE html>
        <html lang="${country}">

        <head>
            <#include "head.ftl">
                <#-- <#include "head_page_home.ftl"> -->
            ${scripts.add('<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">',
             '<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>')}
        </head>

        <body class="${bodyClasses!}" onload="${bodyOnload!}">
            <#include "header.ftl">
            <main>
            <#--  <div class="fondotransparente">  -->
                <#--  <#include "identity.ftl">  -->
                    <div id="wrapper-content" role="main">
                       <#--   <#include "search.ftl">  -->
                            <#-- VIVO OpenSocial Extension by UCSF -->
                            <#if openSocial??>
                                <#if openSocial.visible>
                                    <#-- <div id="gadgets-tools" class="gadgets-gadget-parent">
                                    </div> -->
                                </#if>
                            </#if>
                        ${body}
                    </div>
                
                <#-- <#include "scripts.ftl"> -->
                
            </main>
            <#include "footer.ftl">
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
                  var i18nStrings = {
                        pageString: '${i18n().page?js_string}',
                        viewPageString: '${i18n().view_page?js_string}',
                        ofTheResults: '${i18n().of_the_results?js_string}',
                        thereAreNoEntriesStartingWith: '${i18n().there_are_no_entries_starting_with?js_string}',
                        tryAnotherLetter: '${i18n().try_another_letter?js_string}',
                        indsInSystem: '${i18n().individuals_in_system?js_string}',
                        selectAnotherClass: '${i18n().select_another_class?js_string}' };
                // set the 'limmit search' text and alignment
                if ($('input.search-homepage').css('text-align') == "right") {
                    $('input.search-homepage').attr("placeholder", "${i18n().limit_search} \u2192");
                }
            </script>   


<#-- Script to enable browsing individuals within a class -->
        ${scripts.add('<script type="text/javascript" src="${urls.base}/js/jquery_plugins/jquery.scrollTo-min.js"></script>',
              '<script type="text/javascript" src="${urls.base}/js/menupage/browseByVClass.js"></script>')}

       
        </body>

        </html>