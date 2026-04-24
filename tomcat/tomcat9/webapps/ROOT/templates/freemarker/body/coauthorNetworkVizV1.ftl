
<div id="mapa-coautores-container">
  <!-- Header -->
  <div id="app-header">
      <div class="logo-dot"></div>
      <h1>Mapa de Coautorías</h1>
      <span class="subtitle">Red de Investigadores · Universidad del Rosario</span>
      <div id="header-right">
          <button id="btn-theme" class="hdr-btn" title="Cambiar tema">🌙</button>
          <button id="btn-help" class="hdr-btn" title="Información del mapa">?</button>
      </div>
  </div>

  <div id="hover-tooltip"></div>

  <!-- Faculty filter bar -->
  <div id="legend-panel">
      <div id="legend-content">
          <span id="legend-title">Filtrar por Facultad:</span>
          <button id="legend-reset-btn" style="display:none;">✕ Ver todas</button>
      </div>
      <button id="legend-toggle" aria-label="Ocultar/mostrar filtros">⌄ Ocultar</button>
  </div>

  <!-- Controls (top-left) -->
  <div id="controls" class="glass">
      <div class="switch-container">
          <span>Perfiles externos</span>
          <label class="switch">
              <input type="checkbox" id="toggle-external">
              <span class="slider"></span>
          </label>
      </div>
      <div id="search-container">
          <input type="text" id="search-input" placeholder="Buscar investigador…" autocomplete="off">
          <button id="search-btn">↵</button>
          <div id="search-suggestions"></div>
      </div>
  </div>

  <button id="btn-close-detail">&#10005; Volver a la red</button>

  <!-- Node Profile Sidebar -->
  <div id="node-sidebar" class="glass">
      <div class="sidebar-header">
          <div id="node-avatar" class="node-avatar">?</div>
          <div style="flex:1">
              <div id="node-name" class="node-name">—</div>
              <span id="node-faculty-badge" class="node-faculty">—</span>
          </div>
          <span id="sidebar-close">✕</span>
      </div>
      <div class="node-stats">
          <div class="stat-box">
              <div id="stat-pubs" class="stat-value">—</div>
              <div class="stat-label">Coautorías</div>
          </div>
          <div class="stat-box">
              <div id="stat-connections" class="stat-value">—</div>
              <div class="stat-label">Colaboradores</div>
          </div>
      </div>
      <div>
          <div class="sidebar-section-title">Top colaboradores</div>
          <div id="coauthor-list"></div>
      </div>
      <button id="btn-ego-net">🔍 Ver ego-network</button>
  </div>

  <!-- Help / Info overlay (? button) -->
  <div id="info-overlay" class="glass">
    <h4>🗺️ Mapa de Coautorías</h4>
    <p class="ov-subtitle">Red de Investigadores · Universidad del Rosario</p>
    <p style="font-size:12px;line-height:1.5">Visualización interactiva de relaciones de coautoría académica.
        Cada nodo es un investigador; cada arista, una colaboración en publicaciones.</p>
    <hr>
    <div class="ov-section">📖 Cómo leer el mapa</div>
    <div class="exp-row">
        <div class="exp-icon"><svg width="32" height="32">
                <circle cx="16" cy="16" r="14" fill="#38bdf8" opacity="0.9" /><text x="16" y="20"
                    text-anchor="middle" font-size="10" fill="#0f172a" font-weight="bold">42</text>
            </svg></div>
        <div class="exp-text"><strong>Tamaño del nodo</strong><br>= total de coautorías</div>
    </div>
    <div class="exp-row">
        <div class="exp-icon"><svg width="32" height="12">
                <line x1="0" y1="6" x2="32" y2="6" stroke="#38bdf8" stroke-width="1.5" stroke-opacity="0.7" />
            </svg></div>
        <div class="exp-text"><strong>Arista delgada</strong><br>= pocos documentos compartidos</div>
    </div>
    <div class="exp-row">
        <div class="exp-icon"><svg width="32" height="12">
                <line x1="0" y1="6" x2="32" y2="6" stroke="#38bdf8" stroke-width="5" stroke-opacity="0.8" />
            </svg></div>
        <div class="exp-text"><strong>Arista gruesa</strong><br>= muchos documentos compartidos</div>
    </div>
    <div class="exp-row">
        <div class="exp-icon"><svg width="32" height="32">
                <circle cx="16" cy="16" r="12" fill="#64748b" />
            </svg></div>
        <div class="exp-text"><strong>Nodo gris</strong><br>= perfil externo a la universidad</div>
    </div>
    <hr>
    <div class="ov-section">🖱️ Controles</div>
    <div class="exp-row">
        <div class="exp-icon" style="font-size:17px">👆</div>
        <div class="exp-text"><strong>Clic en nodo</strong><br>Abre perfil y top colaboradores</div>
    </div>
    <div class="exp-row">
        <div class="exp-icon" style="font-size:17px">🔍</div>
        <div class="exp-text"><strong>Scroll / pinch</strong><br>Zoom + pan arrastrando</div>
    </div>
    <div class="exp-row">
        <div class="exp-icon" style="font-size:17px">🎨</div>
        <div class="exp-text"><strong>Barra inferior</strong><br>Filtra nodos por facultad</div>
    </div>
    <div class="exp-row">
        <div class="exp-icon" style="font-size:17px">🔎</div>
        <div class="exp-text"><strong>Buscador</strong><br>Búsqueda con autocompletado</div>
    </div>
  </div>

  <!-- Edge info panel -->
  <div id="info-panel" class="glass">
    <span id="info-close">&times;</span>
    <h3 id="info-title">Detalle de Coautoría</h3>
    <div id="info-content"></div>
  </div>

  <!-- ══ CINEMATIC LOADING OVERLAY ══════════════════════════════ -->
  <div id="cinematic-overlay">
    <div class="loading-backdrop"></div>
    <div class="loading-card">
        <!-- Animated orbit rings -->
        <div class="orbit-container">
            <div class="orbit orbit-1">
                <div class="orbit-node n1"></div>
            </div>
            <div class="orbit orbit-2">
                <div class="orbit-node n2"></div>
            </div>
            <div class="orbit orbit-3">
                <div class="orbit-node n3"></div>
            </div>
            <div class="orbit-center">
                <div class="orbit-core"></div>
            </div>
        </div>
        <div class="loading-title">Mapa de Coautorías</div>
        <div class="loading-subtitle">Universidad del Rosario — Red de Investigadores</div>
        <div class="loading-bar-wrap">
            <div class="loading-bar-fill" id="loading-bar"></div>
        </div>
        <div class="loading-status" id="loading-status">Calculando posiciones…</div>
    </div>
  </div>
  <!-- Self-closing overlay: hide after 7s no matter what -->
  <script>
    (function () {
      var MAX_WAIT = 7000;
      setTimeout(function () {
          var el = document.getElementById('cinematic-overlay');
          if (el) {
              el.style.transition = 'opacity 0.8s ease';
              el.style.opacity = '0';
              el.style.pointerEvents = 'none';
              setTimeout(function () { el.style.display = 'none'; }, 900);
          }
      }, MAX_WAIT);
    })();
  </script>

  <svg id="network-graph" style="width:100vw;height:100vh;"></svg>

  <script src="https://d3js.org/d3.v7.min.js"></script>
  <script src="${urls.base}/themes/wilma/js/network_logic.js"></script>
  <script>
    // ── Theme toggle ─────────────────────────────
    const themeBtn = document.getElementById("btn-theme");
    themeBtn.addEventListener("click", () => {
        const html = document.documentElement;
        const isDark = html.getAttribute("data-theme") === "dark";
        html.setAttribute("data-theme", isDark ? "light" : "dark");
        themeBtn.textContent = isDark ? "🌙" : "☀️";
        // Update SVG background
        const svg = document.getElementById("network-graph");
        if (svg) svg.style.background = isDark ? "#f1f5f9" : "#0f172a";
    });

    // ── Help overlay toggle ───────────────────────
    const helpBtn = document.getElementById("btn-help");
    const infoOverlay = document.getElementById("info-overlay");
    helpBtn.addEventListener("click", () => {
        const open = infoOverlay.classList.toggle("visible");
        helpBtn.classList.toggle("active", open);
        // Close sidebar if open
        if (open) document.getElementById("node-sidebar").classList.remove("visible");
    });
    // Close overlay when clicking outside
    document.addEventListener("click", e => {
        if (!infoOverlay.contains(e.target) && e.target !== helpBtn) {
            infoOverlay.classList.remove("visible");
            helpBtn.classList.remove("active");
        }
    });

    // Intentar cargar el JSON estático (cache). Si no existe, el JSP lo genera.
    d3.json("${urls.base}/js/coauthorNetworkViz/baseData.json")
        .then(data => initNetwork(data))
        .catch(() => {
            console.warn("baseData.json no encontrado, generando desde SPARQL...");
            /* Mostrar mensaje en el overlay mientras el JSP genera datos */
            var statusEl = document.getElementById("loading-status");
            if (statusEl) statusEl.textContent = "Generando datos desde la base de datos…";
            var barEl = document.getElementById("loading-bar");
            if (barEl) { barEl.style.width = "15%"; barEl.style.transition = "width 120s linear"; barEl.style.width = "85%"; }
        });
  </script>
</div>


${stylesheets.add( '
<link rel="preconnect" href="https://fonts.googleapis.com">', '
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>','
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">', '
<link rel="stylesheet" href="${urls.base}/themes/wilma/css/legend_styles.css">')}