
<#ftl encoding="UTF-8">
<#import "lib-properties.ftl" as p>

<#--  ${stylesheets.add('<link rel="stylesheet" type="text/css" href="${urls.base}/themes/wilma/css/shortView/shortViewOrganization.css"/>')}  -->

<#if individual.name?has_content>
    <div class="individual" role="listitem" role="navigation" id="organizationIndividual" data-vclass="${individual.vclassUri!}">
        <div class="org-desc">
                 <a href="${individual.profileUrl}" title="Ver la p&aacute;gina de perfil de ${individual.name}">${individual.name}</a>
            <#if (OrganizationOverview[0].OrgOverview)?? >
                <#if OrganizationOverview[0].OrgOverview?length <= 400>
                <span class="title">${OrganizationOverview[0].OrgOverview}</span>
                <#else>
                <span class="title">${OrganizationOverview[0].OrgOverview?substring(0,400)}... <a class="blue-text"  href="${individual.profileUrl}" target="_blank">ver m&aacute;s</a> </span>
                </#if>
            </#if>
        </div>
    </div>
</#if>

