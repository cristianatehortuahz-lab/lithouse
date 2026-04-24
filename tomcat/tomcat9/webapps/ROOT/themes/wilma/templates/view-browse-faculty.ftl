<#import "lib-properties.ftl" as p>
<#import "lib-vivo-properties.ftl" as p>

<li class="col-lg-3 col-md-6 col-sm-12 hub-person-item" role="listitem" role="navigation">
    <div class="card h-100 hub-person-card-v2">
        <#-- Optimizaci\u00f3n LCP: fetchpriority="high" para el primer elemento -->
        <#assign isLCP = (isFirst?? && isFirst?string == "true") || (index?? && index == 0)>
        
        <div class="hub-card-img-container" style="min-height: 180px; background: #f8f9fa;">
            <#if (individual.thumbUrl)??>
                <img src="${individual.thumbUrl}" 
                     class="card-img-top hub-profile-photo" 
                     alt="${individual.name}"
                     width="270"
                     height="180"
                     style="object-fit: cover;"
                     <#if isLCP>fetchpriority="high"<#else>loading="lazy"</#if> />
            <#else>
                <img src="${urls.base}/images/placeholders/person.thumbnail.jpg" 
                     class="card-img-top hub-profile-photo" 
                     alt="${individual.name}"
                     width="270"
                     height="180"
                     style="object-fit: cover;"
                     <#if isLCP>fetchpriority="high"<#else>loading="lazy"</#if> />
            </#if>
        </div>

        <div class="card-body">
            <div class="card-text-container"> 
                <h5 class="card-title">
                    <a href="${individual.profileUrl}" title="${i18n().view_profile_page_for} ${individual.name}" class="hub-name-link">${individual.name}</a>
                </h5>
                <section class="card-text hub-dept-text">
                    <#if (depart[0].div)?? >
                        <a href="${depart[0].fac! "#"}" target="_blank">${depart[0].div}</a>
                    <#elseif (depart[0].org)?? >
                        <a href="${depart[0].fac! "#"}" target="_blank">${depart[0].org}</a>
                    <#elseif (depart[0].grp)?? >
                        <a href="${depart[0].fac! "#"}" target="_blank">${depart[0].grp}</a>
                    </#if>
                </section>
                
                <#if (extra[0].pt)?? >
                    <span class="card-text hub-extra-text">${extra[0].pt}</span>
                </#if>
            </div>
            
            <div class="card-footer hub-card-footer">
                <#list details as job>
                    <span class="hub-job-title">${job.job}</span>
                </#list>
            </div>
        </div>
    </div>
</li>
