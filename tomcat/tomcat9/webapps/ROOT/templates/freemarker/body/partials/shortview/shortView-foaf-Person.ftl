<#-- Premium Person Card — shortView-foaf-Person.ftl -->
<#import "lib-properties.ftl" as p>

<#if individual??>
<a href="${individual.profileUrl}" class="hub-person-card" title="${individual.name}" data-vclass="${individual.vclassUri!}">

    <div class="hub-sv-card-main">
        <#-- Foto de perfil -->
        <div class="hub-sv-photo-wrap">
            <#if individual.thumbUrl?has_content>
                <img class="hub-sv-photo"
                     src="${individual.thumbUrl}"
                     alt="${individual.name}"
                     width="68"
                     height="68"
                     loading="lazy"
                     onerror="this.onerror=null;this.src='${urls.base}/images/placeholders/person.thumbnail.jpg';" />
            <#else>
                <img class="hub-sv-photo"
                     src="${urls.base}/images/placeholders/person.thumbnail.jpg"
                     alt="${individual.name}"
                     width="68"
                     height="68"
                     loading="lazy" />
            </#if>
        </div>

        <#-- Info del investigador -->
        <div class="hub-sv-info">
            <div class="hub-sv-header">
                <#-- v2.0: Limpieza de redundancia -->
                <#assign roleLabel = "">
                <#if PeopleData?? && PeopleData?has_content && PeopleData[0].jobTitle?has_content><#assign roleLabel = PeopleData[0].jobTitle></#if>
                <#assign deptLabel = "">
                <#if PeopleData?? && PeopleData?has_content && PeopleData[0].deptLabel?has_content><#assign deptLabel = PeopleData[0].deptLabel></#if>

                <#assign cleanName = individual.name>
                <#if roleLabel?has_content><#assign cleanName = cleanName?replace(roleLabel, "")></#if>
                <#if deptLabel?has_content><#assign cleanName = cleanName?replace(deptLabel, "")></#if>
                <#assign cleanName = cleanName?replace(">", "")?trim>

                <span class="hub-sv-name">${cleanName}</span>
            </div>

            <#-- Cargo/Rol -->
            <#if PeopleData?? && PeopleData?has_content && PeopleData[0].jobTitle?has_content>
                <span class="hub-sv-role">${PeopleData[0].jobTitle}</span>
            <#else>
                <span class="hub-sv-role">Investigador Universidad del Rosario</span>
            </#if>

            <#-- Badge de Facultad -->
            <#if PeopleData?? && PeopleData?has_content && PeopleData[0].deptLabel?has_content>
                <span class="hub-sv-dept-tag">${PeopleData[0].deptLabel}</span>
            <#elseif individual.mostSpecificTypeNames?? && individual.mostSpecificTypeNames?has_content>
                <span class="hub-sv-dept-tag">${individual.mostSpecificTypeNames[0]!""}</span>
            </#if>

            <#-- Snippet / Breve descripci\u00F3n if available -->
            <#if individual.snippet?has_content>
                <p class="hub-sv-snippet">${individual.snippet}</p>
            </#if>
        </div>
    </div>

    <#-- Footer con acci\u00F3n — Minimalista (s\u00F3lo flecha) -->
    <div class="hub-sv-footer-minimal">
        <span class="hub-sv-arrow-new">&#8250;</span>
    </div>
</a>
</#if>