/**
 * HUB VIVO - Dashboard BÃºsqueda v5 (Premium Edition)
 * Universidad del Rosario
 *
 * Mejoras v5:
 *  - Count-up animation en badges del sidebar
 *  - Cards con stagger animation (delay escalonado)
 *  - Org cards con flecha â†’
 *  - Skeleton mÃ¡s limpio
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

    // Limpiar params de VIVO que rompen las siguientes consultas
    urlParams.delete('classgroup');
    urlParams.delete('filters_category'); // Importante: Eliminar TODO para evitar anular nuestra solicitud de categoria
    urlParams.delete('startIndex');       // Iniciar desde cero para todas las categorias
    urlParams.set('hitsPerPage', '100');  // Solicitar suficientes resultados
    urlParams.set('locale', 'es_ES');     // Para snippets de texto estables
    
    const baseQ = urlParams.toString();

    // ------------------------------------------------------------------
    // SKELETON LOADER PREMIUM (v17.0) â€” estructura fiel a las tarjetas
    // ------------------------------------------------------------------
    function showSkeleton(sectionId, count, type) {
        const section = document.getElementById(sectionId);
        if (!section) return;
        section.style.display = 'block';

        const parent = section.querySelector('[id^="grid-"],[id^="list-"]');
        if (!parent) return;

        let html = '';
        for (let i = 0; i < count; i++) {
            const delay = `animation-delay: ${i * 0.12}s;`;
            if (type === 'grid') {
                // Skeleton que replica: avatar circular + nombre + cargo + escuela + flecha
                html += `<div class="hub-skeleton-card" style="${delay}" role="status" aria-label="Cargando resultado">
                    <div class="hub-skeleton-avatar"></div>
                    <div class="hub-skeleton-text">
                        <div class="hub-skeleton-line hub-skel-w80"></div>
                        <div class="hub-skeleton-line hub-skel-w60"></div>
                        <div class="hub-skeleton-line hub-skel-w45"></div>
                    </div>
                    <div class="hub-skeleton-arrow"></div>
                </div>`;
            } else {
                // Skeleton para filas de publicaciÃ³n/programa
                html += `<div class="hub-skeleton-row" style="${delay}" role="status" aria-label="Cargando resultado">
                    <div class="hub-skeleton-line hub-skel-badge"></div>
                    <div class="hub-skeleton-line hub-skel-w85"></div>
                    <div class="hub-skeleton-line hub-skel-w70"></div>
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
    // DETECCIÃ“N DE TIPO â€” inspecciona DOM del item
    // ------------------------------------------------------------------
    function detectType(li) {
        // --- 1. DetecciÃ³n por Atributo ExplÃ­cito (data-vclass) ---
        // Esto viene de las plantillas FTL modificadas (view-search-organization.ftl, etc)
        const vclassContainer = li.querySelector('[data-vclass]');
        if (vclassContainer) {
            const vclass = (vclassContainer.getAttribute('data-vclass') || '').toLowerCase();
            // Soporta URIs (person, organization, group) y etiquetas en espaÃ±ol (persona, unidad, facultad)
            if (vclass.includes('person')) return 'person';
            if (vclass.includes('organization') || vclass.includes('group') || vclass.includes('laboratory') || 
                vclass.includes('center') || vclass.includes('department') || vclass.includes('unidad') || 
                vclass.includes('escuela') || vclass.includes('facultad') || vclass.includes('instituto') ||
                vclass.includes('investigaci')) return 'org';
            if (vclass.includes('program') || vclass.includes('degree') || vclass.includes('course') || vclass.includes('programa')) return 'program';
        }

        // --- 2. Fallback: Detecci\u00F3n por Selectores de Clase/Estructura ---
        if (li.querySelector('.shortview_person-img, .shortview_person-data, .hub-sv-person-card, .hub-person-card, .person-img')) return 'person';
        if (li.querySelector('img[src*="organization"], .org-img, .hub-org-card, #organizationIndividual')) return 'org';
        if (li.querySelector('.hub-program-card, #programIndividual, .hub-program-name')) return 'program';
        
        // --- 3. Detecci\u00F3n por contenido (Trabajos de Grado -> Programas?) ---
        const text = li.textContent || '';
        if (text.includes('Trabajo de Grado') || text.includes('Degree Work')) return 'program';
        
        return 'publication';
    }

    // ------------------------------------------------------------------
    // BUILDERS â€” construyen HTML de cada card/fila
    // ------------------------------------------------------------------

    /** D1: Utilidad para sanitizar caracteres rotos de VIVO/Solr (ej: matem_atica -> matemática) */
    function sanitizeVIVOText(str) {
        if (!str) return '';
        return str
            .replace(/_a/g, 'á').replace(/_A/g, 'Á')
            .replace(/_e/g, 'é').replace(/_E/g, 'É')
            .replace(/_i/g, 'í').replace(/_I/g, 'Í')
            .replace(/_o/g, 'ó').replace(/_O/g, 'Ó')
            .replace(/_u/g, 'ú').replace(/_U/g, 'Ú')
            .replace(/_n/g, 'ñ').replace(/_N/g, 'Ñ');
    }
    
    /** N1: Normalizar texto quitando acentos y diacríticos */
    function normalizeText(text) {
        if (!text) return '';
        return text.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase();
    }
    
    /** H1: Highlighting utility for search results (v20.6) */
    function highlightQuery(text, query) {
        if (!text || !query || query.length < 2) return text || '';
        
        // Crear versión normalizada para búsqueda de índices
        const normText = normalizeText(text);
        const normQuery = normalizeText(query);
        
        let result = '';
        let lastIdx = 0;
        let idx = normText.indexOf(normQuery);
        
        while (idx !== -1) {
            result += text.slice(lastIdx, idx);
            const match = text.slice(idx, idx + query.length);
            result += `<mark class="hub-hl">${match}</mark>`;
            lastIdx = idx + query.length;
            idx = normText.indexOf(normQuery, lastIdx);
        }
        result += text.slice(lastIdx);
        return result || text;
    }

    /** Extrae el snippet de texto de una publicacion */
    function getSnippet(li) {
        const snip = li.querySelector('.snippet, p.snippet');
        return snip ? sanitizeVIVOText(snip.textContent.trim()) : '';
    }

    /** Extrae el aÃ±o del snippet o de texto libre */
    function extractYear(li) {
        const text = li.textContent || '';
        const m = text.match(/\b(19|20)\d{2}\b/);
        return m ? m[0] : null;
    }

    function buildPersonCard(li) {
        // --- v20.3: Detección centrada en clases Premium definitivas ---
        const existingCard = li.querySelector('.hub-person-card, .hub-sv-info, .hub-sv-card-main');
        if (existingCard) return li.innerHTML;

        let name = '', href = '', imgSrc = '', roleTxt = '', deptTxt = '', snippet = '';
        
        // Intentar extraer de vclassContainer (data-vclass)
        const vclassContainer = li.querySelector('[data-vclass]');
        if (vclassContainer) {
            // Caso 1: El contenedor ya es el tag <a> (Premium FTL)
            if (vclassContainer.tagName === 'A') {
                name = (vclassContainer.querySelector('.hub-sv-name') || vclassContainer).textContent.trim();
                href = vclassContainer.getAttribute('href');
                const img = vclassContainer.querySelector('img');
                imgSrc = img ? img.getAttribute('src') : '';
                roleTxt = vclassContainer.querySelector('.hub-sv-role')?.textContent.trim() || '';
                deptTxt = vclassContainer.querySelector('.hub-sv-dept-tag, .hub-sv-dept')?.textContent.trim() || '';
                snippet = vclassContainer.querySelector('.hub-sv-snippet, .snippet')?.textContent.trim() || '';
            } else {
                // Caso 2: El contenedor envuelve al tag <a> (Default VIVO FTL)
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
        }

        // Fallback robusto if needed
        if (!href || !name) {
            // Buscar anchor con texto real (nombre), NO el que envuelve la imagen
            const a = li.querySelector('.shortview_person-name a, h1 a, h3 a')
                   || Array.from(li.querySelectorAll('a[href]')).find(el => el.textContent.trim().length > 0 && !el.querySelector('img'));
            if (!a) return null;
            name    = a.textContent.trim();
            href    = a.getAttribute('href');
            imgSrc  = li.querySelector('.shortview_person-img img, img.card-img-top, img[width="90"], .hub-sv-photo')?.getAttribute('src') || '';
            // Para rol, buscar spans con clase 'title' que NO sean links (evitar capturar departamento)
            const titleSpans = li.querySelectorAll('.person-body span.title, span.title');
            roleTxt = '';
            deptTxt = '';
            titleSpans.forEach(span => {
                const txt = span.textContent.trim();
                const isLink = span.querySelector('a');
                if (isLink && !deptTxt) {
                    deptTxt = txt.slice(0, 50);
                } else if (!isLink && !roleTxt) {
                    roleTxt = txt.slice(0, 70);
                }
            });
            if (!roleTxt) roleTxt = li.querySelector('.hub-sv-role, .card-footer')?.textContent.trim().slice(0, 70) || '';
            if (!deptTxt) deptTxt = li.querySelector('.hub-sv-dept-tag, .hub-sv-dept, .card-text a')?.textContent.trim().slice(0, 50) || '';
            snippet = li.querySelector('.hub-sv-snippet, .snippet')?.textContent.trim() || '';
        }

        if (!href || !name) {
            // FALLBACK FINAL: No perder el resultado si ya sabemos que es una persona
            console.warn("[HUB Dashboard] Fallback final activado para investigador:", li.textContent.trim().slice(0, 30));
            return li.innerHTML; 
        }

        // --- v2.0: LIMPIEZA DE REDUNDANCIA ---
        let cleanName = sanitizeVIVOText(name);
        roleTxt = sanitizeVIVOText(roleTxt);
        deptTxt = sanitizeVIVOText(deptTxt);

        if (roleTxt && cleanName.includes(roleTxt)) cleanName = cleanName.replace(roleTxt, '');
        if (deptTxt && cleanName.includes(deptTxt)) cleanName = cleanName.replace(deptTxt, '');
        cleanName = cleanName.replace(/>\s*$/, '').trim();

        // --- v20.5: Highlighting ---
        const hlName = highlightQuery(cleanName, queryText);
        const hlRole = highlightQuery(roleTxt, queryText);
        const hlDept = highlightQuery(deptTxt, queryText);
        const hlSnip = highlightQuery(snippet, queryText);

        // D2: Avatar dinámico con iniciales
        let initials = '?';
        const parts = cleanName.split(', ');
        if (parts.length > 1) {
            // "Apellido, Nombre"
            initials = (parts[1].charAt(0) + parts[0].charAt(0)).toUpperCase();
        } else {
            // "Nombre Apellido"
            const words = cleanName.split(' ');
            if (words.length > 1) {
                initials = (words[0].charAt(0) + words[words.length-1].charAt(0)).toUpperCase();
            } else if (cleanName) {
                initials = cleanName.charAt(0).toUpperCase();
            }
        }

        // Color determinista basado en el nombre
        const hash = cleanName.split('').reduce((acc, char) => char.charCodeAt(0) + ((acc << 5) - acc), 0);
        const hue = Math.abs(hash) % 360;

        // Si la imagen es un placeholder nativo o está vacía, forzar iniciales inmediatamente
        const isPlaceholder = !imgSrc || imgSrc.includes('placeholder') || imgSrc.includes('default');
        
        const photoHtml = isPlaceholder 
            ? `<div class="hub-avatar-initials" style="--avatar-hue: ${hue};">${initials}</div>`
            : `<img class="hub-sv-photo" src="${imgSrc}" alt="${cleanName}" width="68" height="68" loading="lazy" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
               <div class="hub-avatar-initials" style="display:none; --avatar-hue: ${hue};">${initials}</div>`;

        return `<a href="${href}" class="hub-person-card">
            <div class="hub-sv-card-main">
                <div class="hub-sv-photo-wrap">
                    ${photoHtml}
                </div>
                <div class="hub-sv-info">
                    <div class="hub-sv-header">
                        <span class="hub-sv-name">${hlName}</span>
                    </div>
                    <span class="hub-sv-role">${hlRole || 'Investigador Universidad del Rosario'}</span>
                    ${deptTxt ? `<span class="hub-sv-dept-tag">${hlDept}</span>` : ''}
                    ${snippet ? `<p class="hub-sv-snippet">${hlSnip}</p>` : ''}
                </div>
                <div class="hub-sv-card-action">
                    <span class="hub-sv-arrow-new">&#8250;</span>
                </div>
            </div>
        </a>`;
    }

    function buildOrgCard(li) {
        // --- v20.0: Detección de tarjeta pre-renderizada (Premium FTL) ---
        const existingCard = li.querySelector('.hub-org-card');
        if (existingCard) return li.innerHTML;

        // Selector específico para evitar capturar texto de la descripción como si fuera el nombre
        const a = li.querySelector('h3 a, h3.thumb a, a.hub-org-card, .org-desc a[href], .individual > a[href], .individual h3 a');
        if (!a) return null;
        
        let name = a.textContent.trim();
        if (!name) name = 'Organización';
        name = sanitizeVIVOText(name);
        
        const href = a.getAttribute('href');
        if (!href) return null;

        const desc = li.querySelector('span.title, .snippet, .hub-sv-snippet');
        let descTxt = desc ? desc.textContent.trim().slice(0, 160) : '';
        descTxt = sanitizeVIVOText(descTxt);

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
        // --- v20.0: Detección de tarjeta pre-renderizada (Premium FTL) ---
        const existingCard = li.querySelector('.hub-program-card');
        if (existingCard) return li.innerHTML;

        const a = li.querySelector('h3 a, a.hub-program-card, a[href]');
        if (!a) return null;
        let name = a.textContent.trim() || 'Programa Académico';
        name = sanitizeVIVOText(name);

        const href = a.getAttribute('href');

        // A1: Truncar título largo - extraer solo el nombre del programa
        // Usar split agresivo: cortar en "Programa" cuando va seguido de "acad" (cualquier encoding)
        const progIdx = name.search(/\s+Programa\s+acad/i);
        if (progIdx > 0) {
            name = name.substring(0, progIdx);
        }
        // Fallback: cortar en "Pulse aquí" o "Pulse aqui"
        const pulseIdx = name.search(/\.?\s*Pulse\s+aqu/i);
        if (pulseIdx > 0) {
            name = name.substring(0, pulseIdx);
        }
        name = name.replace(/\s+/g, ' ').trim();

        const mod  = li.querySelector('.hub-program-desc, #programDescription, span.title, .snippet');
        let detail = mod ? mod.textContent.trim() : '';
        detail = sanitizeVIVOText(detail);

        // También limpiar el detalle
        const detProgIdx = detail.search(/\s*Programa\s+acad/i);
        if (detProgIdx > 0) detail = detail.substring(0, detProgIdx);
        const detPulseIdx = detail.search(/\.?\s*Pulse\s+aqu/i);
        if (detPulseIdx > 0) detail = detail.substring(0, detPulseIdx);
        detail = detail.slice(0, 120);

        return `<a href="${href}" class="hub-program-card">
            <div class="hub-program-icon-wrap">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/></svg>
            </div>
            <div class="hub-program-info">
                <span class="hub-program-name">${name}</span>
                ${detail ? `<span class="hub-program-desc">${detail}${detail.length >= 120 ? '\u2026' : ''}</span>` : ''}
            </div>
        </a>`;
    }

    function buildPublicationRow(li) {
        const a = li.querySelector('h3 a, a[href]');
        if (!a) return null;
        
        let title = a.textContent.trim();
        title = sanitizeVIVOText(title);
        const href = a.getAttribute('href');

        const type = detectType(li);
        const year = extractYear(li) || 'Sin fecha';
        const snippet = getSnippet(li);
        let typeText = '';
        li.childNodes.forEach(n => {
            if (n.nodeType === 3) {
                const t = n.textContent.replace(/\|/g, '').trim();
                if (t && t.length > 2 && t.length < 60) typeText = t;
            }
        });

        // A3: Enriquecer con ícono y estructura de tarjeta
        return `<div class="hub-pub-row hub-pub-card">
            <div class="hub-pub-icon-wrap">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
                    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
                </svg>
            </div>
            <div class="hub-pub-content">
                ${typeText ? `<span class="hub-pub-type">${typeText}</span>` : ''}
                <a href="${href}" class="hub-pub-title">${title}</a>
                ${snippet ? `<p class="hub-pub-snippet">${snippet.slice(0,180)}${snippet.length > 180 ? '\u2026' : ''}</p>` : ''}
            </div>
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
    // DEDUPLICACIÃ“N GLOBAL
    // ------------------------------------------------------------------
    const seenUrls = new Set();

    // ------------------------------------------------------------------
    // CONFIGURACIÃ“N DE CATEGORÃAS
    // ------------------------------------------------------------------
    const CATEGORIES = {
        profiles: {
            url:         `${SEARCH}?${baseQ}&filters_category=category:http://vivoweb.org/ontology%23vitroClassGrouppeople`,
            prefix:      'profiles',
            sectionId:   'category-profiles',
            contentId:   'grid-profiles-content',
            skeletonType:'grid',
            limit:       4,  // v16.2 Sync: 2x2 grid
            // NO filtrar por tipo: los resultados del classgroup "people" ya estÃ¡n validados
            typeFilter:  li => true,
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
            // LÃ“GICA INVERSA: todo lo que NO es 'org' dentro del classgroup organizations = programa
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
            // NO filtrar por tipo: los resultados del classgroup "publications" ya estÃ¡n validados
            typeFilter:  li => true,
            builder:     buildPublicationRow
        },
    };

    // ------------------------------------------------------------------
    // LOADER POR CATEGORÃA
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
            const cacheKey = 'hub_v13_' + btoa(unescape(encodeURIComponent(cfg.url)));
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
            
            // Usar filteredData si existe (filtro activo), sino data original
            let relevant = this.state[key].filteredData || this.state[key].data;
            if (!this.state[key].data) {
                const searchList = vDoc.querySelector('ul.searchhits');
                if (!searchList) { 
                    if (section) section.style.display = 'none'; 
                    if (badge) {
                        badge.classList.remove('loading');
                        const sidebarLi = badge.closest('li');
                        if (sidebarLi) sidebarLi.style.display = 'none';
                        badge.textContent = '';
                    }
                    return; 
                }
                
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
                    })
                    // --- v20.6: FILTRO DE RELEVANCIA ESTRICTA (Normalizado para Acentos) ---
                    .filter(li => {
                        if (!queryText || queryText.length < 3) return true;
                        const visibleText = normalizeText(li.textContent);
                        const queryNorm = normalizeText(queryText);
                        // Solo dejar el resultado si la palabra aparece en el texto visible de la tarjeta
                        return visibleText.includes(queryNorm);
                    });
                this.state[key].data = relevant;
            }

            const limit = cfg.limit || 6;
            const shownItems = isExpanded ? relevant : relevant.slice(0, limit);

            if (shownItems.length === 0) {
                if (section) section.style.display = 'none';
                if (badge) {
                    badge.classList.remove('loading');
                    const sidebarLi = badge.closest('li');
                    if (sidebarLi) sidebarLi.style.display = 'none';
                    badge.textContent = '';
                }
                return;
            }

            container.innerHTML = shownItems
                .map(li => cfg.builder(li))
                .filter(html => html !== null)
                .join('');

            // B2: Animación escalonada para tarjetas
            const cards = container.children;
            for (let i = 0; i < cards.length; i++) {
                cards[i].style.animationDelay = `${i * 0.06}s`;
            }

            // v15.6: Nuclear Delayed Update to win against VIVO native scripts
            const finalCount = relevant.length;

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
                }
            }, 500);
            
            // Aplicar restricciÃ³n de altura directamente (v15.0) para bypass cachÃ© FTL
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
            
            // E2: Contador de resultados visible "Mostrando X de Y"
            const counterHtml = `<span class="hub-category-counter">Mostrando <strong>${shownItems.length}</strong> de <strong>${relevant.length}</strong></span>`;

            // Renderizar footer según estado
            const footer = section.querySelector('.category-footer');
            if (footer) {
                if (relevant.length > limit) {
                    footer.innerHTML = `
                        <div class="hub-footer-actions">
                            ${counterHtml}
                            <button class="view-all-btn" onclick="HUB_DASHBOARD.toggleExpand('${key}')">
                                ${isExpanded ? `CONTRAER RESULTADOS` : `VER LOS ${relevant.length} RESULTADOS`}
                            </button>
                        </div>`;
                    footer.style.display = 'block';
                } else {
                    footer.innerHTML = `<div class="hub-footer-actions" style="justify-content:flex-start;">${counterHtml}</div>`;
                    footer.style.display = 'block';
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
    // TOOLBAR: Ordenar y Filtrar resultados (v17.0)
    // ------------------------------------------------------------------
    function buildToolbar() {
        const mainResults = document.getElementById('dashboard-main-results');
        if (!mainResults || document.getElementById('hub-toolbar')) return;

        const toolbar = document.createElement('div');
        toolbar.id = 'hub-toolbar';
        toolbar.setAttribute('role', 'toolbar');
        toolbar.setAttribute('aria-label', 'Filtros y ordenamiento de resultados');
        toolbar.innerHTML = `
            <div class="hub-toolbar-group">
                <label for="hub-sort-select" class="hub-toolbar-label">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:-2px;margin-right:4px;">
                        <path d="M3 6h18M6 12h12M9 18h6"/>
                    </svg>
                    Ordenar por
                </label>
                <select id="hub-sort-select" class="hub-toolbar-select" aria-label="Ordenar resultados">
                    <option value="relevance">Relevancia</option>
                    <option value="az">Alfabético (A-Z)</option>
                    <option value="za">Alfabético (Z-A)</option>
                </select>
            </div>
            
            <div class="hub-toolbar-group">
                <div class="hub-toolbar-filter-wrap">
                    <button id="hub-filter-faculty-btn" class="hub-toolbar-dropdown" aria-haspopup="true" aria-expanded="false">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-right:2px"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                        Facultad
                        <svg class="hub-toolbar-chevron" width="10" height="6" viewBox="0 0 10 6" fill="none"><path d="M1 1l4 4 4-4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
                    </button>
                    <div class="hub-toolbar-dropdown-panel" id="hub-filter-faculty-panel" role="listbox" aria-label="Filtrar por facultad">
                        <p class="hub-toolbar-panel-empty">Cargando...</p>
                    </div>
                </div>
            </div>`;
        mainResults.insertBefore(toolbar, mainResults.firstChild);

        // C3: Contenedor para chips de filtros activos
        const activeFiltersContainer = document.createElement('div');
        activeFiltersContainer.id = 'hub-active-filters';
        activeFiltersContainer.className = 'hub-active-filters-wrap';
        mainResults.insertBefore(activeFiltersContainer, toolbar.nextSibling);

        // --- Sort handler ---
        const sortSelect = document.getElementById('hub-sort-select');
        if (sortSelect) {
            sortSelect.addEventListener('change', function() {
                const sortMode = this.value;
                const dash = window.HUB_DASHBOARD;
                if (!dash) return;

                Object.keys(dash.state).forEach(key => {
                    const data = dash.state[key].data;
                    if (!data || data.length === 0) return;

                    if (sortMode === 'az') {
                        data.sort((a, b) => {
                            const nameA = (a.querySelector('a[href]')?.textContent || '').trim().toLowerCase();
                            const nameB = (b.querySelector('a[href]')?.textContent || '').trim().toLowerCase();
                            return nameA.localeCompare(nameB, 'es');
                        });
                    } else if (sortMode === 'za') {
                        data.sort((a, b) => {
                            const nameA = (a.querySelector('a[href]')?.textContent || '').trim().toLowerCase();
                            const nameB = (b.querySelector('a[href]')?.textContent || '').trim().toLowerCase();
                            return nameB.localeCompare(nameA, 'es');
                        });
                    }
                    dash.loadCategory(key);
                });
            });
        }

        // --- Faculty dropdown toggle ---
        const facultyBtn = document.getElementById('hub-filter-faculty-btn');
        const facultyPanel = document.getElementById('hub-filter-faculty-panel');
        if (facultyBtn && facultyPanel) {
            facultyBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                const isOpen = facultyPanel.classList.toggle('open');
                facultyBtn.setAttribute('aria-expanded', isOpen);
            });
            document.addEventListener('click', function() {
                facultyPanel.classList.remove('open');
                facultyBtn.setAttribute('aria-expanded', 'false');
            });
            facultyPanel.addEventListener('click', function(e) { e.stopPropagation(); });
        }
    }

    /** Populate the faculty dropdown once profiles data is loaded */
    function populateFacultyFilter() {
        const panel = document.getElementById('hub-filter-faculty-panel');
        if (!panel) return;
        const dash = window.HUB_DASHBOARD;
        if (!dash || !dash.state.profiles || !dash.state.profiles.data) return;

        const faculties = new Set();
        dash.state.profiles.data.forEach(li => {
            const dept = li.querySelector('.hub-sv-dept-tag, .hub-sv-dept');
            if (dept) {
                const txt = dept.textContent.trim();
                if (txt) faculties.add(txt);
            }
        });

        if (faculties.size === 0) {
            panel.innerHTML = '<p class="hub-toolbar-panel-empty">Sin datos de facultad disponibles</p>';
            return;
        }

        // C2: Buscador interno en el dropdown si hay muchas facultades
        let html = '';
        if (faculties.size > 5) {
            html += `
            <div class="hub-dropdown-search">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
                <input type="text" id="hub-faculty-search-input" placeholder="Buscar facultad..." autocomplete="off">
            </div>`;
        }
        html += '<div class="hub-dropdown-options-list">';
        html += '<button class="hub-toolbar-filter-option hub-filter-active" data-faculty="all">Todas</button>';
        faculties.forEach(f => {
            html += `<button class="hub-toolbar-filter-option" data-faculty="${f}">${f}</button>`;
        });
        html += '</div>';
        panel.innerHTML = html;

        // Listener para el buscador interno
        const searchInput = document.getElementById('hub-faculty-search-input');
        if (searchInput) {
            searchInput.addEventListener('input', function(e) {
                const term = e.target.value.toLowerCase();
                panel.querySelectorAll('.hub-toolbar-filter-option').forEach(btn => {
                    if (btn.getAttribute('data-faculty') === 'all') return;
                    const text = btn.textContent.toLowerCase();
                    btn.style.display = text.includes(term) ? 'flex' : 'none';
                });
            });
            // Evitar que hacer clic en el input cierre el dropdown
            searchInput.addEventListener('click', e => e.stopPropagation());
        }

        panel.querySelectorAll('.hub-toolbar-filter-option').forEach(btn => {
            btn.addEventListener('click', function() {
                panel.querySelectorAll('.hub-toolbar-filter-option').forEach(b => b.classList.remove('hub-filter-active'));
                this.classList.add('hub-filter-active');

                const faculty = this.getAttribute('data-faculty');
                const dash = window.HUB_DASHBOARD;
                if (!dash) return;

                if (faculty === 'all') {
                    Object.keys(dash.state).forEach(k => dash.state[k].filteredData = null);
                    document.getElementById('hub-active-filters').innerHTML = '';
                } else {
                    Object.keys(dash.state).forEach(k => {
                        const data = dash.state[k].data;
                        if (!data) return;
                        dash.state[k].filteredData = data.filter(li => {
                            const textContent = li.textContent.trim().toLowerCase();
                            return textContent.includes(faculty.toLowerCase());
                        });
                    });
                    
                    // Renderizar chip C3
                    document.getElementById('hub-active-filters').innerHTML = `
                        <div class="hub-filter-chip">
                            <span>Facultad: <strong>${faculty}</strong></span>
                            <button onclick="document.querySelector('[data-faculty=\\'all\\']').click()" aria-label="Eliminar filtro de facultad">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 6L6 18M6 6l12 12"/></svg>
                            </button>
                        </div>
                    `;
                }

                Object.keys(dash.state).forEach(k => dash.loadCategory(k));

                panel.classList.remove('open');
                document.getElementById('hub-filter-faculty-btn')?.setAttribute('aria-expanded', 'false');
            });
        });
    }

    // ------------------------------------------------------------------
    // SIDEBAR: click -> scroll suave + highlight
    // ------------------------------------------------------------------
    document.querySelectorAll('#content-type-menu li[data-target]').forEach(li => {
        li.addEventListener('click', () => {
            const targetId = li.getAttribute('data-target');
            const target   = document.getElementById(targetId);
            if (target && target.style.display !== 'none') {
                // B1: Scroll suave con offset para compensar toolbar fijo
                const yOffset = -80;
                const y = target.getBoundingClientRect().top + window.pageYOffset + yOffset;
                window.scrollTo({ top: y, behavior: 'smooth' });
            }
            document.querySelectorAll('#content-type-menu li').forEach(l => l.classList.remove('active-filter'));
            li.classList.add('active-filter');
        });
    });

    // SIDEBAR: scrollspy con IntersectionObserver
    const sectionIds = Object.values(CATEGORIES).map(c => c.sectionId);
    let isExpanding = false;
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
    // EJECUCION EN SERIE + TOOLBAR (v17.0)
    // ------------------------------------------------------------------
    window.HUB_DASHBOARD = {
        state: {},
        categories: CATEGORIES,
        loadCategory: loadCategory,
        toggleExpand: function(key) {
            this.state[key] = this.state[key] || {};
            this.state[key].expanded = !this.state[key].expanded;
            isExpanding = true;
            this.loadCategory(key);
            if (this.state[key].expanded) {
                setTimeout(() => {
                    document.querySelector(`#category-${key}`).scrollIntoView({ behavior: 'smooth', block: 'start' });
                    setTimeout(() => { isExpanding = false; }, 800);
                }, 100);
            } else {
                isExpanding = false;
            }
        },
        init: async function() {
            const ORDER = ['profiles', 'organizations', 'programs', 'publications'];
            ORDER.forEach(k => { this.state[k] = { expanded: false, data: null, filteredData: null }; });

            buildToolbar();

            // E3: Botón Volver Arriba
            if (!document.getElementById('hub-back-to-top')) {
                const btt = document.createElement('button');
                btt.id = 'hub-back-to-top';
                btt.className = 'hub-back-to-top';
                btt.setAttribute('aria-label', 'Volver al inicio');
                btt.innerHTML = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 19V5M5 12l7-7 7 7"/></svg>';
                btt.onclick = () => window.scrollTo({ top: 0, behavior: 'smooth' });
                document.body.appendChild(btt);

                window.addEventListener('scroll', () => {
                    if (window.scrollY > 400) btt.classList.add('visible');
                    else btt.classList.remove('visible');
                });
            }

            try {
                for (const k of ORDER) {
                    await this.loadCategory(k);
                    if (k === 'profiles') populateFacultyFilter();
                }
            } catch (e) {
                console.error('[HUB Dashboard v17.0] Error en inicializacion:', e);
            }
        }
    };

    window.HUB_DASHBOARD.init();
});
