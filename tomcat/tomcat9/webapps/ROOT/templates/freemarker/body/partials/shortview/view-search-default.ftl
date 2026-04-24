<#ftl encoding="UTF-8">
<#import "lib-vivo-properties.ftl" as p>

<div class="individual" data-vclass="${individual.vclassUri!}">
    <a href="${individual.profileUrl}" title="Ver perfil de ${individual.name}">${individual.name}</a>
    <@p.displayTitle individual />
    <p class="snippet">${individual.snippet}</p>
</div>
