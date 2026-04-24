
<#import "lib-properties.ftl" as p>

<#--  ${stylesheets.add('<link rel="stylesheet" type="text/css" href="${urls.base}/themes/wilma/css/shortView/shortViewOrganization.css"/>')}  -->

<#if individual.name?has_content>
    <div class="individual" role="listitem" role="navigation" id="organizationIndividual">

        <div class="org-img">
            <#if (individual.thumbUrl)??>
                <img src="${individual.thumbUrl}" width="100%" alt="${individual.name}" />
            <#else>
                <img src="${urls.base}/images/placeholders/thumbnail.jpg" width="100%" alt="${individual.name}" />
            </#if>
        </div>

        <div class="org-desc">
            <h1 class="thumb JFLF">
                <a href="${individual.profileUrl}" title="View the profile page for
                    ${individual.name}}">${individual.name}</a>
            </h1>
            <#if (OrganizationOverview[0].OrgOverview)?? >
                <#if OrganizationOverview[0].OrgOverview?length <= 400>
                <span class="title">${OrganizationOverview[0].OrgOverview}</span>
                <#else>
                <span class="title">${OrganizationOverview[0].OrgOverview?substring(0,400)}... <a class="blue-text"  href="${individual.profileUrl}" target="_blank">ver m&aacute;s</a> </span>
                </#if>
                </div>
            </#if>
        </div>
</#if>
<#--  ${stylesheets.add('<link rel="stylesheet" href="${urls.base}/themes/wilma/css/shortView/shortViewService.css" />')}  -->
