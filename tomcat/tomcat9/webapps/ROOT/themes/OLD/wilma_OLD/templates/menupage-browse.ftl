<#-- $This file is distributed under the terms of the license in LICENSE$ -->

<#import "lib-string.ftl" as str>

<noscript>
  <p style="padding: 20px;background-color:#f8ffb7">
    ${i18n().browse_page_javascript_one}
    <a href="${urls.base}/browse" title="${i18n().index_page}">${i18n().index_page}</a>
    ${i18n().browse_page_javascript_two}
  </p>
</noscript>

<section id="noJavascriptContainer" class="hidden">
  <section id="browse-by" class="container-fluid" role="region">
    <div class="row">
      
      <!-- LADO IZQUIERDO: Tabs de clases -->
      <div class="col-lg-3 mb-4" role="navigation">
        <ul id="browse-classes" class="list-group">
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
        </ul>
      </div>

      <!-- LADO DERECHO: Cards de individuos -->
      <div class="col-lg-9">
         <!-- Selector de letras A-Z -->
        <nav id="alpha-browse-container" class="mt-4" role="navigation">
          <h5 class="selected-class fw-bold"></h5>
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
    

        <section id="individuals-in-class"  class="indivs" role="region">
          <#--  <ul class="row g-3" role="list">  -->
            <!-- Aquí se insertarán las cards dinámicamente via AJAX -->
          <#--  </ul>  -->
        </section>
      </div>

    </div>
  </section>
</section>

<script type="text/javascript">
  $('section#noJavascriptContainer').removeClass('hidden');
</script>
