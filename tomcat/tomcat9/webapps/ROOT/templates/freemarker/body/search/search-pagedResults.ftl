<#ftl encoding="UTF-8">
<#-- $This file is distributed under the terms of the license in LICENSE$ -->

${stylesheets.add('<link rel="stylesheet" type="text/css" href="${urls.base}/css/nouislider.css"/>')}
${stylesheets.add('<link rel="stylesheet" type="text/css" href="${urls.base}/css/search-results.css"/>')}
${stylesheets.add('<link rel="stylesheet" type="text/css" href="${urls.base}/js/bootstrap/css/bootstrap.min.css"/>')}
${stylesheets.add('<link rel="stylesheet" type="text/css" href="${urls.base}/js/bootstrap/css/bootstrap-theme.min.css"/>')}
${headScripts.add('<script type="text/javascript" src="${urls.base}/js/nouislider.min.js"></script>')}
${headScripts.add('<script type="text/javascript" src="${urls.base}/js/wNumb.min.js"></script>')}
${headScripts.add('<script type="text/javascript" src="${urls.base}/js/bootstrap/js/bootstrap.min.js"></script>')}

<@searchForm  />

<#-- Detectar si hay algún filtro de VIVO aplicado (como classgroup u otros) -->
<#assign isClassgroupView = false />
<#assign cgTitle = "🔍 Resultados" />

<#if classGroupUri?has_content || classGroupName?has_content || typeUri?has_content || typeName?has_content>
    <#assign isClassgroupView = true />
    <#if classGroupName?has_content>
        <#assign cgTitle = classGroupName />
    <#elseif typeName?has_content>
        <#assign cgTitle = typeName />
    </#if>
</#if>

<#-- Hub custom facet engine detection -->
<#if filters??>
    <#list filters?values as filter>
        <#if filter.values??>
            <#list filter.values?values as v>
                <#if v.selected>
                    <#assign isClassgroupView = true />
                    <#assign cgTitle = v.text!"" />
                </#if>
            </#list>
        </#if>
    </#list>
</#if>

<#-- Override title if specific type is requested -->
<#assign cgType = (parameters.filters_type[0])!"" />
<#if cgType == "Program">
    <#assign cgTitle = "Programas Acad&eacute;micos" />
<#elseif cgType == "Organization" || cgType == "ResearchGroup">
    <#assign cgTitle = "Unidades y Grupos de Investigaci&oacute;n" />
</#if>

<#if isClassgroupView>
<#-- ==== VISTA DE LISTA PAGINADA (cuando viene de "Ver todos" o hay filtros nativos) ==== -->
<div id="hub-classgroup-view">
    <div id="hub-cg-header">
        <a href="javascript:history.back()" id="hub-back-btn">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="16" height="16"><polyline points="15 18 9 12 15 6"/></svg>
            Volver al panel de b&uacute;squeda
        </a>
        <h1 id="hub-cg-title">
            <#if cgTitle == "People">&#x1F464; Investigadores
            <#elseif cgTitle == "Publications" || cgTitle == "ScholarlyWork" || cgTitle == "Research">&#x1F4D6; Producci&oacute;n Acad&eacute;mica
            <#elseif cgTitle == "Organizations" || cgTitle?contains("Groups") || cgTitle == "Organization">&#x1F3DB; Unidades y Grupos de Investigaci&oacute;n
            <#elseif cgTitle == "Projects">&#x2B50; Proyectos
            <#elseif cgTitle == "Events" || cgTitle == "Activities">&#x1F4C5; Actividades y Eventos
            <#else>${cgTitle}
            </#if>
        </h1>
        <p id="hub-cg-count">${hitCount?c} resultado<#if hitCount != 1>s</#if> encontrado<#if hitCount != 1>s</#if></p>
    </div>

    <#-- Lista nativa de VIVO (searchhits) — ya renderizada por servidor -->
    <div id="hub-cg-results">
        <ul class="hub-cg-list searchhits">
            <#list individuals as individual>
                <li>
                    <@shortView uri=individual.uri viewContext="search" />
                </li>
            </#list>
        </ul>
    </div>

    <#-- Paginación -->
    <div id="hub-cg-paging">
        <@printPagingLinks />
    </div>
    
    <#-- SCRIPT DE FILTRADO ESTRICTO EN TIEMPO REAL -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const params = new URLSearchParams(window.location.search);
            const typeParam = params.get('type') || params.get('filters_type');
            if (!typeParam) return;
            
            // Determinar si buscamos Programas o Organizaciones genéricas
            const isProgram = typeParam.includes('Program');
            const isOrg = typeParam.includes('Organization');
            if (!isProgram && !isOrg) return;
            
            let visibleCount = 0;
            const items = document.querySelectorAll('.hub-cg-list.searchhits > li');
            
            items.forEach(li => {
                const individual = li.querySelector('.individual[data-vclass]');
                let vclass = individual ? individual.getAttribute('data-vclass') : '';
                
                // Si no hay data-vclass, intentamos buscarlo en elementos internos
                if (!vclass) {
                    const inner = li.querySelector('[data-vclass]');
                    if (inner) vclass = inner.getAttribute('data-vclass');
                }

                // Detección: si tiene Program/Degree o si tiene el icono de birrete de los programas
                const isItemProgram = vclass.includes('Program') || vclass.includes('Degree') || li.querySelector('.hub-program-icon, .hub-program-card') !== null;
                
                // Reglas de visibilidad
                if (isProgram && !isItemProgram) {
                    li.style.display = 'none';
                } else if (isOrg && isItemProgram) {
                    li.style.display = 'none';
                } else {
                    visibleCount++;
                }
            });
            
            // Actualizar conteo visible y ocultar paginación si se alteró la lista
            const totalItemsSpan = document.getElementById('hub-cg-count');
            if (totalItemsSpan && visibleCount !== items.length) {
                totalItemsSpan.textContent = visibleCount + (visibleCount === 1 ? ' resultado encontrado' : ' resultados encontrados');
                const paging = document.getElementById('hub-cg-paging');
                if (paging) paging.style.display = 'none'; // Ocultar paginador roto
            }
        });
    </script>
</div>

<#else>
<#-- ==== DASHBOARD NORMAL (sin classgroup en URL) ==== -->
<div class="contentsBrowseGroup" id="pure-dashboard-wrapper">
    <div style="display:none;"><@printPagingLinks /></div>

    <style>
      /* ESTILOS INYECTADOS DIRECTAMENTE PARA EVITAR CACHE DEL NAVEGADOR */
      #pure-dashboard-wrapper {
        width: 100% !important;
        max-width: 1220px !important;
        margin: 0 auto !important;
        padding-left: 0 !important;
        padding-right: 0 !important;
        box-sizing: border-box !important;
      }
      #dashboard-top-header {
        display: flex !important;
        justify-content: space-between !important;
        align-items: flex-end !important;
        width: 100% !important;
        margin-top: 40px !important;
        margin-bottom: 25px !important;
        padding: 0 !important;
        box-sizing: border-box !important;
        position: relative !important; /* v4.8: Added relative context for absolute summary positioning */
      }
      .header-sidebar-title { 
        width: 224px !important; 
        flex-shrink: 0 !important;
        margin: 0 !important;
        padding: 0 !important;
      }
      .header-sidebar-title h3 {
        font-size: 9.5px !important; font-weight: 800 !important; color: #6b7280 !important;
        text-transform: uppercase !important; letter-spacing: 1.2px !important;
        margin: 0 !important; padding: 0 !important; line-height: normal !important;
      }
      .header-main-info {
        position: absolute !important;
        left: 264px !important; /* 224px title + 40px gap */
        right: 0 !important; /* Force stretch to the absolute right edge */
        bottom: 0 !important;
        display: flex !important;
        justify-content: space-between !important;
        align-items: center !important;
        padding-bottom: 8px !important;
        border-bottom: none !important; /* v2.2: Removed horizontal line */
        box-sizing: border-box !important;
        min-width: 0 !important;
      }
      .hub-results-count {
        font-size: 11.5px !important; color: #6b7280 !important; margin: 0 !important;
        line-height: normal !important; white-space: nowrap !important;
      }
      .hub-query-text { font-weight: 700 !important; color: #9b0000 !important; }
      /* ANTIDOTO CONTRA FLOATS DE VIVO (search-results.css:19) */
      .header-utilities {
        display: flex !important;
        align-items: center !important;
        justify-content: flex-end !important;
        margin: 0 !important;
        padding: 0 !important;
        float: none !important;
        flex-shrink: 0 !important;
      }
      .header-utilities h2.searchResultsHeader {
        display: flex !important; 
        align-items: center !important; 
        gap: 8px !important;
        float: none !important; 
        margin: 0 !important; 
        padding: 0 !important;
        font-size: 11.5px !important; 
        font-weight: 500 !important; 
        color: #6b7280 !important;
        text-align: right !important;
        width: auto !important;
      }
      .header-utilities img#downloadIcon {
        margin-top: -2px !important;
        width: 17px !important;
        height: 17px !important;
        display: block !important;
        float: none !important;
        margin-left: 8px !important;
      }
      /* v4.9: Hide redundant search results text in utilities */
      .header-utilities h2.searchResultsHeader {
        font-size: 0 !important;
        color: transparent !important;
        display: flex !important;
        align-items: center !important;
      }
      .header-utilities #downloadIcon {
        margin-left: 0 !important;
        cursor: pointer !important;
        transition: transform 0.2s ease, filter 0.2s ease !important;
      }
      .header-utilities #downloadIcon:hover {
        transform: scale(1.15) !important;
        filter: brightness(1.2) drop-shadow(0 0 5px rgba(0,0,0,0.1)) !important;
      }

      /* v5.2: Premium Download Popup with native HTML5 range slider */
      .downloadTip {
        padding: 0 !important;
        max-width: none !important;
      }
      .download-popup-container {
        display: flex !important;
        padding: 22px !important;
        gap: 0 !important;
      }
      .download-options-side {
        flex: 1 !important;
        padding-right: 22px !important;
      }
      .download-settings-side {
        width: 140px !important;
        padding-left: 22px !important;
        border-left: 1px solid #e5e7eb !important;
        display: flex !important;
        flex-direction: column !important;
        align-items: center !important;
      }
      .download-header {
        font-weight: 700 !important;
        color: #111827 !important;
        font-size: 13px !important;
        margin-bottom: 14px !important;
      }
      .download-popup-container label {
        font-weight: 600 !important;
        color: #374151 !important;
        font-size: 11px !important;
        text-transform: uppercase !important;
        letter-spacing: 0.5px !important;
        margin-bottom: 4px !important;
        display: block !important;
        text-align: center !important;
      }
      .range-value {
        display: block !important;
        text-align: center !important;
        font-size: 22px !important;
        font-weight: 800 !important;
        color: #9b0000 !important;
        margin-bottom: 10px !important;
      }
      /* Number input for records */
      #download-amount {
        -webkit-appearance: none !important;
        -moz-appearance: textfield !important;
        width: 80px !important;
        text-align: center !important;
        font-size: 28px !important;
        font-weight: 800 !important;
        color: #9b0000 !important;
        border: 2px solid #e5e7eb !important;
        border-radius: 10px !important;
        padding: 8px !important;
        margin: 10px auto !important;
        display: block !important;
        background: #fafafa !important;
        transition: border-color 0.2s !important;
      }
      #download-amount:focus {
        border-color: #9b0000 !important;
        outline: none !important;
        box-shadow: 0 0 0 3px rgba(155, 0, 0, 0.1) !important;
      }
      #download-amount::-webkit-inner-spin-button,
      #download-amount::-webkit-outer-spin-button {
        -webkit-appearance: none !important;
        margin: 0 !important;
      }
      .downloadTip .download-url a {
        display: flex !important;
        align-items: center !important;
        gap: 8px !important;
        padding: 10px 14px !important;
        margin-bottom: 8px !important;
        background: #fafafa !important;
        border: 1px dashed #d1d5db !important;
        border-radius: 8px !important;
        color: #9b0000 !important;
        text-decoration: none !important;
        font-weight: 600 !important;
        font-size: 13px !important;
        transition: all 0.2s ease !important;
      }
      .downloadTip .download-url a svg {
        flex-shrink: 0 !important;
      }
      .downloadTip .download-url a:hover {
        background: #9b0000 !important;
        color: #ffffff !important;
        border-color: #9b0000 !important;
        border-style: solid !important;
        transform: translateX(5px) !important;
      }
      .downloadTip .download-url a:hover svg {
        stroke: #ffffff !important;
      }
      .downloadTip a.close {
        color: #9ca3af !important;
        font-size: 10px !important;
        text-transform: uppercase !important;
        font-weight: 700 !important;
        text-decoration: none !important;
        letter-spacing: 0.5px !important;
        margin-top: auto !important;
      }
      .downloadTip a.close:hover { color: #9b0000 !important; }
      
      /* Reset for category dividers */
      .category-header, .category-footer, hr { border: none !important; }
    </style>

    <#-- Cabecera unificada y alineada -->
    <header id="dashboard-top-header">
        <div class="header-sidebar-title">
            <h3>Tipo de resultado</h3>
        </div>
        <div class="header-main-info">
            <p class="hub-results-count">
                ${(hitCount!0)?c} resultados encontrados <#if querytext?has_content>para <span class="hub-query-text">${querytext!""}</#if></span>
            </p>
            <div class="header-utilities">
                <@printResultNumbers />
            </div>
        </div>
    </header>

    <div id="dashboard-search-layout">

        <!-- ===== SIDEBAR ===== -->
        <aside id="dashboard-sidebar">
            <ul id="content-type-menu">

                <li data-target="category-profiles">
                    <svg class="sidebar-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/></svg>
                    <span>Investigadores</span>
                    <span class="hub-badge loading" id="hub-sidebar-profiles-v156"></span>
                </li>

                <li data-target="category-organizations">
                    <svg class="sidebar-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2"/></svg>
                    <span>Unidades y Grupos de Investigaci&oacute;n</span>
                    <span class="hub-badge loading" id="hub-sidebar-organizations-v156"></span>
                </li>

                <li data-target="category-programs">
                    <svg class="sidebar-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/></svg>
                    <span>Programas Acad&eacute;micos</span>
                    <span class="hub-badge loading" id="hub-sidebar-programs-v156"></span>
                </li>

                <li data-target="category-publications">
                    <svg class="sidebar-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
                    <span>Producci&oacute;n Acad&eacute;mica</span>
                    <span class="hub-badge loading" id="hub-sidebar-publications-v156"></span>
                </li>

            </ul>
        </aside>

        <!-- ===== &Aacute;REA PRINCIPAL ===== -->
        <main id="dashboard-main-results">

            <div id="dashboard-global-loader">
                <div class="loader-dots">
                    <div class="loader-dot"></div>
                    <div class="loader-dot"></div>
                    <div class="loader-dot"></div>
                </div>
                <p>Buscando resultados...</p>
            </div>

            <!-- INVESTIGADORES -->
            <section id="category-profiles" class="dashboard-category" style="display:none;">
                <h2 class="category-header cat-profiles">
                    <span class="category-header-icon">&#x1F464;</span>
                    <span class="category-header-title">Investigadores</span>
                    <span class="category-total-badge" id="hub-header-profiles-v156"></span>
                </h2>
                <div class="category-scroll-wrapper" id="scroll-profiles"><div class="category-body" id="grid-profiles-content"></div></div>
                <div class="category-footer">
                    <a href="#" class="view-all-btn" id="btn-view-profiles">
                        Ver todos los investigadores &nbsp;<i class="fa fa-chevron-right"></i>
                    </a>
                </div>

            </section>

            <!-- ORGANIZACIONES -->
            <section id="category-organizations" class="dashboard-category" style="display:none;">
                <h2 class="category-header cat-orgs">
                    <span class="category-header-icon">&#x1F3DB;</span>
                    <span class="category-header-title">Unidades y Grupos de Investigaci&oacute;n</span>
                    <span class="category-total-badge" id="hub-header-organizations-v156"></span>
                </h2>
                <div class="category-scroll-wrapper" id="scroll-organizations"><div class="category-body" id="grid-organizations-content"></div></div>
                <div class="category-footer">
                    <a href="#" class="view-all-btn" id="btn-view-organizations">
                        Ver todos &nbsp;<i class="fa fa-chevron-right"></i>
                    </a>
                </div>
            </section>

            <!-- PROGRAMAS ACAD&Eacute;MICOS -->
            <section id="category-programs" class="dashboard-category" style="display:none;">
                <h2 class="category-header cat-programs">
                    <span class="category-header-icon">&#x1F393;</span>
                    <span class="category-header-title">Programas Acad&Eacute;micos</span>
                    <span class="category-total-badge" id="hub-header-programs-v156"></span>
                </h2>
                <div class="category-scroll-wrapper" id="scroll-programs"><div class="category-body" id="list-programs-content"></div></div>
                <div class="category-footer">
                    <a href="#" class="view-all-btn" id="btn-view-programs">
                        Ver todos &nbsp;<i class="fa fa-chevron-right"></i>
                    </a>
                </div>
            </section>

            <!-- PRODUCCI&Oacute;N ACAD&Eacute;MICA -->
            <section id="category-publications" class="dashboard-category" style="display:none;">
                <h2 class="category-header cat-pubs">
                    <span class="category-header-icon">&#x1F4D6;</span>
                    <span class="category-header-title">Producci&oacute;n Acad&Eacute;mica</span>
                    <span class="category-total-badge" id="hub-header-publications-v156"></span>
                </h2>
                <div class="category-body" id="list-publications-content"></div>
                <div class="category-footer">
                    <a href="#" class="view-all-btn" id="btn-view-publications">
                        Ver toda la producci&oacute;n &nbsp;<i class="fa fa-chevron-right"></i>
                    </a>
                </div>
            </section>

        </main>
    </div>

    <div style="display:none;"><@printPagingLinks /></div>
</div>
</#if>


<#macro printPagingLinks>

<#-- Paging controls -->
    <#if (pagingLinks?size > 0)>
        <div class="searchpages">
            ${i18n().pages}:
            <#if prevPage??><a class="prev" href="${prevPage?html}" title="${i18n().previous}">${i18n().previous}</a></#if>
            <#list pagingLinks as link>
                <#if link.url??>
                    <a href="${link.url?html}" title="${i18n().page_link}">${link.text?html}</a>
                <#else>
                    <span>${link.text?html}</span> <#-- no link if current page -->
                </#if>
            </#list>
            <#if nextPage??><a class="next" href="${nextPage?html}" title="${i18n().next_capitalized}">${i18n().next_capitalized}</a></#if>
        </div>
    </#if>
</#macro>

<#macro printResultNumbers>
	<h2 class="searchResultsHeader">
	<#escape x as x?html>
	    ${i18n().results_found(hitCount)} 
	</#escape>
	<script type="text/javascript">
		var url = window.location.toString();
		if (url.indexOf("?") == -1){
			var queryText = 'querytext=${querytext?js_string}';
		} else {
			var urlArray = url.split("?");
			var queryText = urlArray[1];
		}

		var urlsBase = '${urls.base}';
		

		$("input:radio").on("click",function (e) {
		    var input=$(this);
		    if (input.is(".selected-input")) { 
		        input.prop("checked",false);
		    } else {
		        input.prop("checked",true);
		    }
	        $('#search-form').submit();
		});
		
		$("input:checkbox").on("click",function (e) {
		    var input=$(this);
		    input.checked = !input.checked;
	        $('#search-form').submit();
		});
		
		function clearInput(elementId) {
	  		let inputEl = document.getElementById(elementId);
	  		inputEl.value = "";
	  		let srcButton = document.getElementById("button_" + elementId);
	  		srcButton.classList.add("unchecked-selected-search-input-label");
	  		$('#search-form').submit();
		}
		
		function createSliders(){
			sliders = document.getElementsByClassName('range-slider-container');
			for (let sliderElement of sliders) {
				createSlider(sliderElement);
			}
			$(".noUi-handle").on("mousedown", function (e) {
			    $(this)[0].setPointerCapture(e.pointerId);
			});
			$(".noUi-handle").on("mouseup", function (e) {
				$('#search-form').submit();
			});
			$(".noUi-handle").on("pointerup", function (e) {
				$('#search-form').submit();
			});
		};
			
		function createSlider(sliderContainer){
			rangeSlider = sliderContainer.querySelector('.range-slider');
			
			noUiSlider.create(rangeSlider, {
			    range: {
			        min: Number(sliderContainer.getAttribute('min')),
			        max: Number(sliderContainer.getAttribute('max'))
			    },
			
			    step: 1,
			    start: [Number(sliderContainer.querySelector('.range-slider-start').textContent), 
			  			Number(sliderContainer.querySelector('.range-slider-end').textContent)],
			
			    format: wNumb({
			        decimals: 0
			    })
			});
			
			var dateValues = [
			     sliderContainer.querySelector('.range-slider-start'),
			     sliderContainer.querySelector('.range-slider-end')
			];
			
			var input = sliderContainer.querySelector('.range-slider-input');
			var first = true;
			
			rangeSlider.noUiSlider.on('update', function (values, handle) {
			    dateValues[handle].innerHTML = values[handle];
			    var active = input.getAttribute('active');
			    if (active === null){
			    	input.setAttribute('active', "false");
			    } else if (active !== "true"){
			        input.setAttribute('active', "true");
			    } else {
			    	var startDate = new Date(+values[0],0,1);
			    	var endDate = new Date(+values[1],0,1);
			    	input.value = startDate.toISOString() + " " + endDate.toISOString();
			    }
			});
		}
		
		window.onload = (event) => {
	  		createSliders();
		};
		
		$('#search-form').submit(function () {
	    $('#search-form')
	        .find('input')
	        .filter(function () {
	            return !this.value;
	        })
	        .prop('name', '');
		});
		
		function expandSearchOptions(){
			$(event.target).parent().children('.additional-search-options').removeClass("hidden-search-option");
			$(event.target).parent().children('.less-facets-link').show();
			$(event.target).hide();
		}
	
		function collapseSearchOptions(){
			$(event.target).parent().children('.additional-search-options').addClass("hidden-search-option");
			$(event.target).parent().children('.more-facets-link').show();
			$(event.target).hide();
		}
	
	</script>
	<img id="downloadIcon" src="images/download-icon.png" alt="${i18n().download_results}" title="${i18n().download_results}" />
	<#-- <span id="downloadResults" style="float:left"></span>  -->
	</h2>
</#macro>

<#macro searchForm>
	<form id="search-form" name="search-form" autocomplete="off" method="get" action="${urls.base}/search">
		<div id="selected-filters">
			<@printSelectedFilterValueLabels filters />
		</div>  
		<div id="filter-groups">
			<ul class="nav nav-tabs">
				<#assign active = true>
				<#list filterGroups as group>
					<#if ( user.loggedIn || group.public ) && !group.hidden >
						<@searchFormGroupTab group active/>
						<#assign active = false>
					</#if>  
				</#list>
			</ul>
			<#assign active = true>
			<#list filterGroups as group>
				<#if ( user.loggedIn || group.public ) && !group.hidden >
			  		<@groupFilters group active/>
			  		<#assign active = false>
				</#if>
			</#list>
		</div>
		<div id="search-form-footer" style="display:none;">
			<div>
				<@printResultNumbers />
			</div>
			<div>
				<@printHits />
				<@printSorting />
			</div>
		</div> 
	</form>
</#macro>

<#macro groupFilters group active>
	<#if active >
		<div id="${group.id}" class="tab-pane fade in active filter-area">
	<#else>
		<div id="${group.id}" class="tab-pane fade filter-area">
	</#if>
			<div id="search-filter-group-container-${group.id}">
				<ul class="nav nav-tabs">
					<#assign assignedActive = false>
					<#list group.filters as filterId>
						<#if filters[filterId]??>
							<#assign f = filters[filterId]>
							<#if ( user.loggedIn || f.public ) && !f.hidden >
								<@searchFormFilterTab f assignedActive emptySearch/>  
								<#if !assignedActive && (f.selected || emptySearch )>
									<#assign assignedActive = true>
								</#if>
							</#if>
						</#if>
					</#list>
				</ul>
			</div>
			<div id="search-filter-group-tab-content-${group.id}" class="tab-content">
				<#assign assignedActive = false>
				<#list group.filters as filterId>
					<#if filters[filterId]??>
						<#assign f = filters[filterId]>
						<#if ( user.loggedIn || f.public ) && !f.hidden >
							<@printFilterValues f assignedActive emptySearch/>  
							<#if !assignedActive && ( f.selected || emptySearch )>
								<#assign assignedActive = true>
							</#if>
						</#if>
					</#if>
				</#list>
			</div>
		</div>
</#macro>

<#macro printSelectedFilterValueLabels filters>
	<#list filters?values as filter>
		<#assign valueNumber = 1>
		<#list filter.values?values as v>
			<#if v.selected>
				${getInput(filter, v, getValueID(filter.id, valueNumber), valueNumber)}
				<#if user.loggedIn || filter.public>
					${getSelectedLabel(valueNumber, v, filter)}
				</#if>
			</#if>
			<#assign valueNumber = valueNumber + 1>
		</#list>
		<@userSelectedInput filter />
	</#list>
</#macro>

<#macro printSorting>
	<#if sorting?has_content>
		<div>
			<select form="search-form" name="sort" id="search-form-sort" onchange="this.form.submit()" >
			    <#assign addDefaultOption = true>
				<#list sorting as option>
					<#if option.display>
						<#if option.selected>
							<option value="${option.id}" selected="selected">${i18n().search_results_sort_by(option.label)}</option>
							<#assign addDefaultOption = false>
						<#else>
							<option value="${option.id}" >${i18n().search_results_sort_by(option.label)}</option>
						</#if>
					</#if>
				</#list>
				<#if addDefaultOption>
					<option disabled selected value="" style="display:none">${i18n().search_results_sort_by('')}</option>
				</#if>
			</select>
		</div>
	</#if>
</#macro>

<#macro printHits>
	<div>
	<select form="search-form" name="hitsPerPage" id="search-form-hits-per-page" onchange="this.form.submit()">
		<#list hitsPerPageOptions as option>
			<#if option == hitsPerPage>
				<option value="${option}" selected="selected">${i18n().search_results_per_page(option)}</option>
			<#else>
				<option value="${option}">${i18n().search_results_per_page(option)}</option>
			</#if>
		</#list>
	</select>
	</div>
</#macro>

<#macro searchFormGroupTab group active >
	<#if active>
	 	<li class="active form-group-tab">
	<#else>
		<li class="form-group-tab">
	</#if>
			<a data-bs-toggle="tab" href="#${group.id?html}">${group.label?html}</a>
		</li>
</#macro>

<#macro searchFormFilterTab filter assignedActive isEmptySearch>
	<#if filter.id == "querytext">
		<#-- skip query text filter -->
		<#return>
	</#if>
		<li class="filter-tab">
			<a data-bs-toggle="tab" href="#${filter.id?html}">${filter.name?html}</a>
		</li>
</#macro>

<#macro printFilterValues filter assignedActive isEmptySearch>
		<div id="${filter.id?html}" class="tab-pane fade filter-area">
			<#if filter.id == "querytext">
			<#-- skip query text filter -->
			<#elseif filter.type == "RangeFilter">
				<@rangeFilter filter/>
			<#else>
				<#if filter.input>
					<div class="user-filter-search-input">
						<@createUserInput filter />
					</div>
				</#if>
	
				<#assign valueNumber = 1>
				<#assign additionalLabels = false>
				<#list filter.values?values as v>
					<#if !v.selected>
						<#if filter.moreLimit = valueNumber - 1 >
							<#assign additionalLabels = true>
							<a class="more-facets-link" href="javascript:void(0);" onclick="expandSearchOptions(this)">${i18n().paging_link_more}</a>
						</#if>
						<#if user.loggedIn || v.publiclyAvailable>
						    ${getInput(filter, v, getValueID(filter.id, valueNumber), valueNumber)}
						    ${getLabel(valueNumber, v, filter, additionalLabels)}
						</#if>
					</#if>
					<#assign valueNumber = valueNumber + 1>

				</#list>
				<#if additionalLabels >
					<a class="less-facets-link additional-search-options hidden-search-option" href="javascript:void(0);" onclick="collapseSearchOptions(this)">${i18n().display_less}</a>
				</#if>  
			</#if>
		</div>
</#macro>

<#macro rangeFilter filter>
	<#assign min = filter.min >
	<#assign max = filter.max >
	<#assign from = filter.fromYear >
	<#assign to = filter.toYear >

	<div class="range-filter" id="${filter.id?html}" class="tab-pane fade filter-area">
		<div class="range-slider-container" min="${filter.min?html}" max="${filter.max?html}">
			<div class="range-slider"></div>
			Desde
			<#if from?has_content>
				<div class="range-slider-start">${from?html}</div>
			<#else>
				<div class="range-slider-start">${min?html}</div>
			</#if>
			hasta
			<#if to?has_content>
				<div class="range-slider-end">${to?html}</div>
			<#else>
				<div class="range-slider-end">${max?html}</div>
			</#if>
			<input form="search-form" id="filter_range_${filter.id?html}" style="display:none;" class="range-slider-input" name="filter_range_${filter.id?html}" value="${filter.rangeInput?html}"/>
		</div>
	</div>
</#macro>


<#function getSelectedLabel valueID value filter >
	<#assign label = filter.name + " : " + value.name >
	<#if !filter.localizationRequired>
		<#assign label = filter.name + " : " + value.id >
	</#if>
	<#return "<label for=\"" + getValueID(filter.id, valueNumber)?html + "\">" + getValueLabel(label, value.count)?html + "</label>" />
</#function>

<#function getLabel valueID value filter additional=false >
	<#assign label = value.name >
	<#assign additionalClass = "" >
	<#if !filter.localizationRequired>
		<#assign label = value.id >
	</#if>
	<#if additional=true>
		<#assign additionalClass = "additional-search-options hidden-search-option" >
	</#if>
	<#return "<label class=\"" + additionalClass + "\" for=\"" + getValueID(filter.id, valueNumber)?html + "\">" + getValueLabel(label, value.count)?html + "</label>" />
</#function>


<#macro userSelectedInput filter>
	<#if filter.inputText?has_content>
		<button form="search-form" type="button" id="button_filter_input_${filter.id?html}" onclick="clearInput('filter_input_${filter.id?js_string?html}')" class="checked-search-input-label">${filter.name?html} : ${filter.inputText?html}</button>
	</#if>
	<#assign from = filter.fromYear >
	<#assign to = filter.toYear >
	<#if from?has_content && to?has_content >
		<#assign range = "desde " + from + " hasta " + to >
		<button form="search-form" type="button" id="button_filter_range_${filter.id?html}" onclick="clearInput('filter_range_${filter.id?js_string?html}')" class="checked-search-input-label">${filter.name?html} : ${range?html}</button>
	</#if>
</#macro>

<#macro createUserInput filter>
	<input form="search-form" id="filter_input_${filter.id?html}"  placeholder="${i18n().search_field_placeholder}" class="search-vivo" type="text" name="filter_input_${filter.id?html}" value="${filter.inputText?html}" autocapitalize="none" />
</#macro>

<#function getInput filter filterValue valueID valueNumber>
	<#assign checked = "" >
	<#assign class = "" >
	<#if filterValue.selected>
		<#assign checked = " checked=\"checked\" " >
		<#assign class = "selected-input" >
	</#if>
	<#assign type = "checkbox" >
	<#if !filter.multivalued>
		<#assign type = "radio" >
	</#if>
	<#assign filterName = filter.id >
	<#if filter.multivalued>
		<#assign filterName = filterName + "_" + valueNumber >
	</#if>

	<#return "<input form=\"search-form\" type=\"" + type + "\" id=\"" + valueID?html + "\"  value=\"" + filter.id?html + ":" + filterValue.id?html 
		+ "\" name=\"filters_" + valueID?html + "\" style=\"display:none;\" " + checked + "\" class=\"" + class + "\" >" />
</#function>

<#function getValueID id number>
	<#return id + "__" + number /> 
</#function>

<#function getValueLabel label count >
	<#assign result = label >
	<#if count!=0>
		<#assign result = result + " (" + count + ")" >
	</#if>
	<#return result />
</#function>
<!-- end contentsBrowseGroup -->

${stylesheets.add('<link rel="stylesheet" href="//code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />',
  				  '<link rel="stylesheet" href="${urls.base}/css/search.css" />',
                  '<link rel="stylesheet" type="text/css" href="${urls.base}/css/jquery_plugins/qtip/jquery.qtip.min.css" />')}

${headScripts.add('<script src="//code.jquery.com/ui/1.10.3/jquery-ui.js"></script>',
				  '<script type="text/javascript" src="${urls.base}/js/jquery_plugins/qtip/jquery.qtip.min.js"></script>',
                  '<script type="text/javascript" src="${urls.base}/js/tiny_mce/tiny_mce.js"></script>'
                  )}

${scripts.add('<script type="text/javascript" src="${urls.base}/js/searchDownload.js?v=58"></script>')}
${scripts.add('<script type="text/javascript" src="${urls.base}/js/dashboardSearch_hub_v19.js"></script>')}
${stylesheets.add('<link rel="stylesheet" href="${urls.theme}/css/resultados_busqueda.css" />')}
${stylesheets.add('<link rel="stylesheet" href="${urls.theme}/css/pure_dashboard_hub_v23.css" />')}
