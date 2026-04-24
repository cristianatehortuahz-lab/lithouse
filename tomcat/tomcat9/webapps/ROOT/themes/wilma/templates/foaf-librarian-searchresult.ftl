<#-- Premium Person Card for Search — foaf-librarian-searchresult.ftl -->
<#if individual??>
<a href="${individual.profileUrl}" class="hub-sv-person-card" title="${individual.name}">

    <#-- Foto de perfil -->
    <div class="hub-sv-photo-wrap">
        <#if (individual.thumbUrl)??>
            <img class="hub-sv-photo"
                 src="${individual.thumbUrl}"
                 alt="${individual.name}"
                 loading="lazy"
                 onerror="this.onerror=null;this.src='${urls.base}/images/placeholders/person.thumbnail.jpg';" />
        <#else>
            <img class="hub-sv-photo"
                 src="${urls.base}/images/placeholders/person.thumbnail.jpg"
                 alt="${individual.name}"
                 loading="lazy" />
        </#if>
    </div>

    <#-- Info del investigador -->
    <div class="hub-sv-info">
        <span class="hub-sv-name">${individual.name}</span>

        <#-- Cargo/Rol -->
        <#if details?? && details?has_content && details[0].job?has_content>
            <span class="hub-sv-role">${details[0].job}</span>
        <#elseif (individual.mostSpecificTypeNames)?? && individual.mostSpecificTypeNames?has_content>
            <span class="hub-sv-dept">${individual.mostSpecificTypeNames[0]!""}</span>
        </#if>
        
        <#-- Departamento -->
        <#if (depart[0].div)?? >
             <span class="hub-sv-dept">${depart[0].div}</span>
        <#elseif (depart[0].org)?? >
             <span class="hub-sv-dept">${depart[0].org}</span>
        </#if>
    </div>

    <#-- Flecha de acción -->
    <span class="hub-sv-arrow">&#8250;</span>
</a>
</#if>
${stylesheets.add('<link rel="stylesheet" href="${urls.theme}/css/shortView/shortViewService.css" />')}