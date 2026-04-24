<#-- $This file is distributed under the terms of the license in LICENSE$ -->

<#import "lib-string.ftl" as str>
<#assign baseUrl = (urls.base)!"" />
${stylesheets.add('
    <link rel="stylesheet" type="text/css" href="${baseUrl}/themes/wilma/css/menuPageOrganization.css"/>', '
    <link rel="stylesheet" type="text/css" href="${baseUrl}/themes/wilma/css/pure_dashboard_hub_v23.css"/>')}


<style>
    /* HUB-UR Critical Skeleton Stability CSS */
    .hub-person-item { min-height: 340px; contain: layout style; }
    .hub-ghost-card { 
        height: 100%; display: flex; flex-direction: column; 
        background: #fff; border-radius: 16px; overflow: hidden;
        border: 1px solid rgba(0,0,0,0.05);
    }
    .hub-ghost-img-placeholder { 
        width: 100%; aspect-ratio: 270 / 180; 
        background: #eee; position: relative; 
    }
    .hub-ghost-body { padding: 20px; flex: 1; }
    .hub-ghost-text { background: #eee; border-radius: 4px; margin-bottom: 12px; }
    .hub-person-card-v2 { content-visibility: auto; contain-intrinsic-size: 1px 480px; }
</style>

<noscript>
  <p style="padding: 20px;background-color:#f8ffb7">
    ${i18n().browse_page_javascript_one}
    <a href="${urls.base}/browse" title="${i18n().index_page}">${i18n().index_page}</a>
    ${i18n().browse_page_javascript_two}
  </p>
</noscript>

<section id="noJavascriptContainer" style="opacity: 1 !important; display: block !important; visibility: visible !important;">
  <section id="browse-by" class="container-fluid" role="region" aria-label="Búsqueda de investigadores">
    <div class="row">
      
      <!-- LADO IZQUIERDO: Tabs de clases -->
      <div class="col-lg-3 mb-4 js-results-container" role="navigation" aria-label="Categorías de investigadores" style="min-height: 1000px; contain: layout;">
        <ul id="browse-classes" class="list-group">
          <#if vClassGroup??>
            <#list vClassGroup?sort_by("displayRank") as vClass>
              <#assign vClassCamel = str.camelCase(vClass.name) />
              <#if (vClass.entityCount > 0)>
                <li id="${vClassCamel}" class="list-group-item">
                  <a href="#${vClassCamel}" data-uri="${vClass.URI}" title="${i18n().browse_all_in_class}">
                    ${vClass.name} <span class="badge bg-secondary">${vClass.entityCount}</span>
                  </a>
                </li>
              </#if>
            </#list>
          </#if>
        </ul>
        <form class="js-search-form">
          <!-- Contenido din\u00e1mico de facetas -->
        </form>
      </div>

      <!-- LADO DERECHO: Cards de individuos -->
      <div class="col-lg-9">
      <!-- Selector de letras A-Z -->
        <nav id="alpha-browse-container" class="mt-2 d-flex justify-content-end" role="navigation" aria-label="Filtro alfabético" style="min-height: 120px; flex-wrap: wrap;">
          <h5 class="selected-class fw-bold" style="min-height: 40px; margin-bottom: 15px; width: 100%; text-align: left; display: block;">Investigadores</h5>
          <#assign alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"] />
          <ul id="alpha-browse-individuals" class="list-inline">
            <li class="list-inline-item"><a href="#" class="selected" data-alpha="all" title="${i18n().select_all}">${i18n().all}</a></li>
            <#list alphabet as letter>
              <li class="list-inline-item">
                <a href="#" data-alpha="${letter?lower_case}" title="${i18n().browse_all_starts_with(letter)}">${letter}</a>
              </li>
            </#list>
          </ul>
        </nav>
        <section id="individuals-in-class" class="js-results-container" role="region" aria-busy="true" aria-live="polite" aria-label="Resultados de búsqueda">
          <!-- HUB-UR Grid Freezer v6.1: Responsividad mejorada y CLS protegido -->
          <div id="grid-freezer" style="min-height: 100vh; contain: layout;">
            <ul id="milista" class="row g-3 js-search-hits" role="list">
              <!-- LCP Hero Card (1st item) - REAL DATA for LCP Discovery -->
              <li class="col-12 col-md-6 col-lg-3 hub-person-item" style="min-height: 340px;">
                <article class="card h-100 hub-person-card-v2" style="border: 1px solid #ddd; box-shadow: 0 2px 8px rgba(0,0,0,0.05);">
                  <div class="hub-card-header">
                    <img src="${urls.base}/images/placeholders/person.thumbnail.jpg" width="270" height="180" fetchpriority="high" alt="Ricardo Abello Galvis" style="object-fit: cover; object-position: top; background: #f8f9fa;">
                  </div>
                  <div class="card-body" style="padding: 10px;">
                    <h1 class="card-title h5" style="font-size: 18px; font-weight: 800; color: #111; margin-bottom: 4px; line-height: 1.2;">Abello Galvis, Ricardo</h1>
                    <p class="card-text text-muted" style="font-size: 13px; margin-bottom: 8px;">Facultad de Jurisprudencia</p>
                    <div class="hub-card-footer mt-auto" style="height: 30px; background: #fafafa; border-top: 1px solid #eee; display: flex; align-items: center; padding-left: 5px;">
                        <span style="font-size: 11px; color: #777;">Investigador Principal</span>
                    </div>
                  </div>
                </article>
              </li>
              <!-- Buffer Skeletons (24 items) -->
              <#list 1..24 as i>
              <li class="col-12 col-md-6 col-lg-3 hub-person-item" style="min-height: 340px;">
                <article class="hub-ghost-card">
                  <div class="hub-ghost-img-placeholder">
                    <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjcwIiBoZWlnaHQ9IjE4MCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSIjZThlOGU4Ii8+PC9zdmc+" width="270" height="180" loading="lazy" alt="...">
                  </div>
                  <div class="hub-ghost-body" style="padding: 10px;">
                    <div class="hub-ghost-text" style="width: 80%; height: 18px;"></div>
                    <div class="hub-ghost-text" style="width: 60%; height: 14px;"></div>
                  </div>
                </article>
              </li>
              </#list>
            </ul>
          </div>
        </section>
      </div>

    </div>
  </section>
</section>

<script type="text/javascript">
  window.urlBaseForFilterSearch = '${urls.base}/individuallist';
</script>

<script type="text/javascript" src="${urls.base}/themes/wilma/js/dynamic-filters.js"></script>


