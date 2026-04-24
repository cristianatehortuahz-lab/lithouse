<#-- $This file is distributed under the terms of the license in LICENSE$ -->

<#-- Template for property listing on individual profile page -->

<#import "lib-properties-AcademicDepartment.ftl" as q>
<#import "lib-properties.ftl" as p>
<#list group.properties as property>
    <#assign rangeClass = "noRangeClass">
    <#if property.rangeUri?has_content && property.rangeUri?contains("#")>
        <#assign rangeClass = property.rangeUri?substring(property.rangeUri?last_index_of("#")+1)>
    <#elseif property.rangeUri?has_content >
        <#assign rangeClass = property.rangeUri?substring(property.rangeUri?last_index_of("/")+1)>
    </#if>

    <article class="property" role="article">
        <#-- Property display name -->
        <#--  <h1>valor de rango Class ${rangeClass}</h1>  -->


        <#if rangeClass == "Authorship" && individual.editable && (property.domainUri)?? && property.domainUri?contains("Person")>
            <h3 id="${property.localName}-${rangeClass}" title="${property.publicDescription!}">${property.name} <@p.addLink property editable /> <@p.verboseDisplay property />
                <a id="managePubLink" class="manageLinks" href="${urls.base}/managePublications?subjectUri=${subjectUri[1]!}" title="${i18n().manage_publications_link}" <#if verbose>style="padding-top:10px"</#if> >
                    ${i18n().manage_publications_link}
                </a>
            </h3>
        <#elseif rangeClass == "ResearcherRole" && individual.editable  >
            <h3 id="${property.localName}-${rangeClass}" title="${property.publicDescription!}">${property.name} <@p.addLink property editable /> <@p.verboseDisplay property />
                <a id="manageGrantLink" class="manageLinks" href="${urls.base}/manageGrants?subjectUri=${subjectUri[1]!}" title="${i18n().manage_grants_and_projects_link}" <#if verbose>style="padding-top:10px"</#if> >
                    ${i18n().manage_grants_and_projects_link}
                </a>
            </h3>
        <#elseif rangeClass == "Position" && individual.editable  >
            <h3 id="${property.localName}-${rangeClass}" title="${property.publicDescription!}">${property.name} <@p.addLink property editable /> <@p.verboseDisplay property />
                <a id="managePeopleLink" class="manageLinks" href="${urls.base}/managePeople?subjectUri=${subjectUri[1]!}" title="${i18n().manage_affiliated_people}" <#if verbose>style="padding-top:10px"</#if> >
                    ${i18n().manage_affiliated_people_link}
                </a>
            </h3>
        <#elseif rangeClass == "Name" && property.statements?has_content && editable >
            <h3 id="${property.localName}" title="${property.publicDescription!}">${property.name}  <@p.verboseDisplay property /> </h3>
        <#elseif rangeClass == "Title" && property.statements?has_content && editable >
            <h3 id="${property.localName}" title="${property.publicDescription!}">${property.name}  <@p.verboseDisplay property /> </h3>
        <#elseif rangeClass == "Authorship" && !individual.editable && (property.domainUri)?? && property.domainUri?contains("Person")>
            <h3 id="${property.localName}-${rangeClass}" title="${property.publicDescription!}">${property.name} <@p.addLink property editable /> <@p.verboseDisplay property /> </h3>
        <#elseif rangeClass == "ResearcherRole" && !individual.editable>
            <h3 id="${property.localName}-${rangeClass}" title="${property.publicDescription!}">${property.name} <@p.addLink property editable /> <@p.verboseDisplay property /> </h3>
        <#else>
            <h3 id="${property.localName}" title="${property.publicDescription!}">${property.name} <@p.addLink property editable /> <@p.verboseDisplay property /> </h3>
        </#if>
        <#-- List the statements for each property -->
            <#assign limit = property.getDisplayLimit()!4 />
            <#if limit == -1 || limit == 0 >
                <#assign limit = 4 />
            </#if>
        <ul class="property-list" role="list" id="${property.localName}-${rangeClass}-List" displayLimit="${limit}">
            <#-- data property -->
            
            <#--  <h1>1- ${property.localName}</h1>  -->
            <#--  <h1>2- ${property.publicDescription}??</h1>  -->
            <#--  <h1>3- ${property.name}</h1>  -->
            <#--  <h1>4- ${property.domainUri}</h1>  -->
            
            <#if property.type == "data">
                <@p.dataPropertyList property editable />

            <#-- object property -->
      
            <#else>
                <@p.objectProperty property editable/>

            </#if>



        </ul>
    </article> <!-- end property -->
</#list>