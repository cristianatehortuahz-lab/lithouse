<#-- $This file is distributed under the terms of the license in LICENSE$ -->

<#-- List individuals in the requested class. -->

<#import "lib-list.ftl" as l>

<#include "individualList-checkForData.ftl">

${stylesheets.add('<link rel="stylesheet" href="${urls.base}/css/browseIndex.css" />')}

<section class="individualList">
    <h2>${title!}
        <#if rdfUrl?has_content>
            <span class="rdfLink"><a class="icon-rdf" href="${rdfUrl}" title="${i18n().view_list_in_rdf(title)}">${i18n().rdf}</a></span>
        </#if>
    </h2>
    <#if subtitle?has_content>
        <h4>${subtitle}</h4>
    </#if>

    <#if (!noData)>
        <#if errorMessage?has_content>
            <p>${errorMessage}</p>
        <#else>
            <#assign pagination>
                <#if (pages?has_content && pages?size > 1)>
                    <nav class="searchpages" aria-label="Navegaci&oacute;n de p&aacute;ginas">
                        <#list pages as page>
                            <#if page.selected>
                                <span aria-current="page" class="current-page">${page.text}</span>
                            <#else>
                                <a href="${urls.base}/individuallist?${page.param}&vclassId=${vclassId?url}" 
                                   title="Go to page ${page.text}" 
                                   aria-label="Ir a la p&aacute;gina ${page.text}">${page.text}</a>
                            </#if>
                        </#list>
                    </nav>
                </#if>
            </#assign>

            ${pagination}

            <ul>
                <#list individuals as individual>
                    <li>
                        <@shortView uri=individual.uri viewContext="index" />
                    </li>
                </#list>
            </ul>

            ${pagination}
        </#if>
    <#else>
        ${noDataNotification}
    </#if>
</section> <!-- .individualList -->
