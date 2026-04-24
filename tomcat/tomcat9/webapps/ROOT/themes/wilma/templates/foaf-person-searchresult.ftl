<#-- Premium Person Card — shortView-foaf-Person.ftl -->
<#import "lib-properties.ftl" as p>

<#if individual??>
<a href="${individual.profileUrl}" class="hub-person-card" title="${individual.name}" data-vclass="${individual.vclassUri!}">

    <div class="hub-sv-card-main">
        <#-- Foto de perfil -->
        <div class="hub-sv-photo-wrap">
            <#assign isLCP = (isFirst?? && isFirst?string == "true")>
            <#if (individual.thumbUrl)?? && individual.thumbUrl?has_content>
                <img class="hub-sv-photo"
                     src="${individual.thumbUrl}"
                     alt="${(individual.name)!""}"
                     width="68"
                     height="68"
                     <#if isLCP>fetchpriority="high"<#else>loading="lazy"</#if>
                     onerror="this.onerror=null;this.src='${(urls.base)!""}/images/placeholders/person.thumbnail.jpg';" />
            <#else>
                <img class="hub-sv-photo"
                     src="${(urls.base)!""}/images/placeholders/person.thumbnail.jpg"
                     alt="${(individual.name)!""}"
                     width="68"
                     height="68"
                     <#if isLCP>fetchpriority="high"<#else>loading="lazy"</#if> />
            </#if>
        </div>

        <#-- Info del investigador -->
        <div class="hub-sv-info">
            <div class="hub-sv-header">
                <#-- v20.4: Uso de variables compatibles con el Motor de Búsqueda (details/depart) -->
                <#assign roleLabel = "">
                <#if details?? && (details[0].job)??><#assign roleLabel = details[0].job></#if>
                <#assign deptLabel = "">
                <#if depart??>
                    <#if (depart[0].div)??><#assign deptLabel = depart[0].div><#elseif (depart[0].org)??><#assign deptLabel = depart[0].org></#if>
                </#if>
                
                <#assign cleanName = (individual.name)!"" >
                <#if roleLabel?has_content><#assign cleanName = cleanName?replace(roleLabel, "")></#if>
                <#if deptLabel?has_content><#assign cleanName = cleanName?replace(deptLabel, "")></#if>
                <#assign cleanName = cleanName?replace(">", "")?trim>

                <span class="hub-sv-name">${cleanName}</span>
            </div>

            <#-- Cargo/Rol -->
            <#if roleLabel?has_content>
                <span class="hub-sv-role">${roleLabel}</span>
            <#else>
                <span class="hub-sv-role">Investigador Universidad del Rosario</span>
            </#if>

            <#-- Badge de Facultad -->
            <#if deptLabel?has_content>
                <span class="hub-sv-dept-tag">${deptLabel}</span>
            <#elseif individual.mostSpecificTypeNames?? && individual.mostSpecificTypeNames?has_content>
                <#if individual.mostSpecificTypeNames[0] != "Persona" && individual.mostSpecificTypeNames[0] != "Person">
                    <span class="hub-sv-dept-tag">${individual.mostSpecificTypeNames[0]}</span>
                </#if>
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