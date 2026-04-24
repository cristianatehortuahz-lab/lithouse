<!DOCTYPE html>
<html lang="es" data-theme="dark">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mapa de Coautorías · Red de Investigadores</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="legend_styles.css">
    <style>
        *,
        *::before,
        *::after {
            box-sizing: border-box;
        }

        /* ═══════════════════════════════════════════════
           THEME VARIABLES (UR Branding Applied)
        ═══════════════════════════════════════════════ */
        :root {
            /* DARK MODE (Based on Navy #190356 but darker for readability) */
            --bg: #11023a;
            /* Dark Navy */
            --bg2: #190356;
            /* UR Secondary Navy */
            --glass-bg: rgba(25, 3, 86, 0.85);
            --glass-border: rgba(255, 255, 255, 0.12);
            --text: #f8f8f8;
            /* UR Light Grey */
            --text-muted: #cbd5e1;
            --text-subtle: #94a3b8;
            --accent: #DA0921;
            /* UR Primary Red */
            --accent-dim: rgba(218, 9, 33, 0.15);
            --input-bg: rgba(255, 255, 255, 0.08);
            --input-border: rgba(255, 255, 255, 0.15);
            --link-stroke: rgba(248, 248, 248, 0.2);
            --node-label: #f8f8f8;
            --node-shadow: #11023a;
            --shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
        }

        [data-theme="light"] {
            /* LIGHT MODE (Based on UR Light Grey #F8F8F8) */
            --bg: #F8F8F8;
            /* UR Light Grey */
            --bg2: #ffffff;
            --glass-bg: rgba(255, 255, 255, 0.92);
            --glass-border: rgba(25, 3, 86, 0.15);
            --text: #212529;
            /* UR Text Dark */
            --text-muted: #475569;
            --text-subtle: #64748b;
            --accent: #DA0921;
            /* UR Primary Red */
            --accent-dim: rgba(218, 9, 33, 0.12);
            --input-bg: rgba(25, 3, 86, 0.05);
            /* Navy tint */
            --input-border: rgba(25, 3, 86, 0.15);
            /* Navy tint */
            --link-stroke: rgba(25, 3, 86, 0.15);
            --node-label: #190356;
            /* UR Secondary Navy */
            --node-shadow: #ffffff;
            --shadow: 0 4px 16px rgba(25, 3, 86, 0.12);
        }

        body {
            font-family: 'Inter', 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            overflow: hidden;
            overflow-x: hidden;
            /* Previene scroll horizontal en móviles */
            background: var(--bg);
            color: var(--text);
            transition: background 0.3s, color 0.3s;
        }

        /* ── HEADER ────────────────────────────────── */
        #app-header {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 48px;
            background: var(--glass-bg);
            backdrop-filter: blur(14px);
            border-bottom: 1px solid var(--glass-border);
            display: flex;
            align-items: center;
            padding: 0 16px;
            z-index: 20;
            gap: 10px;
            overflow: hidden;
            /* Corta los hijos que salgan del borde del header */
        }

        .logo-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: linear-gradient(135deg, #38bdf8, #818cf8);
            flex-shrink: 0;
        }

        #app-header h1 {
            font-size: 13px;
            font-weight: 700;
            color: var(--text);
            margin: 0;
        }

        #app-header .subtitle {
            font-size: 11px;
            color: var(--text-muted);
        }

        #header-right {
            display: flex;
            align-items: center;
            gap: 6px;
            margin-left: auto;
        }

        /* shared header button style */
        .hdr-btn {
            background: var(--input-bg);
            border: 1px solid var(--input-border);
            color: var(--text-subtle);
            border-radius: 6px;
            font-size: 12px;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .hdr-btn:hover {
            background: var(--accent-dim);
            color: var(--accent);
            border-color: var(--accent);
        }

        .hdr-btn.active {
            background: var(--accent-dim);
            color: var(--accent);
            border-color: var(--accent);
        }

        #btn-theme {
            width: 32px;
            height: 32px;
            font-size: 16px;
            border-radius: 8px;
        }

        #btn-help {
            width: 32px;
            height: 32px;
            font-size: 14px;
            font-weight: 700;
            border-radius: 50%;
        }

        /* Loading overlay styles → see cinematic block below */

        /* ── GLASS BASE ────────────────────────────── */
        .glass {
            background: var(--glass-bg);
            backdrop-filter: blur(14px);
            border: 1px solid var(--glass-border);
            border-radius: 10px;
            box-shadow: var(--shadow);
        }

        /* ── CONTROLS (top-left) ───────────────────── */
        #controls {
            position: absolute;
            top: 64px;
            left: 20px;
            padding: 14px 16px;
            z-index: 10;
            display: flex;
            flex-direction: column;
            gap: 12px;
            min-width: 230px;
        }

        .switch-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 13px;
            font-weight: 500;
            color: var(--text);
        }

        .switch {
            position: relative;
            display: inline-block;
            width: 40px;
            height: 22px;
            flex-shrink: 0;
        }

        .switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .slider {
            position: absolute;
            cursor: pointer;
            inset: 0;
            background: var(--input-bg);
            transition: .3s;
            border-radius: 22px;
            border: 1px solid var(--input-border);
        }

        .slider:before {
            position: absolute;
            content: "";
            height: 16px;
            width: 16px;
            left: 2px;
            bottom: 2px;
            background: var(--text-subtle);
            transition: .3s;
            border-radius: 50%;
        }

        input:checked+.slider {
            background: var(--accent);
            border-color: var(--accent);
        }

        input:checked+.slider:before {
            transform: translateX(18px);
            background: white;
        }

        #search-container {
            position: relative;
            display: flex;
            gap: 8px;
        }

        #search-input {
            flex: 1;
            padding: 8px 12px;
            background: var(--input-bg);
            border: 1px solid var(--input-border);
            border-radius: 6px;
            font-size: 13px;
            font-family: 'Inter', sans-serif;
            color: var(--text);
            outline: none;
            transition: border-color 0.2s;
        }

        #search-input::placeholder {
            color: var(--text-muted);
        }

        #search-input:focus {
            border-color: var(--accent);
        }

        #search-btn {
            background: var(--accent);
            color: #fff;
            border: none;
            padding: 8px 10px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            font-family: 'Inter', sans-serif;
            transition: opacity 0.2s;
        }

        [data-theme="dark"] #search-btn {
            color: #0f172a;
        }

        #search-btn:hover {
            opacity: 0.85;
        }

        #search-suggestions {
            position: absolute;
            left: 0;
            top: 100%;
            margin-top: 4px;
            width: 100%;
            background: var(--bg2);
            border: 1px solid var(--glass-border);
            border-radius: 8px;
            box-shadow: var(--shadow);
            max-height: 220px;
            overflow-y: auto;
            z-index: 100;
            display: none;
        }

        .suggestion-item {
            padding: 9px 12px;
            font-size: 13px;
            cursor: pointer;
            color: var(--text);
            border-bottom: 1px solid var(--glass-border);
            transition: background 0.15s;
        }

        .suggestion-item:last-child {
            border-bottom: none;
        }

        .suggestion-item:hover,
        .suggestion-item.active {
            background: var(--accent-dim);
            color: var(--accent);
        }

        /* ── BTN CLOSE DETAIL ──────────────────────── */
        #btn-close-detail {
            display: none;
            position: absolute;
            top: 64px;
            right: 20px;
            background: rgba(239, 68, 68, 0.12);
            color: #f87171;
            border: 1px solid rgba(239, 68, 68, 0.25);
            padding: 8px 16px;
            font-size: 13px;
            font-weight: 600;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            border-radius: 8px;
            z-index: 10;
            backdrop-filter: blur(8px);
            transition: all 0.2s;
        }

        #btn-close-detail:hover {
            background: rgba(239, 68, 68, 0.22);
        }

        /* ── NODE PROFILE SIDEBAR ──────────────────── */
        #node-sidebar {
            position: absolute;
            top: 64px;
            right: 20px;
            width: 270px;
            max-height: calc(100vh - 130px);
            overflow-y: auto;
            padding: 18px;
            z-index: 10;
            display: none;
            flex-direction: column;
            gap: 12px;
        }

        #node-sidebar.visible {
            display: flex;
        }

        .sidebar-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 10px;
        }

        .node-avatar {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 17px;
            font-weight: 700;
            flex-shrink: 0;
            color: #0f172a;
        }

        .node-name {
            font-size: 14px;
            font-weight: 700;
            color: var(--text);
            line-height: 1.3;
            flex: 1;
        }

        .node-faculty {
            display: inline-block;
            font-size: 10px;
            font-weight: 600;
            padding: 2px 8px;
            border-radius: 20px;
            margin-top: 3px;
        }

        .node-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
        }

        .stat-box {
            background: var(--input-bg);
            border: 1px solid var(--glass-border);
            border-radius: 8px;
            padding: 10px 12px;
            text-align: center;
        }

        .stat-value {
            font-size: 22px;
            font-weight: 700;
            color: var(--accent);
            line-height: 1;
        }

        .stat-label {
            font-size: 10px;
            color: var(--text-muted);
            margin-top: 3px;
        }

        .sidebar-section-title {
            font-size: 10px;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.8px;
            margin-bottom: 4px;
        }

        .coauthor-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 7px 8px;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.15s;
            gap: 8px;
        }

        .coauthor-item:hover {
            background: var(--accent-dim);
        }

        .coauthor-name {
            font-size: 12px;
            color: var(--text);
            flex: 1;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .coauthor-count {
            font-size: 11px;
            font-weight: 600;
            color: var(--accent);
            background: var(--accent-dim);
            padding: 2px 7px;
            border-radius: 10px;
            white-space: nowrap;
        }

        #btn-ego-net {
            width: 100%;
            padding: 9px;
            border: none;
            border-radius: 8px;
            background: linear-gradient(135deg, #38bdf8, #818cf8);
            color: #fff;
            font-size: 13px;
            font-weight: 700;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: opacity 0.2s;
        }

        [data-theme="dark"] #btn-ego-net {
            color: #0f172a;
        }

        #btn-ego-net:hover {
            opacity: 0.88;
        }

        #sidebar-close {
            cursor: pointer;
            color: var(--text-muted);
            font-size: 16px;
            transition: color 0.2s;
        }

        #sidebar-close:hover {
            color: #f87171;
        }

        /* ── EDGE INFO PANEL ───────────────────────── */
        #info-panel {
            position: absolute;
            bottom: 120px;
            left: 20px;
            padding: 16px 20px;
            z-index: 10;
            display: none;
            width: 290px;
            color: var(--text);
        }

        #info-panel h3 {
            margin: 0 0 10px;
            font-size: 13px;
            color: var(--text);
            border-bottom: 1px solid var(--glass-border);
            padding-bottom: 8px;
        }

        #info-panel p {
            margin: 6px 0;
            font-size: 13px;
            color: var(--text-subtle);
            line-height: 1.4;
        }

        #info-close {
            position: absolute;
            top: 12px;
            right: 14px;
            cursor: pointer;
            font-size: 15px;
            color: var(--text-muted);
        }

        #info-close:hover {
            color: #f87171;
        }

        /* ── HOVER TOOLTIP ─────────────────────────── */
        #hover-tooltip {
            position: absolute;
            background: rgba(15, 23, 42, 0.96);
            color: #f1f5f9;
            padding: 8px 12px;
            border-radius: 8px;
            font-size: 12px;
            font-family: 'Inter', sans-serif;
            pointer-events: none;
            opacity: 0;
            z-index: 1000;
            transition: opacity 0.15s ease;
            transform: translate(-50%, -100%);
            margin-top: -10px;
            border: 1px solid rgba(255, 255, 255, 0.08);
            white-space: nowrap;
        }

        [data-theme="light"] #hover-tooltip {
            background: rgba(30, 41, 59, 0.95);
        }

        /* ── HELP / INFO OVERLAY ───────────────────── */
        #info-overlay {
            position: absolute;
            top: 64px;
            right: 20px;
            width: 270px;
            padding: 18px 20px;
            z-index: 30;
            display: none;
            color: var(--text-subtle);
            max-height: calc(100vh - 130px);
            overflow-y: auto;
        }

        #info-overlay.visible {
            display: block;
        }

        #info-overlay h4 {
            margin: 0 0 3px;
            font-size: 14px;
            font-weight: 700;
            color: var(--text);
        }

        #info-overlay .ov-subtitle {
            font-size: 11px;
            color: var(--text-muted);
            margin-bottom: 12px;
        }

        #info-overlay hr {
            border: 0;
            border-top: 1px solid var(--glass-border);
            margin: 10px 0;
        }

        .ov-section {
            font-size: 10px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.6px;
            margin-bottom: 8px;
        }

        .exp-row {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 8px;
        }

        .exp-icon {
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 32px;
        }

        .exp-text {
            line-height: 1.35;
            font-size: 12px;
        }

        .exp-text strong {
            color: var(--text);
        }

        /* ── SVG / NETWORK ─────────────────────────── */
        #network-graph {
            display: block;
        }

        .node {
            cursor: pointer;
            transition: filter 0.2s, opacity 0.3s;
        }

        .node:hover {
            filter: drop-shadow(0 0 10px currentColor);
        }

        .node.dimmed {
            opacity: 0.07;
        }

        .link {
            cursor: pointer;
            transition: stroke-opacity 0.2s, opacity 0.3s;
        }

        .link.dimmed {
            opacity: 0.04;
        }

        .node-label {
            font-family: 'Inter', sans-serif;
            font-size: 10px;
            fill: var(--node-label);
            pointer-events: none;
            font-weight: 600;
        }

        .node-label-shadow {
            font-family: 'Inter', sans-serif;
            font-size: 10px;
            stroke: var(--node-shadow);
            stroke-width: 4px;
            stroke-linejoin: round;
            fill: none;
            pointer-events: none;
            font-weight: 600;
        }

        .node-pubs-label {
            font-family: 'Inter', sans-serif;
            fill: rgba(255, 255, 255, 0.92);
            font-weight: 700;
            text-anchor: middle;
            dominant-baseline: central;
            pointer-events: none;
        }

        [data-theme="light"] .node-pubs-label {
            fill: rgba(0, 0, 0, 0.75);
        }

        /* ═══════════════════════════════════════════════
           RESPONSIVE DESIGN — Tablets & Móviles
        ═══════════════════════════════════════════════ */

        /* ── Tablet (≤1024px) ──────────────────────── */
        @media screen and (max-width: 1024px) {
            #controls {
                width: 240px;
            }

            #node-sidebar {
                width: 280px;
            }
        }

        /* ── Mobile (≤768px) ───────────────────────── */
        @media screen and (max-width: 768px) {

            /* 1. Header: ocultar subtítulo, reducir fuente */
            #app-header h1 {
                font-size: 11px;
            }

            #app-header .subtitle {
                display: none;
            }

            .hdr-btn {
                font-size: 11px;
                padding: 4px 8px;
            }

            /* 2. Panel de Controles: ancho completo debajo del header */
            #controls {
                top: 54px;
                left: 8px;
                right: 8px;
                width: auto;
                padding: 10px 12px;
                border-radius: 8px;
            }

            /* 3. Dropdown de búsqueda: ancho completo */
            #search-dropdown {
                top: auto;
                left: 8px;
                right: 8px;
                width: auto;
            }

            /* 4. Sidebar de Nodo: bottom sheet en móvil */
            #node-sidebar {
                top: auto;
                bottom: 0;
                right: 0;
                left: 0;
                width: 100%;
                max-height: 55vh;
                border-radius: 16px 16px 0 0;
                border-top: 1px solid var(--glass-border);
                border-left: none;
                transform: translateX(0) translateY(100%);
                transition: transform 0.3s ease;
            }

            #node-sidebar.active {
                transform: translateX(0) translateY(0);
            }

            /* 5. Panel de ayuda (overlay ?): centrado modal */
            #info-overlay {
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                width: 92vw;
                max-height: 80vh;
                right: auto;
                overflow-y: auto;
            }

            #info-overlay.visible {
                transform: translate(-50%, -50%);
            }

            /* 6. Panel de coautoría (info-panel) */
            #info-panel {
                bottom: auto;
                top: 120px;
                left: 8px;
                right: 8px;
                width: auto;
            }

            /* 7. Reducir tamaño de fuentes SVG en la red */
            .node-label,
            .node-label-shadow {
                font-size: 8px;
            }
        }

        /* ══════════════════════════════════════════════
           CINEMATIC LOADING OVERLAY
        ══════════════════════════════════════════════ */
        #loading-overlay {
            position: fixed;
            inset: 0;
            z-index: 9999;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: opacity 0.8s ease;
        }

        #loading-overlay.hidden {
            opacity: 0;
            pointer-events: none;
        }

        #loading-overlay.gone {
            display: none;
        }

        .loading-backdrop {
            position: absolute;
            inset: 0;
            background: var(--bg);
            backdrop-filter: blur(0px);
        }

        .loading-card {
            position: relative;
            z-index: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 14px;
        }

        /* ── Orbit animation ── */
        .orbit-container {
            position: relative;
            width: 140px;
            height: 140px;
            margin-bottom: 8px;
        }

        .orbit {
            position: absolute;
            inset: 0;
            border-radius: 50%;
            border: 1px solid rgba(255, 255, 255, 0.08);
            display: flex;
            align-items: flex-start;
            justify-content: center;
        }

        .orbit-1 {
            animation: spin 3s linear infinite;
        }

        .orbit-2 {
            animation: spin 5s linear infinite reverse;
        }

        .orbit-3 {
            animation: spin 8s linear infinite;
        }

        .orbit-node {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            margin-top: -5px;
            box-shadow: 0 0 8px currentColor;
        }

        .n1 {
            background: #38bdf8;
            color: #38bdf8;
        }

        .n2 {
            background: #a78bfa;
            color: #a78bfa;
        }

        .n3 {
            background: #DA0921;
            color: #DA0921;
        }

        .orbit-center {
            position: absolute;
            inset: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .orbit-core {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: linear-gradient(135deg, #38bdf8, #818cf8);
            box-shadow: 0 0 20px #38bdf890, 0 0 40px #818cf840;
            animation: pulse-core 2s ease-in-out infinite;
        }

        @keyframes spin {
            from {
                transform: rotate(0deg);
            }

            to {
                transform: rotate(360deg);
            }
        }

        @keyframes pulse-core {

            0%,
            100% {
                transform: scale(1);
                box-shadow: 0 0 20px #38bdf890;
            }

            50% {
                transform: scale(1.2);
                box-shadow: 0 0 35px #38bdf8cc, 0 0 60px #818cf850;
            }
        }

        .loading-title {
            font-family: 'Inter', sans-serif;
            font-size: 20px;
            font-weight: 700;
            color: var(--text);
            letter-spacing: -0.3px;
        }

        .loading-subtitle {
            font-size: 12px;
            color: var(--text-muted);
            letter-spacing: 0.3px;
        }

        .loading-bar-wrap {
            width: 200px;
            height: 3px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 99px;
            overflow: hidden;
        }

        .loading-bar-fill {
            height: 100%;
            width: 0%;
            background: linear-gradient(90deg, #38bdf8, #818cf8, #DA0921);
            border-radius: 99px;
            transition: width 0.3s ease;
        }

        .loading-status {
            font-size: 11px;
            color: var(--text-subtle);
            letter-spacing: 0.5px;
        }
    </style>
</head>

<body>

    <!-- Header -->
    <header id="app-header">
        <div class="logo-dot"></div>
        <h1>Mapa de Coautorías</h1>
        <span class="subtitle">Red de Investigadores · Universidad del Rosario</span>
        <div id="header-right">
            <button id="btn-theme" class="hdr-btn" title="Cambiar tema">🌙</button>
            <button id="btn-help" class="hdr-btn" title="Información del mapa">?</button>
        </div>
    </header>

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
    <div id="loading-overlay">
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

    <svg id="network-graph" style="width:100vw;height:100vh;"></svg>

    <script src="https://d3js.org/d3.v7.min.js"></script>
    <script src="network_logic.js"></script>
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

        // ── Load data ─────────────────────────────────
        // Absolute failsafe: hide overlay 6s after page load using direct style
        function hideOverlay() {
            const ov = document.getElementById('loading-overlay');
            if (!ov) return;
            ov.style.transition = 'opacity 0.8s ease';
            ov.style.opacity = '0';
            ov.style.pointerEvents = 'none';
            setTimeout(() => { if (ov) ov.style.display = 'none'; }, 900);
        }
        setTimeout(hideOverlay, 6000);

        d3.json("baseData.json")
            .then(data => initNetwork(data))
            .catch(err => {
                console.error("Error cargando baseData.json:", err);
                const ov = document.getElementById('loading-overlay');
                if (ov) ov.innerHTML = '<p style="color:#f87171;text-align:center;padding:20px">Error al cargar los datos.<br>Verifica que el servidor esté activo.</p>';
            });


    </script>
</body>

</html>
