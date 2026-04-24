<#-- $This file is distributed under the terms of the license in LICENSE$ -->

<#-- Template for property listing on individual profile page -->

<#import "lib-properties.ftl" as p>
<#assign subjectUri = individual.controlPanelUrl()?split("=") >
<#assign tabCount = 1 >
<#assign sectionCount = 1 >

<div class="row individual-objects">
    <div class="col-md-2">
        <ul class="nav nav-pills nav-stacked" role="tablist">
            <#list propertyGroups.all as groupTabs>
                <#if ( groupTabs.properties?size > 0 ) >
                    <#assign groupName = groupTabs.getName(nameForOtherGroup)>
                    <#assign groupNameHtmlId = p.createPropertyGroupHtmlId(groupName) >
                    <#if tabCount = 1 >
                        <li role="presentation" class="nav-item">
                            <a class="nav-link active" id="${groupNameHtmlId?replace("/", "-")}-tab"
                                data-bs-toggle="tab"
                                data-bs-target="#${groupNameHtmlId?replace("/", "-")}"
                                role="tab"
                                aria-controls="${groupName?capitalize}"
                                aria-selected="true">
                                ${groupName?capitalize}
                            </a>
                        </li>
                        <#assign tabCount = 2>
                    <#else>
                        <li role="presentation" class="nav-item">
                            <a class="nav-link" id="${groupNameHtmlId?replace("/", "-")}-tab"
                            data-bs-toggle="tab"
                            data-bs-target="#${groupNameHtmlId?replace("/", "-")}"
                            role="tab"
                            aria-controls="${groupName?capitalize}"
                            aria-selected="false">
                            ${groupName?capitalize}
                            </a>
                        </li>
                    </#if>
                </#if>
            </#list>
        </ul>
    </div>

    <div class="col-md-10">
        <div class="tab-content">
            <#list propertyGroups.all as group>
                <#if (group.properties?size > 0)>
                    <#assign groupName = group.getName(nameForOtherGroup)>
                    <#assign groupNameHtmlId = p.createPropertyGroupHtmlId(groupName) >
                    <#assign verbose = (verbosePropertySwitch.currentValue)!false>
                    <div
                        id="${groupNameHtmlId?replace("/", "-")}"
                        class="tab-pane <#if (sectionCount > 1) ><#else>active</#if>"
                        role="tabpanel">
                        <#-- Display the group heading -->
                        <#if groupName?has_content>
                            <#--the function replaces spaces in the name with underscores, also called for the property group menu-->
                            <#assign groupNameHtmlId = p.createPropertyGroupHtmlId(groupName) >
                            <h1 id="${groupNameHtmlId?replace("/","-")}" pgroup="tabs" class="hidden">${p.capitalizeGroupName(groupName)}</h1>
                        <#else>
                            <h2 id="properties" pgroup="tabs" class="hidden">${i18n().properties_capitalized}</h2>
                        </#if>
                        <div id="${groupNameHtmlId?replace("/","-")}Group" >
                            <#-- List the properties in the group   -->
                            <#include "individual-properties.ftl">
                        </div>
                    </div>
                    <#assign sectionCount = 2 >
                </#if>
            </#list>
        </div>
    </div>
</div>

<script>
    var individualLocalName = "${individual.localName}";
</script>

${stylesheets.add('<link rel="stylesheet" href="${urls.base}/css/individual/individual-property-groups.css" />')}
<#--  ${stylesheets.add('<link rel="stylesheet" href="${urls.base}/themes/wilma/css/individual-person-property-groups.css" />')}  -->
${headScripts.add('<script type="text/javascript" src="${urls.base}/js/amplify/amplify.store.min.js"></script>')}
${scripts.add('<script type="text/javascript" src="${urls.base}/js/individual/propertyGroupControls.js"></script>')}
