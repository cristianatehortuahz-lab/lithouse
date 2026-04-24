<#import "lib-vivo-properties.ftl" as p>
<!-- a href="${individual.profileUrl}" title="${i18n().individual_name}">${individual.name}</a-->
<span title="${i18n().individual_name}">${individual.name}</span>
<#if (individual.validatorur)?? >
<div>
${individual.validatorur}
</div>
</#if>
<@p.displayTitle individual />

<p class="snippet">${individual.snippet}</p>


