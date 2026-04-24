<#import "lib-properties.ftl" as p>
 

<li class="individual" role="listitem" role="navigation">
 
<#if (individual.thumbUrl)??>
    <img src="${individual.thumbUrl}" width="90" alt="${individual.name}" />
<#else>
    <img src="${urls.base}/images/placeholders/thumbnail.jpg" width="100%" alt="${individual.name}" />
</#if>
    <div class="text-contect">
        <h1>
            <a href="${individual.profileUrl}" title="View the profile page for
                ${individual.name}}">${individual.name}</a>
        </h1>
        <#if (OrganizationOverview[0].OrgOverview)?? >
            <#if OrganizationOverview[0].OrgOverview?length <= 400>
                <span class="title">${OrganizationOverview[0].OrgOverview}</span>
            <#else>
                <span class="title">${OrganizationOverview[0].OrgOverview?substring(0,400)}... <a class="blue-text" href="${individual.profileUrl}" target="_blank">ver m&aacute;s</a> </span>
            </#if>
        </#if>
    </div>
</li>


