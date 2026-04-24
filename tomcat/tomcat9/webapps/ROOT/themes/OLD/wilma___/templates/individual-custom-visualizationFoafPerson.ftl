<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for sparkline visualization on individual profile page -->

<#-- Determine whether this person is an author -->
<#assign isAuthor = p.hasVisualizationStatements(propertyGroups, "${core}relatedBy", "${core}Authorship") />

<#-- Determine whether this person is involved in any grants -->
<#assign obo_RO53 = "http://purl.obolibrary.org/obo/RO_0000053">

<#assign isInvestigator = ( p.hasVisualizationStatements(propertyGroups, "${obo_RO53}", "${core}InvestigatorRole") ||
                            p.hasVisualizationStatements(propertyGroups, "${obo_RO53}", "${core}PrincipalInvestigatorRole") || 
                            p.hasVisualizationStatements(propertyGroups, "${obo_RO53}", "${core}CoPrincipalInvestigatorRole") ) >

<#if (isAuthor || isInvestigator)>

    ${stylesheets.add('<link rel="stylesheet" href="${urls.base}/css/visualization/visualization.css" />')}  
    <#assign standardVisualizationURLRoot ="/visualization">
    
    <#-- El contenedor principal ahora tendrá una clase para aplicar Flexbox -->
    <div class="visualizationContainer visualization-flex-container">

        <#if isAuthor>
           <#--   <#assign coAuthorIcon = "${urls.images}/visualization/coauthorship/co_author_icon.png">
            <#assign coAuthorVisUrl = individual.coAuthorVisUrl()>  -->

            
            
            <#assign coAuthorIcon = "${urls.images}/visualization/coauthorship/co_author_icon.png">
            <#assign wordCloud = "${urls.images}/visualization/word-cloud.png">
            <#assign mapOfScienceIcon = "${urls.images}/visualization/mapofscience/scimap_icon.png">
            <#assign coAuthorVisUrl = individual.coAuthorVisUrl()>
            <#assign mapOfScienceVisUrl = individual.mapOfScienceUrl()>
            <#if mapOfScienceVisualizationEnabled>
                <#assign mapOfScienceIcon = "${urls.images}/visualization/mapofscience/scimap_icon.png">
                <#assign mapOfScienceVisUrl = individual.mapOfScienceUrl()>
            </#if>

            <#assign googleJSAPI = "https://www.google.com/jsapi?autoload=%7B%22modules%22%3A%5B%7B%22name%22%3A%22visualization%22%2C%22version%22%3A%221%22%2C%22packages%22%3A%5B%22imagesparkline%22%5D%7D%5D%7D">

            <div class="publicationschar">
                <span id="sparklineHeading">${i18n().publications_in_vivo}</span>

                <div id="pubsChart"></div>
            </div>
            ${headScripts.add('<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/d3/4.13.0/d3.min.js"></script>')}
            ${scripts.add('<script type="text/javascript" src="${urls.base}/themes/wilma/js/pubsChart.js"></script>')}


            <#-- Elemento nube de palabras -->
            <#--  <div class="sidebar_art">
              <a href="${urls.base}/keywordCloud?uri=${individual.uri?url}">
                <img src="${wordCloud}" alt="${i18n().wordCloud}" /><br>
                <span>${i18n().ResearchKeywords}</span>
              </a>
            </div>  -->


            <#-- Elemento de Red de Coautores -->
            <div class="visualization-item">
                <a href="${coAuthorVisUrl}" title="${i18n().co_author_network}" target="_blank">
                    <img src="${coAuthorIcon}" alt="${i18n().co_author_network_capitalized}" />
                    <span>${i18n().co_author_network}</span>
                </a>
            </div>
            
            <#if mapOfScienceVisualizationEnabled>
                 <#-- Elemento de Mapa de la Ciencia -->
                <div class="visualization-item">
                    <a href="${mapOfScienceVisUrl}" title="${i18n().map_of_science}" target="_blank">
                        <img src="${mapOfScienceIcon}" alt="${i18n().map_of_science_capitalized}" />
                        <span>${i18n().map_of_science_capitalized}</span>
                    </a>
                </div>
            </#if>
        </#if>
        
        <#if isInvestigator>
            <#assign coInvestigatorVisUrl = individual.coInvestigatorVisUrl()>
            <#assign coInvestigatorIcon = "${urls.images}/visualization/coauthorship/co_investigator_icon.png">
            
            <#-- Elemento de Red de Coinvestigadores -->
            <div class="visualization-item">
                <a href="${coInvestigatorVisUrl}" title="${i18n().co_investigator_network}" target="_blank">
                    <img src="${coInvestigatorIcon}" alt="${i18n().co_investigator_network_capitalized}" />
                    <span>${i18n().co_investigator_network_capitalized}</span>
                </a>
            </div>
        </#if>

    </div>
</#if>

${scripts.add('<script type="text/javascript" src="${googleJSAPI}"></script>',
    '<script type="text/javascript" src="${urls.base}/js/visualization/visualization-helper-functions.js"></script>'
    '<script type="text/javascript" src="${urls.base}/js/visualization/sparkline.js"></script>')}
<script type="text/javascript">
    var visualizationUrl = '${urls.base}/visualizationAjax?json=1&uri=${individual.uri?url}&template=${visRequestingTemplate!}';
    var infoIconSrc = '${urls.images}/iconInfo.png';
</script>