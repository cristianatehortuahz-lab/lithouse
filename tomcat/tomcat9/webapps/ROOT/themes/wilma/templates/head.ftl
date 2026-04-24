<#-- $This file is distributed under the terms of the license in LICENSE$ -->
<#assign baseURL = "https://research-hub.urosario.edu.co" />
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  
  <!-- Preloads CRÍTICOS para 100/100 -->
  <#if individual?? && (individual.thumbNail)??>
    <link rel="preload" href="${(urls.base)!""}${(individual.thumbNail)!""}" as="image" fetchpriority="high" />
  <#elseif isHomePage??>
    <link rel="preload" href="${(urls.base)!""}/themes/wilma/images/servicios/s1.webp" as="image" type="image/webp" fetchpriority="high" />
  </#if>
  
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800&display=swap" rel="stylesheet" media="print" onload="this.media='all'" />

  <link rel="dns-prefetch" href="https://www.googletagmanager.com">
  <!-- Precargas de Red HUB-UR v2.6 -->
  <link rel="preconnect" href="${baseURL}" crossorigin>
  <link rel="dns-prefetch" href="${baseURL}">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>


  <!-- HUB-UR Turbo-Boost v3.9: Smart Pre-load & Atomic LCP Injection -->
  <script type="text/javascript">
      (function() {
          // HUB-UR: Usamos el DataServiceController para obtener JSON real
          var dataServiceUrl = '${urls.base}/dataservice?getRenderedSearchIndividualsByVClass=1&vclassId=';
          var defaultVClass = 'http://vivoweb.org/ontology/core#FacultyMember'; // Prioridad para investigadores
          
          // Corrección LCP v4.5: Parche global de Hash para prevenir 500 en todos los scripts
          if (window.location.hash.includes('FacultyMembe') && !window.location.hash.endsWith('r')) {
              var newHash = window.location.hash + 'r';
              if (history.replaceState) {
                  history.replaceState(null, null, newHash);
              } else {
                  window.location.hash = newHash;
              }
              console.warn('HUB-UR: Hash global corregido para evitar error 500');
          }

          var vclassId = 'http://vivoweb.org/ontology/core#FacultyMember'; // Default Investigadores
          var hash = window.location.hash.substring(1);

          if (hash) {
              // Si el hash empieza con http lo usamos, pero corregimos si está truncado
              if (hash.indexOf('http') === 0) {
                  vclassId = hash;
              } else if (hash.length > 3) {
                  // Si no es http pero tiene longitud, podría ser un tag corto
                  // Aquí podríamos mapear tags si fuera necesario, por ahora mantenemos el default seguro
              }
          }
          
          var finalUrl = dataServiceUrl + encodeURIComponent(vclassId);
          console.log('HUB-UR: Smart Pre-load iniciando para: ' + vclassId);

          window.hubUrPreloadPromise = fetch(finalUrl, { fetchPriority: 'high' }).then(function(r) { 
              return r.ok ? r.json() : null; 
          }).then(function(data) {
              // HUB-UR v4.0: Sonda de Ultra-Prioridad (Dynamic Link Injection) LCP
              if (data && data.individuals && data.individuals[0]) {
                  var firstImgMatch = data.individuals[0].shortViewHtml.match(/src="([^"]+)"/);
                  if (firstImgMatch && firstImgMatch[1]) {
                      var link = document.createElement('link');
                      link.rel = 'preload';
                      link.as = 'image';
                      link.href = firstImgMatch[1];
                      link.fetchPriority = 'high';
                      link.id = 'hub-lcp-preload';
                      document.head.appendChild(link);
                      console.log('HUB-UR: LCP Turbo-Boost inyectado: ' + firstImgMatch[1]);
                  }
              }
              return data;
          }).catch(function(e) { 
              console.error('HUB-UR: Pre-load falló', e);
              return null; 
          });
      })();
  </script>
  

  <link rel="preconnect" href="https://www.googletagmanager.com" crossorigin />
  <link rel="preconnect" href="https://cdnjs.cloudflare.com" crossorigin />
  <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />

  <title>${(title?html)!siteName!} | HUB-UR</title>

  <meta xml:lang="spa" content="HUB-UR, reune en un solo lugar, informacion publica sobre las fortalezas y capacidades de la Universidad del Rosario. Aprovechando los beneficios de la web semantica para mostrar información estructurada y vinculada, proporcionando resultados enriquecidos por asociaciones y relaciones categorizadas. Aqui, investigadores, estudiantes, empresas, agencias de financiamiento, tomadores de decisiones y el publico en general pueden identificar o descubrir nuestras actividades y logros" name="DC.description">
  <meta xml:lang="eng" content="Hub-UR: Services and experts finder gathers, in one place, public information about the strengths and capabilities of the Universidad del Rosario, this hub uses the semantic Web to show structured and linked information, providing results enriched by associations and categorized relationships. Here, researchers, students, companies, funding agencies, decision makers and the general public can identify or discover our activities and achievements" name="DC.description">

  <meta name="description" content="Portal de fortalezas de la univesidad del Rosario - Perfil en VIVO. Información académica, publicaciones, proyectos y afiliaciones." />
  <meta name="keywords" content="Universidad del Rosario, investigadores, vivo, centro, expertos, research HUB, Perfiles, facultades, escuelas, investigacion, servicios académicos, proyectos investigación, publicaciones científicas, laboratorios, CRAI, colaboración científica, capacidades institucionales" />
  <meta name="generator" content="VIVO ${version.label}" />
  <meta name="author" content="CRAI - Universidad del Rosario" />
  <meta name="copyright" content="© 2025 Universidad del Rosario - CRAI" />
  <meta name="publisher" content="Centro de Recursos para el Aprendizaje y la Investigación - Universidad del Rosario" />
  <meta name="robots" content="index, follow, max-snippet:-1, max-image-preview:large, max-video-preview:-1" />

  <!-- Open Graph -->
  <meta property="og:title" content="HUB-UR: Expertos y Servicios | Universidad del Rosario" />
  <meta property="og:description" content="Descubre expertos, laboratorios, proyectos y capacidades de investigación de la Universidad del Rosario en una sola plataforma." />
  <meta property="og:type" content="website" />
  <meta property="og:url" content="https://research-hub.urosario.edu.co/" />
  <meta property="og:site_name" content="HUB-UR - Universidad del Rosario" />
  <meta property="og:image" content="https://research-hub.urosario.edu.co/assets/images/hubur-share.jpg" />
  <meta property="og:image:secure_url" content="https://research-hub.urosario.edu.co/assets/images/hubur-share.jpg" />
  <meta property="og:image:type" content="image/jpeg" />
  <meta property="og:image:width" content="1200" />
  <meta property="og:image:height" content="630" />
  <meta property="og:image:alt" content="HUB-UR - Portal de Fortalezas Institucionales Universidad del Rosario" />
  <meta property="og:locale" content="es_CO" />
  <meta property="og:locale:alternate" content="en_US" />

  <meta name="google-site-verification" content="7f_pCsseUDacpj018ecJM1mEysQbi82CEphBs6Zd4sA" />

  <!-- Twitter -->
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:site" content="@urosario" />
  <meta name="twitter:creator" content="@urosario" />
  <meta name="twitter:title" content="HUB-UR: Expertos y Servicios | Universidad del Rosario" />
  <meta name="twitter:description" content="Descubre expertos, laboratorios, proyectos y capacidades de investigación de la Universidad del Rosario." />
  <meta name="twitter:image" content="https://research-hub.urosario.edu.co/assets/images/hubur-share.jpg" />
  <meta name="twitter:image:alt" content="HUB-UR - Portal de Fortalezas Institucionales" />
  <meta name="theme-color" content="rgba(218, 9, 33, 1)" />
  <meta name="msapplication-TileColor" content="rgba(218, 9, 33, 1)"  />
  
  <!-- CSS CRÍTICO (Inlined) - Dashboard & Globals -->
  <style>
    :root{--hub-red:#9b0000;--hub-red-light:#fff5f5;--hub-navy:#1a3a5c;--hub-gray-100:#f4f4f4;--hub-gray-200:#e8e8e8;--hub-gray-500:#707070;--hub-gray-700:#444444;--main-bg-color:#f7f9f9;--main-text-color:#5f6464;--link-color:#2485ae;--header-bg-color:rgb(218,9,33)}
    html,body{margin:0;padding:0;height:100%;min-height:100%;background:#f7f9f9;font-family:'Inter',sans-serif;color:#595b5b;overflow-x:hidden;-webkit-font-smoothing:antialiased}
    header,nav,section,article,footer{display:block}
    #branding{background:var(--header-bg-color);display:flex;width:100%;z-index:1030;min-height:60px;position:relative}
    .header-container{display:flex;justify-content:space-between;align-items:center;width:100%;max-width:1280px;margin:0 auto;padding:10px 20px}
    #pure-dashboard-wrapper{max-width:1220px;margin:0 auto;padding:0 20px}
    #dashboard-search-layout{display:flex;gap:40px;margin-top:30px}
    #dashboard-main-results{flex:1!important;min-width:0!important;display:flex!important;flex-direction:column!important;gap:20px!important;padding-bottom:100px}
    
    /* ESTILOS PREMIUM - HUB-UR */
    .hub-person-card{
        background: #fff;
        border-radius: 16px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1), box-shadow 0.3s ease;
        border: 1px solid rgba(0,0,0,0.03);
        overflow: hidden;
        animation: hub-fadeInUp 0.5s ease backwards;
        min-height: 125px; /* Evita CLS */
    }
    /* OPTIMIZACIÓN LCP: El primer elemento no debe tener animación para pintar instantáneamente */
    .hub-person-card:first-child {
        animation: none !important;
        opacity: 1 !important;
        transform: none !important;
    }
    .hub-sv-card-main{
        display:flex;
        align-items:center;
        padding:20px;
        gap:20px;
        text-decoration:none!important;
    }
    /* SKELETON LOADING PARA MEJORAR PERCEPCIÓN DE VELOCIDAD */
    .hub-dashboard-loading {
        background: linear-gradient(90deg, #f0f0f0 25%, #f8f8f8 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: hub-skeleton 1.5s infinite;
    }
    @keyframes hub-skeleton { 0% { background-position: 200% 0; } 100% { background-position: -200% 0; } }
    .hub-person-photo{
        width:85px;
        height:85px;
        border-radius:50%;
        object-fit:cover;
        flex-shrink:0;
        border:3px solid #fff;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .hub-sv-name{
        font-size:18px;
        font-weight:800;
        color:var(--hub-navy);
        line-height:1.2;
        margin-bottom:4px;
        transition: color 0.2s ease;
    }
    .hub-person-card:hover .hub-sv-name { color: var(--hub-red); }
    .hub-sv-title {
        font-size:14px;
        color: var(--hub-gray-500);
        font-weight: 500;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
    
    @keyframes hub-fadeInUp{from{opacity:0;transform:translateY(20px)}to{opacity:1;transform:translateY(0)}}
    @media(max-width:992px){#dashboard-search-layout{flex-direction:column}}
  </style>

  <!-- Rendimiento HUB-UR (100/100 Lighthouse) -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link rel="preconnect" href="${urls.base}">
  <link rel="dns-prefetch" href="${urls.base}">

  <!-- Google Fonts CSS (Non-blocking) -->
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" media="print" onload="this.media='all'" />

  <#if individual??>
    <link rel="canonical" href="${baseURL}/display/${individual.localName}"/>
  <#else> 
    <link rel="canonical" href="${baseURL}"/>
  </#if>

  <#include "SEOschema.ftl">
  <#include "stylesheets.ftl">
  <#include "banner.ftl">
  
  <link rel="stylesheet" href="${urls.theme}/css/header-footer.css" media="print" onload="this.media='all'" />
  <noscript><link rel="stylesheet" href="${urls.theme}/css/header-footer.css" /></noscript>
  
  <link rel="stylesheet" href="${urls.theme}/css/screen.css" media="print" onload="this.media='all'" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" media="print" onload="this.media='all'" />
  
  <script>
    (function(w){
        <#assign allCap = "All">
        <#if i18n?? && i18n().all_capitalized??><#assign allCap = i18n().all_capitalized></#if>
        w.i18nStrings = { allCapitalized: '${allCap?js_string}' };
        w.urlsBase = '${(urls.base)!""}';
        
        var q = [];
        w.jQueryQuere = q;
        w.$ = w.jQuery = function(a) {
            if (typeof a === 'function') { q.push(a); return w.$; }
            var action = { selector: a, calls: [] };
            q.push(action);
            var g = new Proxy(function(){}, {
                get: function(t, p) {
                    if (p === 'toString' || p === 'valueOf' || p === 'data' || p === 'attr' || p === 'val') {
                        return function(){ return ""; };
                    }
                    return function(){
                        action.calls.push({ m: p, a: arguments });
                        return g;
                    };
                },
                apply: function(){ return g; }
            });
            return g;
        };
        w.$.toString = w.$.valueOf = function(){ return ""; };
    })(window);
  </script>

  <#if metaTags??>
      ${metaTags.list()}
  </#if>

  ${headContent!}

  <link rel="shortcut icon" type="image/x-icon" href="${(urls.base)!""}/favicon.ico">
  <#if scripts??>
    ${scripts.add('<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" defer></script>')}
  </#if>


