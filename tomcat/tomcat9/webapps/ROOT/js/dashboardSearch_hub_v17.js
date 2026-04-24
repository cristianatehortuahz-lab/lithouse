/**
 * HUB VIVO - Dashboard Búsqueda v5 (Premium Edition)
 * Universidad del Rosario
 *
 * Mejoras v5:
 *  - Count-up animation en badges del sidebar
 *  - Cards con stagger animation (delay escalonado)
 *  - Org cards con flecha →
 *  - Skeleton más limpio
 *  - Builders mejorados
 */

/* ---------- HELPER: Count-Up ---------- */
function animateCount(el, target) {
  if (!el || isNaN(target)) return;
  const duration = Math.min(900, 300 + target * 0.5);
  const start    = performance.now();
  const from     = 0;
  function tick(now) {
    const progress = Math.min((now - start) / duration, 1);
    const eased    = 1 - Math.pow(1 - progress, 3); // ease-out cubic
    el.textContent = Math.round(from + (target - from) * eased).toLocaleString('es-CO');
    if (progress < 1) requestAnimationFrame(tick);
    else el.textContent = target.toLocaleString('es-CO');
  }
  requestAnimationFrame(tick);
}

document.addEventListener("DOMContentLoaded", function () {

    const layout = document.getElementById("dashboard-search-layout");
    if (!layout) return;

    const urlParams = new URLSearchParams(window.location.search);
    if (Array.from(urlParams.keys()).length === 0) {
        const loader = document.getElementById("dashboard-global-loader");
        if (loader) loader.innerHTML = "<p>Realice una b\\u00FAsqueda para ver resultados.</p>";
        return;
    }

    const loader = document.getElementById("dashboard-global-loader");
    if (loader) loader.style.display = "none";

    // Limpiar params de VIVO que rompen las siguientes consultas
    urlParams.delete('classgroup');
    if (urlParams.get('filters_category') === '') urlParams.delete('filters_category');
    
    const queryText = urlParams.get('querytext') || '';
    
    // DETERMINAR BASE URL DE FORMA SEGURA (Evita ReferenceError: urls is not defined)
    let baseUrl = '';
    if (typeof urls !== 'undefined' && urls.base) {
        baseUrl = urls.base;
    } else {
        // Fallback: detectar desde la URL actual (asumiendo que estamos en /search)
        const pathParts = window.location.pathname.split('/search');
        baseUrl = pathParts[0] || '';
    }
    
    const SEARCH = (baseUrl.endsWith('/') ? baseUrl.slice(0,-1) : baseUrl) + '/search';
    
    // Generar la querystring base limpia y forzar locale es_ES para snippets estables
    const rawSearch = window.location.search.substring(1) || '';
    const baseQ = (rawSearch ? (rawSearch + '&') : '') + 'locale=es_ES';

    // ------------------------------------------------------------------
    // SKELETON LOADER — muestra filas de cardPlaceholder mientras carga
    // ------------------------------------------------------------------
    function showSkeleton(sectionId, count, type) {
        const section = document.getElementById(sectionId);
        if (!section) return;
        section.style.display = 'block';

        const parent = section.querySelector('[id^="grid-"],[id^="list-"]');
        if (!parent) return;

        let html = '';
        if (type === 'grid') {
            // Skeleton tipo card persona
            for (let i = 0; i < count; i++) {
                html += `<div style="padding:14px 16px; background:#fff; display:flex; gap:12px; align-items:flex-start;">
                    <div class="hub-skeleton hub-skeleton-avatar" style="width:52px;height:52px;border-radius:50%;flex-shrink:0;"></div>
                    <div style="flex:1;">
                        <div class="hub-skeleton hub-skeleton-line w-80" style="height:11px;border-radius:4px;margin-bottom:6px;background:linear-gradient(90deg,#f0f0f0 25%,#e0e0e0 50%,#f0f0f0 75%);background-size:800px 100%;animation:hub-shimmer 1.4s infinite;"></div>
                        <div class="hub-skeleton hub-skeleton-line w-60" style="height:11px;border-radius:4px;margin-bottom:6px;background:linear-gradient(90deg,#f0f0f0 25%,#e0e0e0 50%,#f0f0f0 75%);background-size:800px 100%;animation:hub-shimmer 1.4s infinite;"></div>
                    </div>
                </div>`;
            }
        } else {
            // Skeleton tipo fila de publicación
            for (let i = 0; i < count; i++) {
                html += `<div style="padding:12px 18px; border-bottom:1px solid #f4f4f4;">
                    <div style="height:10px;width:60px;border-radius:10px;margin-bottom:8px;background:linear-gradient(90deg,#f0f0f0 25%,#e0e0e0 50%,#f0f0f0 75%);background-size:800px 100%;animation:hub-shimmer 1.4s infinite;"></div>
                    <div style="height:12px;width:85%;border-radius:4px;margin-bottom:7px;background:linear-gradient(90deg,#f0f0f0 25%,#e0e0e0 50%,#f0f0f0 75%);background-size:800px 100%;animation:hub-shimmer 1.4s infinite;"></div>
                    <div style="height:10px;width:70%;border-radius:4px;background:linear-gradient(90deg,#f0f0f0 25%,#e0e0e0 50%,#f0f0f0 75%);background-size:800px 100%;animation:hub-shimmer 1.4s infinite;"></div>
                </div>`;
            }
        }
        parent.innerHTML = html;
    }

    function clearSkeleton(sectionId) {
        const section = document.getElementById(sectionId);
        if (!section) return;
        const parent = section.querySelector('[id^="grid-"],[id^="list-"]');
        if (parent) parent.innerHTML = '';
    }

    // ------------------------------------------------------------------
    // DETECCIÓN DE TIPO — inspecciona DOM del item
    // ------------------------------------------------------------------
    function detectType(li) {
        // --- 1. Detección por Atributo Explícito (data-vclass) ---
        // Esto viene de las plantillas FTL modificadas (view-search-organization.ftl, etc)
        const vclassContainer = li.querySelector('[data-vclass]');
        if (vclassContainer) {
            const vclass = (vclassContainer.getAttribute('data-vclass') || '').toLowerCase();
            // Soporta URIs (person, organization, group) y etiquetas en español (persona, unidad, facultad)
            if (vclass.includes('person')) return 'person';
            if (vclass.includes('organization') || vclass.includes('group') || vclass.includes('laboratory') || 
                vclass.includes('center') || vclass.includes('department') || vclass.includes('unidad') || 
                vclass.includes('escuela') || vclass.includes('facultad') || vclass.includes('instituto') ||
                vclass.includes('investigaci')) return 'org';
            if (vclass.includes('program') || vclass.includes('degree') || vclass.includes('course') || vclass.includes('programa')) return 'program';
        }

        // --- 2. Fallback: Detecci\u00F3n por Selectores de Clase/Estructura ---
        if (li.querySelector('.shortview_person-img, .shortview_person-data, .hub-sv-person-card, .person-img')) return 'person';
        if (li.querySelector('img[src*="organization"], .org-img, .hub-org-card, #organizationIndividual')) return 'org';
        if (li.querySelector('.hub-program-card, #programIndividual, .hub-program-name')) return 'program';
        
        // --- 3. Detecci\u00F3n por contenido (Trabajos de Grado -> Programas?) ---
        const text = li.textContent || '';
        if (text.includes('Trabajo de Grado') || text.includes('Degree Work')) return 'program';
        
        return 'publication';
    }

    // ------------------------------------------------------------------
    // BUILDERS — construyen HTML de cada card/fila
    // ------------------------------------------------------------------

    /** Extrae el snippet de texto de una publicacion */
    function getSnippet(li) {
        const snip = li.querySelector('.snippet, p.snippet');
        return snip ? snip.textContent.trim() : '';
    }

    /** Extrae el año del snippet o de texto libre */
    function extractYear(li) {
        const text = li.textContent || '';
        const m = text.match(/\b(19|20)\d{2}\b/);
        return m ? m[0] : null;
    }

    function buildPersonCard(li) {
        let name = '', href = '', imgSrc = '', roleTxt = '', deptTxt = '', snippet = '';
        
        // Intentar extraer de vclassContainer (data-vclass)
        const vclassContainer = li.querySelector('[data-vclass]');
        if (vclassContainer) {
            const a = vclassContainer.querySelector('a[href]');
            if (a) {
                name = a.textContent.trim();
                href = a.getAttribute('href');
                const img = vclassContainer.querySelector('img');
                imgSrc = img ? img.getAttribute('src') : '';
                const role = vclassContainer.querySelector('.hub-sv-role');
                roleTxt = role ? role.textContent.trim() : '';
                const dept = vclassContainer.querySelector('.hub-sv-dept-tag, .hub-sv-dept');
                deptTxt = dept ? dept.textContent.trim() : '';
                const snip = vclassContainer.querySelector('.hub-sv-snippet, .snippet');
                snippet = snip ? snip.textContent.trim() : '';
            }
        }

        // Fallback robusto if needed
        if (!href || !name) {
            const a = li.querySelector('h3 a, a[href]');
            if (!a) return null;
            name    = a.textContent.trim();
            href    = a.getAttribute('href');
            imgSrc  = li.querySelector('img.card-img-top, img[width="90"], .shortview_person-img img, .hub-sv-photo')?.getAttribute('src');
            roleTxt = li.querySelector('.hub-sv-role, .card-footer, span.title, span.card-text')?.textContent.trim().slice(0, 70);
            deptTxt = li.querySelector('.hub-sv-dept-tag, .hub-sv-dept, .card-text a')?.textContent.trim().slice(0, 50);
            snippet = li.querySelector('.hub-sv-snippet, .snippet')?.textContent.trim();
        }

        if (!href || !name) return null;

        // --- v2.0: LIMPIEZA DE REDUNDANCIA ---
        // Eliminar cargo, departamento y flecha del nombre para evitar repetición
        let cleanName = name;
        if (roleTxt && cleanName.includes(roleTxt)) cleanName = cleanName.replace(roleTxt, '');
        if (deptTxt && cleanName.includes(deptTxt)) cleanName = cleanName.replace(deptTxt, '');
        cleanName = cleanName.replace(/>\s*$/, '').trim(); // Elimina '>' al final si existe

        return `<a href="${href}" class="hub-person-card">
            <div class="hub-sv-card-main">
                <div class="hub-sv-photo-wrap">
                    <img class="hub-sv-photo"
                         src="${imgSrc || '/images/placeholders/person.thumbnail.jpg'}"
                         alt="${cleanName}"
                         loading="lazy"
                         onerror="this.src='/images/placeholders/person.thumbnail.jpg'; this.onerror=null;">
                </div>
                <div class="hub-sv-info">
                    <div class="hub-sv-header">
                        <span class="hub-sv-name">${cleanName}</span>
                    </div>
                    <span class="hub-sv-role">${roleTxt || 'Investigador Universidad del Rosario'}</span>
                    ${deptTxt ? `<span class="hub-sv-dept-tag">${deptTxt}</span>` : ''}
                </div>
                <!-- Flecha lateral v16.0 (Sync) -->
                <div class="hub-sv-card-action">
                    <span class="hub-sv-arrow-new">&#8250;</span>
                </div>
            </div>
        </a>`;
    }

    function buildOrgCard(li) {
        const a = li.querySelector('h3 a, h3.thumb a, a.hub-org-card, .individual a[href], a[href]');
        if (!a) return null;
        const name = a.textContent.trim() || 'Organizaci\u00F3n';
        const href = a.getAttribute('href');
        const desc = li.querySelector('span.title, .snippet, .hub-sv-snippet');
        const descTxt = desc ? desc.textContent.trim().slice(0, 160) : '';

        // v15.0: Unified card structure with icon
        return `<a href="${href}" class="hub-org-card">
            <div class="hub-sv-card-main">
                <div class="hub-sv-photo-wrap">
                    <div class="hub-org-logo-placeholder">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M3 21h18M3 7v14m18-14v14M3 7l9-4 9 4M9 21v-4a2 2 0 0 1 4 0v4M7 8h2m4 0h2m-8 4h2m4 0h2" />
                        </svg>
                    </div>
                </div>
                <div class="hub-org-info">
                    <span class="hub-org-name">${name}</span>
                    <span class="hub-org-desc">${descTxt || 'Organizaci\u00F3n o Grupo de Investigaci\u00F3n de la Universidad del Rosario.'}</span>
                </div>
                <!-- Flecha lateral v16.0 (Sync) -->
                <div class="hub-sv-card-action">
                    <span class="hub-sv-arrow-new">&#8250;</span>
                </div>
            </div>
        </a>`;
    }

    function buildProgramCard(li) {
        const a = li.querySelector('h3 a, a.hub-program-card, a[href]');
        if (!a) return null;
        const name = a.textContent.trim() || 'Programa Acad\u00E9mico';
        const href = a.getAttribute('href');
        const mod  = li.querySelector('.hub-program-desc, #programDescription, span.title, .snippet');
        const detail = mod ? mod.textContent.trim().slice(0, 100) : '';

        return `<a href="${href}" class="hub-program-card">
            <div class="hub-program-info" style="flex:1; overflow:hidden;">
                <span class="hub-program-name">${name}</span>
                <span class="hub-program-desc" style="font-size:11px; color:var(--hub-gray-500); line-height:1.55; display:-webkit-box; -webkit-line-clamp:2; line-clamp:2; -webkit-box-orient:vertical; overflow:hidden; margin-top:2px;">${detail || 'Programa acad\u00E9mico ofrecido por la Universidad del Rosario. Pulse aqu\u00ED para consultar en detalle el curr\u00EDculo, profesores y objetivos.'}${detail.length >= 100 ? '\u2026' : ''}</span>
            </div>
        </a>`;
    }

    function buildPublicationRow(li) {
        const a = li.querySelector('a[href]');
        if (!a) return null;
        const name = a.textContent.trim();
        const href = a.getAttribute('href');
        const snippet = getSnippet(li);

        // Intentar extraer tipo de publicación (texto suelto con |)
        let typeText = '';
        li.childNodes.forEach(n => {
            if (n.nodeType === 3) {
                const t = n.textContent.replace(/\|/g, '').trim();
                if (t && t.length > 2 && t.length < 60) typeText = t;
            }
        });

        return `<div class="hub-pub-row">
            <div class="hub-pub-meta">
                ${typeText ? `<span class="hub-pub-type">${typeText}</span>` : ''}
            </div>
            <a href="${href}" class="hub-pub-title">${name}</a>
            ${snippet ? `<p class="hub-pub-snippet">${snippet.slice(0,180)}${snippet.length > 180 ? '\u2026' : ''}</p>` : ''}
        </div>`;
    }

    function buildProjectRow(li) {
        const a = li.querySelector('a[href]');
        if (!a) return null;
        const name = a.textContent.trim();
        const href = a.getAttribute('href');
        const snippet = getSnippet(li);

        return `<div class="hub-pub-row">
            <a href="${href}" class="hub-pub-title">${name}</a>
            ${snippet ? `<p class="hub-pub-snippet">${snippet.slice(0,180)}${snippet.length > 180 ? '\u2026' : ''}</p>` : ''}
        </div>`;
    }

    function buildEventRow(li) {
        const a = li.querySelector('a[href]');
        if (!a) return null;
        const name = a.textContent.trim();
        const href = a.getAttribute('href');
        const snippet = getSnippet(li);

        return `<div class="hub-pub-row">
            <a href="${href}" class="hub-pub-title">${name}</a>
            ${snippet ? `<p class="hub-pub-snippet">${snippet.slice(0,180)}${snippet.length > 180 ? '\\u2026' : ''}</p>` : ''}
        </div>`;
    }

    // ------------------------------------------------------------------
    // DEDUPLICACIÓN GLOBAL
    // ------------------------------------------------------------------
    const seenUrls = new Set();

    // ------------------------------------------------------------------
    // CONFIGURACIÓN DE CATEGORÍAS
    // ------------------------------------------------------------------
    const CATEGORIES = {
        profiles: {
            url:         `${SEARCH}?${baseQ}&filters_category=category:http://vivoweb.org/ontology%23vitroClassGrouppeople`,
            prefix:      'profiles',
            sectionId:   'category-profiles',
            contentId:   'grid-profiles-content',
            skeletonType:'grid',
            limit:       4,  // v16.2 Sync: 2x2 grid
            typeFilter:  li => detectType(li) === 'person',
            typeParam:   'Person',
            builder:     buildPersonCard
        },
        organizations: {
            url:         `${SEARCH}?${baseQ}&filters_category=category:http://vivoweb.org/ontology%23vitroClassGrouporganizations`,
            prefix:      'organizations',
            sectionId:   'category-organizations',
            contentId:   'grid-organizations-content',
            skeletonType:'grid',
            limit:       4,  // v16.2 Sync: 2x2 grid
            typeFilter:  li => detectType(li) === 'org',
            typeParam:   'Organization',
            builder:     buildOrgCard
        },
        programs: {
            url:         `${SEARCH}?${baseQ}&filters_category=category:http://vivoweb.org/ontology%23vitroClassGrouporganizations`,
            prefix:      'programs',
            sectionId:   'category-programs',
            contentId:   'list-programs-content',
            skeletonType:'list',
            limit:       6,
            // LÓGICA INVERSA: todo lo que NO es 'org' dentro del classgroup organizations = programa
            typeFilter:  li => detectType(li) !== 'org',
            typeParam:   'Program',
            builder:     buildProgramCard
        },
        publications: {
            url:         `${SEARCH}?${baseQ}&filters_category=category:http://vivoweb.org/ontology%23vitroClassGrouppublications`,
            prefix:      'publications',
            sectionId:   'category-publications',
            contentId:   'list-publications-content',
            skeletonType:'list',
            limit:       6,
            typeFilter:  li => !['person','org','program'].includes(detectType(li)),
            builder:     buildPublicationRow
        },
    };

    // ------------------------------------------------------------------
    // LOADER POR CATEGORÍA
    // ------------------------------------------------------------------
    async function loadCategory(key) {
        const cfg    = CATEGORIES[key];
        const badge  = document.getElementById(`hub-sidebar-${cfg.prefix}-v156`);
        const total  = document.getElementById(`hub-header-${cfg.prefix}-v156`);
        const section= document.getElementById(cfg.sectionId);
        const container= document.getElementById(cfg.contentId);
        const btn    = document.getElementById(`btn-view-${cfg.prefix}`); // This button is now deprecated

        // Lanzar skeleton
        showSkeleton(cfg.sectionId, cfg.skeletonType === 'grid' ? cfg.limit : 4, cfg.skeletonType);

        try {
            const cacheKey = 'hub_v7_' + btoa(unescape(encodeURIComponent(cfg.url)));
            let html = sessionStorage.getItem(cacheKey);

            if (!html) {
                const res  = await fetch(cfg.url);
                html = await res.text();
                try { sessionStorage.setItem(cacheKey, html); } catch(e) {} // Ignorar limite cuota
            }

            const vDoc = new DOMParser().parseFromString(html, 'text/html');

            // Contar total desde el header
            const h2 = vDoc.querySelector('h2.searchResultsHeader');
            let totalCount = 0;
            if (h2) {
                let txt = '';
                h2.childNodes.forEach(n => { if (n.nodeType === 3) txt += n.textContent; });
                const m = txt.match(/(\d+)/);
                totalCount = m ? parseInt(m[1], 10) : 0;
            }

            // v15.2: Badge update moved after filtering to ensure consistency

            // Limpiar skeleton
            clearSkeleton(cfg.sectionId);

            // Filtrar items únicos y guardar en estado para evitar re-análisis
            const isExpanded = window.HUB_DASHBOARD.state[key] && window.HUB_DASHBOARD.state[key].expanded;
            
            let relevant = this.state[key].data;
            if (!relevant) {
                const searchList = vDoc.querySelector('ul.searchhits');
                if (!searchList) { section.style.display = 'none'; return; }
                
                const items = Array.from(searchList.querySelectorAll(':scope > li'));
                relevant = items
                    .filter(li => cfg.typeFilter(li))
                    .filter(li => {
                        const a = li.querySelector('a[href]');
                        if (!a) return false;
                        const href = a.getAttribute('href');
                        if (seenUrls.has(href)) return false;
                        seenUrls.add(href);
                        return true;
                    });
                this.state[key].data = relevant;
            }

            const limit = cfg.limit || 6;
            const shownItems = isExpanded ? relevant : relevant.slice(0, limit);

            if (shownItems.length === 0) {
                section.style.display = 'none';
                return;
            }

            container.innerHTML = shownItems
                .map(li => cfg.builder(li))
                .filter(html => html !== null)
                .join('');

            // v15.6: Nuclear Delayed Update to win against VIVO native scripts
            const finalCount = relevant.length;
            console.log(`[HUB v15.6] Category: ${key}, Final Count: ${finalCount}`);

            setTimeout(() => {
                if (badge) {
                    badge.classList.remove('loading');
                    const sidebarLi = badge.closest('li');
                    if (sidebarLi) sidebarLi.style.display = (finalCount > 0 ? 'flex' : 'none');
                    animateCount(badge, finalCount);
                }

                if (total) {
                    total.textContent = finalCount.toLocaleString('es-CO');
                    total.style.display = (finalCount > 0 ? 'inline-block' : 'none');
                    console.log(`[HUB v15.6] FORCED Update hub-header-${cfg.prefix}-v156 with ${finalCount}`);
                }
            }, 500);
            
            // Aplicar restricción de altura directamente (v15.0) para bypass caché FTL
            if (isExpanded && relevant.length > limit) {
                container.style.maxHeight = '720px';
                container.style.overflowY = 'auto';
                container.style.overflowX = 'hidden';
                container.style.paddingRight = '12px';
                container.classList.add('expanded-scrollable');
            } else {
                container.style.maxHeight = '';
                container.style.overflowY = '';
                container.style.overflowX = '';
                container.style.paddingRight = '';
                container.classList.remove('expanded-scrollable');
            }
            
            // Renderizar footer seg\u00FAm estado
            const footer = section.querySelector('.category-footer');
            if (footer) {
                if (relevant.length > limit) {
                    footer.innerHTML = `
                        <button class="view-all-btn" onclick="HUB_DASHBOARD.toggleExpand('${key}')">
                            ${isExpanded ? `CONTRAER RESULTADOS` : `VER LOS ${relevant.length} RESULTADOS`}
                        </button>`;
                    footer.style.display = 'flex';
                } else {
                    footer.style.display = 'none';
                }
            }

            section.style.display = 'block';

            // Actualizar total en el header de sección
            if (total) total.textContent = totalCount.toLocaleString('es-CO');

            // The old "view all" button logic is removed as it's replaced by the expand/collapse button
            if (btn) btn.style.display = 'none';


        } catch (e) {
            console.warn(`[HUB Dashboard v4] Error cargando "${key}":`, e);
            clearSkeleton(cfg.sectionId);
            if (section) section.style.display = 'none';
            if (badge) { badge.textContent = '!'; badge.classList.remove('loading'); }
        }
    }

    // ------------------------------------------------------------------
    // SIDEBAR: click → scroll suave + highlight
    // ------------------------------------------------------------------
    document.querySelectorAll('#content-type-menu li[data-target]').forEach(li => {
        li.addEventListener('click', () => {
            const targetId = li.getAttribute('data-target');
            const target   = document.getElementById(targetId);
            if (target && target.style.display !== 'none') {
                target.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
            document.querySelectorAll('#content-type-menu li').forEach(l => l.classList.remove('active-filter'));
            li.classList.add('active-filter');
        });
    });

    // SIDEBAR: scrollspy con IntersectionObserver
    const sectionIds = Object.values(CATEGORIES).map(c => c.sectionId);
    let isExpanding = false; // Flag para evitar saltos del scrollspy
    const observer = new IntersectionObserver(entries => {
        if (isExpanding) return;
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const sId = entry.target.id;
                document.querySelectorAll('#content-type-menu li').forEach(l => {
                    const matches = l.getAttribute('data-target') === sId;
                    l.classList.toggle('active-filter', matches);
                });
            }
        });
    }, { threshold: 0.4 });

    sectionIds.forEach(id => {
        const el = document.getElementById(id);
        if (el) observer.observe(el);
    });

    // ------------------------------------------------------------------
    // EJECUCIÓN EN SERIE (people → orgs → programs → pubs → projects → events)
    // ------------------------------------------------------------------
    
    // Global state and methods for expansion
    window.HUB_DASHBOARD = {
        state: {}, // Global state for expansions
        categories: CATEGORIES, // Make categories accessible if needed
        loadCategory: loadCategory, // Expose loadCategory
        toggleExpand: function(key) {
            this.state[key] = this.state[key] || {};
            this.state[key].expanded = !this.state[key].expanded;
            
            // Bloquear scrollspy temporalmente
            isExpanding = true;
            this.loadCategory(key);
            
            // Scroll suave si se expande
            if (this.state[key].expanded) {
                setTimeout(() => {
                    document.querySelector(`#category-${key}`).scrollIntoView({ behavior: 'smooth', block: 'start' });
                    // Liberar después de la animación
                    setTimeout(() => { isExpanding = false; }, 800);
                }, 100);
            } else {
                isExpanding = false;
            }
        },
        init: async function() {
            const ORDER = ['profiles', 'organizations', 'programs', 'publications'];
            // Inicializar estado para cada categoría
            ORDER.forEach(k => { this.state[k] = { expanded: false, data: null }; });
            
            try {
                for (const k of ORDER) {
                    await this.loadCategory(k);
                }
                console.log('[HUB Dashboard v15.7] ✓ Dashboard simplificado (Sin Proyectos/Eventos).');
            } catch (e) {
                console.error('[HUB Dashboard v15.0] Error en inicializaci\u00F3n:', e);
            }
        }
    };

    // Initialize the dashboard
    window.HUB_DASHBOARD.init();
});
