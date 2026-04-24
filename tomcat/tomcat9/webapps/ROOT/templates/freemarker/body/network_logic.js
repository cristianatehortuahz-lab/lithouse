/**
 * network_logic.js — v2.0 (Dark Mode + Full Interactivity)
 * Motor D3.js para la Red de Coautorías.
 *
 * initNetwork(data) ← entrada principal
 */

function initNetwork(data) {

    // =====================================================
    // SETUP SVG
    // =====================================================
    const width = window.innerWidth;
    const height = window.innerHeight;

    const svg = d3.select("#network-graph")
        .style("background", "#0f172a");
    const container = svg.append("g");

    const hoverTooltip = d3.select("#hover-tooltip");
    const infoPanelEl = d3.select("#info-panel");
    d3.select("#info-close").on("click", () => infoPanelEl.style("display", "none"));

    // =====================================================
    // CURATED FACULTY COLOR PALETTE (Vibrant / Initial)
    // =====================================================
    const FACULTY_COLORS = [
        "#38bdf8", "#fb923c", "#a78bfa", "#34d399",
        "#f472b6", "#facc15", "#60a5fa", "#4ade80",
        "#f87171", "#e879f9", "#2dd4bf", "#fbbf24"
    ];
    const colorScale = d3.scaleOrdinal(FACULTY_COLORS);

    // =====================================================
    // ESCALAS
    // =====================================================
    const maxGlobal = Math.max(1,
        d3.max(data.nodesAll || [], d => d.pubs || 0),
        d3.max(data.nodesInternal || [], d => d.pubs || 0)
    );
    const RADIUS_FACTOR = Math.max(1.8, 85 / Math.sqrt(maxGlobal)); // Un factor ligeramente mayor para empujar la campana

    // Aumentamos el tamaño base mínimo drásticamente a 18 para erradicar los nodos diminutos
    function nodeSize(d) { return Math.max(18, Math.sqrt(d.pubs || 1) * RADIUS_FACTOR); }
    function linkWidth(d) { return Math.max(1, Math.sqrt(d.jointPubs || 1) * 2); }
    function nodeColor(d) {
        if (d.external === true) return "#64748b";
        return colorScale(d.group || "Sin grupo");
    }

    // =====================================================
    // ESTADO GLOBAL
    // =====================================================
    let allData = data;
    let currentNodes = [];
    let currentLinks = [];
    let showExternal = false;
    let detailedMode = false;
    let detailedNodeId = null;
    let activeGroupFilter = null;
    let simFrozen = false;
    let selectedNodeId = null;

    // =====================================================
    // ZOOM & PAN
    // =====================================================
    // Aumentamos el umbral para que el texto desaparezca de lejos
    const LABEL_ZOOM_THRESHOLD = 1.1;
    const zoom = d3.zoom()
        .scaleExtent([0.05, 10])
        .on("zoom", (event) => {
            container.attr("transform", event.transform);
            const scale = event.transform.k;
            if (nodeG) {
                nodeG.selectAll(".node-label, .node-label-shadow")
                    .style("font-size", `${Math.min(14, 10 / scale + 4)}px`)
                    .style("opacity", scale >= LABEL_ZOOM_THRESHOLD ? 1 : 0);
            }
        });
    svg.call(zoom);

    // =====================================================
    // FÍSICA
    // =====================================================
    const simulation = d3.forceSimulation()
        .alphaMin(0.01) // Que la simulación tarde más en apagarse
        .alphaDecay(0.01) // Enfriamiento más lento para un viaje suave
        .velocityDecay(0.55) // Más fricción (movimiento más como flotar en agua)
        .force("link", d3.forceLink().id(d => d.id).distance(400).strength(0.35))
        .force("charge", d3.forceManyBody().strength(-800)) // Menos repulsión brutal para evitar caos
        .force("center", d3.forceCenter(width / 2, height / 2).strength(0.025)) // Más gravedad hacia el centro
        .force("forceX", d3.forceX(width / 2).strength(0.12))
        .force("forceY", d3.forceY(height / 2).strength(0.12))
        .force("collide", d3.forceCollide(d => nodeSize(d) + 55).strength(1));

    // ── Tick-based reveal: show the map WHILE it's still moving ──────
    const REVEAL_TICK = 35;   // Mostrar un poco más tarde para que esté más estable
    const TOTAL_EST = 300;  // Estimated total ticks for the progress bar
    let tickCount = 0;
    let overlayDone = false;

    // Quitamos el timeOut estricto de 4 segundos que "frenaba en seco"
    // Ahora dependemos netamente de los ticks físicos de la simulación.

    simulation.on("tick.loader", () => {
        tickCount++;
        // Update loading bar (capped at 92% until overlay hides)
        const pct = Math.min(92, Math.round((tickCount / TOTAL_EST) * 100));
        const bar = document.getElementById("loading-bar");
        if (bar) bar.style.width = pct + "%";

        // Update status text for flavor
        const statusEl = document.getElementById("loading-status");
        if (statusEl) {
            if (tickCount < 15) statusEl.textContent = "Cargando investigadores…";
            else if (tickCount < 30) statusEl.textContent = "Construyendo conexiones…";
            else statusEl.textContent = "Estabilizando red…";
        }

        if (!overlayDone && tickCount >= REVEAL_TICK) {
            overlayDone = true;
            if (bar) bar.style.width = '100%';
            document.querySelectorAll('#cinematic-overlay, #loading-overlay').forEach(function (ov) {
                ov.style.transition = 'opacity 0.8s ease';
                ov.style.opacity = '0';
                ov.style.pointerEvents = 'none';
                setTimeout(function () { ov.style.display = 'none'; }, 900);
            });
            simulation.on('tick.loader', null);
        }
    });

    simulation.on("end", () => {
        // Fallback in case tick count never reached REVEAL_TICK
        if (!overlayDone) {
            overlayDone = true;
            document.querySelectorAll('#cinematic-overlay, #loading-overlay').forEach(function (ov) {
                ov.style.transition = 'opacity 0.8s ease';
                ov.style.opacity = '0';
                ov.style.pointerEvents = 'none';
                setTimeout(function () { ov.style.display = 'none'; }, 900);
            });
        }
        if (!simFrozen) {
            simFrozen = true;
            d3.select("#btn-freeze").text("▶ Reanudar").classed("frozen", true);
        }
    });


    let linkG = container.append("g").attr("class", "links");
    let nodeG = container.append("g").attr("class", "nodes");

    // Initial zoom out to see the whole graph (Moved here so nodeG exists)
    svg.call(zoom.transform, d3.zoomIdentity.translate(width / 2, height / 2).scale(0.35).translate(-width / 2, -height / 2));

    // NOTE: Freeze toggle button removed as simulation auto-freezes efficiently.

    // =====================================================
    // NODE PROFILE SIDEBAR
    // =====================================================
    function openSidebar(d) {
        selectedNodeId = d.id;
        const color = nodeColor(d);

        // Avatar
        d3.select("#node-avatar")
            .style("background", color)
            .text((d.name || "?")[0].toUpperCase());

        d3.select("#node-name").text(d.name || "—");
        d3.select("#node-faculty-badge")
            .text(d.group || "Externo")
            .style("background", color + "22")
            .style("color", color);

        d3.select("#stat-pubs").text(d.pubs || 0);

        // Count connections in the full dataset
        const edgesForNode = (showExternal ? allData.edgesAll : allData.edgesInternal) || [];
        const neighbors = edgesForNode.filter(e => {
            const s = typeof e.source === 'object' ? e.source.id : e.source;
            const t = typeof e.target === 'object' ? e.target.id : e.target;
            return s === d.id || t === d.id;
        });
        d3.select("#stat-connections").text(neighbors.length);

        // Top co-authors sorted by joint pubs
        const sorted = [...neighbors].sort((a, b) => (b.jointPubs || 0) - (a.jointPubs || 0)).slice(0, 8);
        const nodesPool = (showExternal ? allData.nodesAll : allData.nodesInternal) || [];
        const list = d3.select("#coauthor-list");
        list.selectAll(".coauthor-item").remove();

        sorted.forEach(edge => {
            const s = typeof edge.source === 'object' ? edge.source.id : edge.source;
            const t = typeof edge.target === 'object' ? edge.target.id : edge.target;
            const neighborId = s === d.id ? t : s;
            const neighborNode = nodesPool.find(n => n.id === neighborId);
            if (!neighborNode) return;

            list.append("div").attr("class", "coauthor-item")
                .on("click", () => {
                    openSidebar(neighborNode);
                    enterDetailedMode(neighborNode.id);
                })
                .html(`
                    <span class="coauthor-name">${neighborNode.name}</span>
                    <span class="coauthor-count">${edge.jointPubs || 1} pub${(edge.jointPubs || 1) !== 1 ? 's' : ''}</span>
                `);
        });

        d3.select("#node-sidebar").classed("visible", true);
    }

    function closeSidebar() {
        selectedNodeId = null;
        d3.select("#node-sidebar").classed("visible", false);
    }

    d3.select("#sidebar-close").on("click", closeSidebar);
    d3.select("#btn-ego-net").on("click", () => {
        if (selectedNodeId) enterDetailedMode(selectedNodeId);
    });

    // =====================================================
    // HOVER DIMMING
    // =====================================================
    function dimAll(exceptNodeId) {
        const neighborIds = new Set([exceptNodeId]);
        linkG.selectAll(".link").each(function (d) {
            const s = typeof d.source === 'object' ? d.source.id : d.source;
            const t = typeof d.target === 'object' ? d.target.id : d.target;
            if (s === exceptNodeId || t === exceptNodeId) {
                neighborIds.add(s); neighborIds.add(t);
            }
        });
        nodeG.selectAll(".node-group")
            .classed("dimmed", nd => !neighborIds.has(nd.id));
        linkG.selectAll(".link")
            .classed("dimmed", d => {
                const s = typeof d.source === 'object' ? d.source.id : d.source;
                const t = typeof d.target === 'object' ? d.target.id : d.target;
                return !neighborIds.has(s) || !neighborIds.has(t);
            });
    }

    function undimAll() {
        nodeG.selectAll(".node-group").classed("dimmed", false);
        linkG.selectAll(".link").classed("dimmed", false);
    }

    // =====================================================
    // FILTER BAR
    // =====================================================
    function updateFilterBar(nodesArray) {
        const groupCounts = {};
        nodesArray.forEach(n => {
            const grp = n.group || "Sin grupo";
            groupCounts[grp] = (groupCounts[grp] || 0) + 1;
        });
        const sortedGroups = Object.keys(groupCounts).sort((a, b) => groupCounts[b] - groupCounts[a]);
        d3.select("#legend-content").selectAll(".legend-btn").remove();
        const resetBtn = d3.select("#legend-reset-btn");

        sortedGroups.forEach(grp => {
            const color = colorScale(grp);
            const btn = d3.select("#legend-content").insert("button", "#legend-reset-btn")
                .attr("class", "legend-btn")
                .attr("data-group", grp)
                .on("click", function () {
                    const clicked = d3.select(this).attr("data-group");
                    if (activeGroupFilter === clicked) {
                        activeGroupFilter = null;
                        applyGroupFilter(null);
                        d3.selectAll(".legend-btn").classed("active", false)
                            .style("box-shadow", null);
                        resetBtn.style("display", "none");
                    } else {
                        activeGroupFilter = clicked;
                        applyGroupFilter(clicked);
                        d3.selectAll(".legend-btn").classed("active", false)
                            .style("box-shadow", null);
                        d3.select(this).classed("active", true)
                            .style("box-shadow", `0 0 10px ${color}88, 0 0 20px ${color}44`);
                        resetBtn.style("display", "inline-flex");
                    }
                });
            btn.append("span").attr("class", "legend-color-dot").style("background", color);
            btn.append("span").text(`${grp} (${groupCounts[grp]})`);
        });

        resetBtn.on("click", () => {
            activeGroupFilter = null;
            applyGroupFilter(null);
            d3.selectAll(".legend-btn").classed("active", false).style("box-shadow", null);
            resetBtn.style("display", "none");
        });
    }

    function applyGroupFilter(group) {
        nodeG.selectAll(".node-group").transition().duration(300)
            .style("opacity", d => !group ? 1 : (d.group || "Sin grupo") === group ? 1 : 0.06);
        linkG.selectAll(".link").transition().duration(300)
            .style("opacity", d => {
                if (!group) return 0.2; // Reducimos opacidad general de la telaraña (20%)
                const sg = typeof d.source === 'object' ? d.source.group : null;
                const tg = typeof d.target === 'object' ? d.target.group : null;
                return (sg === group || tg === group) ? 0.75 : 0.03;
            });
    }

    // =====================================================
    // RENDER
    // =====================================================
    function render(newNodes, newLinks) {
        currentNodes = newNodes;
        currentLinks = newLinks;

        // -- LINKS --
        let link = linkG.selectAll(".link")
            .data(currentLinks, d => d.id || (
                (typeof d.source === 'object' ? d.source.id : d.source) + "-" +
                (typeof d.target === 'object' ? d.target.id : d.target)
            ));
        link.exit().transition().duration(250).style("opacity", 0).remove();

        let linkEnter = link.enter().append("line")
            .attr("class", "link")
            .attr("stroke", "#334155")
            .attr("stroke-width", d => linkWidth(d))
            .style("opacity", 0)
            .on("click", (e, d) => showEdgeInfo(d))
            .on("mouseover", function (event, d) {
                d3.select(this).attr("stroke", "#38bdf8").style("stroke-opacity", "1").style("opacity", 1);
                hoverTooltip.transition().duration(150).style("opacity", 1);
                hoverTooltip.html(`<strong>${d.jointPubs}</strong> docs compartidos`)
                    .style("left", event.pageX + "px").style("top", (event.pageY - 10) + "px");
            })
            .on("mousemove", event => {
                hoverTooltip.style("left", event.pageX + "px").style("top", (event.pageY - 10) + "px");
            })
            .on("mouseout", function () {
                d3.select(this).attr("stroke", "#334155").style("stroke-opacity", null).style("opacity", 0.2);
                hoverTooltip.transition().duration(400).style("opacity", 0);
            });

        linkEnter.transition().duration(400).style("opacity", 0.2); // Más transparente para evitar caos visual
        link = linkEnter.merge(link);

        // -- NODES --
        let node = nodeG.selectAll(".node-group").data(currentNodes, d => d.id);
        node.exit().transition().duration(250)
            .style("opacity", 0).attr("transform", "scale(0)").remove();

        let nodeEnter = node.enter().append("g")
            .attr("class", "node-group")
            .style("opacity", 0)
            .call(d3.drag()
                .on("start", dragstarted)
                .on("drag", dragged)
                .on("end", dragended))
            .on("click", (event, d) => {
                if (event.defaultPrevented) return;
                infoPanelEl.style("display", "none");
                hoverTooltip.style("opacity", 0);
                openSidebar(d);
            })
            .on("mouseover", function (event, d) {
                dimAll(d.id);
                hoverTooltip.transition().duration(150).style("opacity", 1);
                hoverTooltip.html(`<strong>${d.name}</strong><br><span style="color:#64748b">${d.pubs || 0} coautorías</span>`)
                    .style("left", event.pageX + "px").style("top", (event.pageY - 10) + "px");
            })
            .on("mousemove", event => {
                hoverTooltip.style("left", event.pageX + "px").style("top", (event.pageY - 10) + "px");
            })
            .on("mouseout", function () {
                undimAll();
                hoverTooltip.transition().duration(400).style("opacity", 0);
            });

        // Animated staggered entry
        nodeEnter.transition().duration(600)
            .delay((d, i) => Math.min(i * 2, 400))
            .style("opacity", 1);

        nodeEnter.append("circle").attr("class", "node")
            .attr("r", d => nodeSize(d))
            .attr("fill", d => nodeColor(d));

        nodeEnter.append("text").attr("class", "node-pubs-label")
            .text(d => d.pubs || 0);

        nodeEnter.append("text").attr("class", "node-label-shadow").text(d => d.name);
        nodeEnter.append("text").attr("class", "node-label").text(d => d.name);

        node = nodeEnter.merge(node);
        node.select("circle").attr("r", d => nodeSize(d)).attr("fill", d => nodeColor(d));

        const nameXOffset = d => nodeSize(d) + 4;
        node.select(".node-label-shadow").attr("dx", nameXOffset).attr("dy", -4);
        node.select(".node-label").attr("dx", nameXOffset).attr("dy", -4);

        const currentZoom = d3.zoomTransform(svg.node()).k;
        node.selectAll(".node-label,.node-label-shadow")
            .style("opacity", currentZoom >= LABEL_ZOOM_THRESHOLD ? 1 : 0);

        // Escalar la fuente dinámicamente para que el número exacto encaje dentro del círculo, sin importar qué tan grande sea (ej: "3" o "2500")
        node.select(".node-pubs-label").style("font-size", d => {
            const r = nodeSize(d);
            const chars = String(d.pubs || 0).length;
            // Un factor de escala ligeramente menor (.85) para asegurar que números de 3-4 dígitos entren bien
            return `${Math.max(9, Math.min(24, (r * 1.6) / chars, r * 0.85))}px`;
        });

        // -- PHYSICS TICK --
        simulation.nodes(currentNodes).on("tick", () => {
            link.attr("x1", d => d.source.x).attr("y1", d => d.source.y)
                .attr("x2", d => d.target.x).attr("y2", d => d.target.y);
            node.attr("transform", d => `translate(${d.x},${d.y})`);
        });
        simulation.force("link").links(currentLinks);
        simulation.alpha(1).restart();

        // Auto-center in detailed mode or reset zoom when exiting
        if (detailedMode && detailedNodeId) {
            setTimeout(() => {
                const cn = currentNodes.find(n => n.id === detailedNodeId);
                if (cn && !isNaN(cn.x) && !isNaN(cn.y)) {
                    svg.transition().duration(800).call(zoom.transform,
                        d3.zoomIdentity.translate(width / 2, height / 2).scale(1.0).translate(-cn.x, -cn.y)
                    );
                }
            }, 800);
        } else if (!detailedMode && !detailedNodeId && currentNodes.length > 0) {
            // Restore zoom level smoothly when exiting detailed mode
            svg.transition().duration(800).call(zoom.transform,
                d3.zoomIdentity.translate(width / 2, height / 2).scale(0.3).translate(-width / 2, -height / 2)
            );
        }
    }

    // =====================================================
    // GRAPH PIPELINE
    // =====================================================
    function updateGraph() {
        let nodesData, linksData;
        if (showExternal) {
            // ── OPTION A + CAP: Top 500 external nodes by collaboration weight with UR researchers ──
            const MAX_EXTERNAL_NODES = 100;
            const internalIds = new Set((allData.nodesInternal || []).map(n => n.id));
            const nodesAllMap = {};
            (allData.nodesAll || []).forEach(n => { nodesAllMap[n.id] = n; });

            // Count how many internal links each external node has (collaboration weight)
            const extWeight = {};
            (allData.edgesAll || []).forEach(e => {
                const s = e.source, t = e.target;
                if (internalIds.has(s) && !internalIds.has(t)) {
                    extWeight[t] = (extWeight[t] || 0) + (e.jointPubs || 1);
                }
                if (internalIds.has(t) && !internalIds.has(s)) {
                    extWeight[s] = (extWeight[s] || 0) + (e.jointPubs || 1);
                }
            });

            // Sort by weight descending, take top MAX_EXTERNAL_NODES
            const topExternalIds = Object.entries(extWeight)
                .sort((a, b) => b[1] - a[1])
                .slice(0, MAX_EXTERNAL_NODES)
                .map(([id]) => id);

            const internalNodes = JSON.parse(JSON.stringify(allData.nodesInternal)).map(n => {
                n.external = false; delete n.fx; delete n.fy; return n;
            });
            const externalNodes = topExternalIds
                .map(id => nodesAllMap[id])
                .filter(Boolean)
                .map(n => { const c = JSON.parse(JSON.stringify(n)); c.external = true; return c; });

            nodesData = [...internalNodes, ...externalNodes];

            // Only edges where both endpoints are in the filtered nodesData
            const nodeIdSet = new Set(nodesData.map(n => n.id));
            linksData = JSON.parse(JSON.stringify(allData.edgesAll)).filter(l =>
                nodeIdSet.has(l.source) && nodeIdSet.has(l.target)
            );

        } else {
            nodesData = JSON.parse(JSON.stringify(allData.nodesInternal)).map(n => {
                n.external = false; delete n.fx; delete n.fy; return n;
            });
            linksData = JSON.parse(JSON.stringify(allData.edgesInternal)).filter(l =>
                nodesData.some(n => n.id === l.source) && nodesData.some(n => n.id === l.target)
            );
        }



        if (detailedMode && detailedNodeId) {
            const neighborIds = new Set([detailedNodeId]);
            const detailedLinks = linksData.filter(l =>
                l.source === detailedNodeId || l.target === detailedNodeId ||
                l.source.id === detailedNodeId || l.target.id === detailedNodeId
            );
            detailedLinks.forEach(l => {
                neighborIds.add(typeof l.source === 'object' ? l.source.id : l.source);
                neighborIds.add(typeof l.target === 'object' ? l.target.id : l.target);
            });
            nodesData = nodesData.filter(n => neighborIds.has(n.id));
            linksData = detailedLinks;
            d3.select("#btn-close-detail").style("display", "block");
        } else {
            d3.select("#btn-close-detail").style("display", "none");
        }

        render(nodesData, linksData);
        updateFilterBar(nodesData);
    }

    // =====================================================
    // DETAILED MODE
    // =====================================================
    function enterDetailedMode(nodeId) {
        detailedMode = true; detailedNodeId = nodeId; updateGraph();
    }
    function exitDetailedMode() {
        detailedMode = false; detailedNodeId = null; closeSidebar(); updateGraph();
    }

    d3.select("#btn-close-detail").on("click", exitDetailedMode);

    // =====================================================
    // SEARCH AUTOCOMPLETE
    // =====================================================
    const searchInput = d3.select("#search-input");
    const suggestionsBox = d3.select("#search-suggestions");
    let highlightedIndex = -1;

    function getAllSearchableNodes() {
        return showExternal ? (allData.nodesAll || []) : (allData.nodesInternal || []);
    }

    function renderSuggestions(matches) {
        suggestionsBox.selectAll(".suggestion-item").remove();
        if (!matches.length) { suggestionsBox.style("display", "none"); return; }
        suggestionsBox.style("display", "block");
        highlightedIndex = -1;
        matches.slice(0, 10).forEach(n => {
            suggestionsBox.append("div").attr("class", "suggestion-item")
                .html(`<strong>${n.name}</strong><br><small style="color:#475569">${n.group || ''}</small>`)
                .on("mousedown", e => { e.preventDefault(); selectSuggestion(n); });
        });
    }

    function selectSuggestion(node) {
        searchInput.property("value", node.name);
        suggestionsBox.style("display", "none");
        highlightedIndex = -1;
        openSidebar(node);
        enterDetailedMode(node.id);
    }

    searchInput.on("input", function () {
        const q = this.value.trim().toLowerCase();
        if (!q) { suggestionsBox.style("display", "none"); return; }
        const matches = getAllSearchableNodes()
            .filter(n => n.name && n.name.toLowerCase().includes(q))
            .sort((a, b) => (b.name.toLowerCase().startsWith(q) ? 1 : 0) - (a.name.toLowerCase().startsWith(q) ? 1 : 0));
        renderSuggestions(matches);
    });

    searchInput.on("keydown", function (event) {
        const items = suggestionsBox.selectAll(".suggestion-item").nodes();
        if (event.key === "ArrowDown") {
            event.preventDefault();
            highlightedIndex = Math.min(highlightedIndex + 1, items.length - 1);
            items.forEach((el, i) => el.classList.toggle("active", i === highlightedIndex));
        } else if (event.key === "ArrowUp") {
            event.preventDefault();
            highlightedIndex = Math.max(highlightedIndex - 1, 0);
            items.forEach((el, i) => el.classList.toggle("active", i === highlightedIndex));
        } else if (event.key === "Enter") {
            event.preventDefault();
            if (highlightedIndex >= 0 && items[highlightedIndex]) {
                items[highlightedIndex].dispatchEvent(new Event("mousedown"));
            } else {
                const q = this.value.trim().toLowerCase();
                const found = getAllSearchableNodes().find(n => n.name && n.name.toLowerCase().includes(q));
                if (found) selectSuggestion(found); else alert("Investigador no encontrado.");
            }
        } else if (event.key === "Escape") {
            suggestionsBox.style("display", "none");
        }
    });

    searchInput.on("blur", () => setTimeout(() => suggestionsBox.style("display", "none"), 200));

    d3.select("#search-btn").on("click", () => {
        const q = searchInput.property("value").trim().toLowerCase();
        if (!q) return;
        const found = getAllSearchableNodes().find(n => n.name && n.name.toLowerCase().includes(q));
        found ? selectSuggestion(found) : alert("Investigador no encontrado.");
    });

    // =====================================================
    // EDGE DETAIL PANEL
    // =====================================================
    function showEdgeInfo(d) {
        const src = typeof d.source === 'object' ? d.source.name : d.source;
        const tgt = typeof d.target === 'object' ? d.target.name : d.target;
        d3.select("#info-title").text("Coautoría directa");
        d3.select("#info-content").html(`
            <p style="color:#94a3b8">Entre:</p>
            <p style="color:#f1f5f9;font-weight:600">${src}</p>
            <p style="color:#64748b;margin:2px 0">y</p>
            <p style="color:#f1f5f9;font-weight:600">${tgt}</p>
            <hr style="border:0;border-top:1px solid rgba(255,255,255,0.08);margin:12px 0">
            <p>Publicaciones en común: <span style="color:#38bdf8;font-weight:700;font-size:18px">${d.jointPubs}</span></p>
        `);
        infoPanelEl.style("display", "block");
    }

    // =====================================================
    // MISC CONTROLS
    // =====================================================
    d3.select("#toggle-external").on("change", function () {
        const isChecked = this.checked;

        // Colocar la pantalla de carga (mini-loader)
        const miniLoader = d3.select("body").append("div")
            .attr("id", "mini-toggle-loader")
            .style("position", "absolute").style("top", "50%").style("left", "50%")
            .style("transform", "translate(-50%, -50%)").style("z-index", "9999")
            .style("background", "rgba(15, 23, 42, 0.95)").style("padding", "20px 40px")
            .style("border-radius", "12px").style("color", "#38bdf8").style("border", "1px solid #38bdf8")
            .style("box-shadow", "0 0 30px rgba(0,0,0,0.8)")
            .style("font-family", "system-ui, -apple-system, sans-serif")
            .style("font-size", "18px").style("font-weight", "500")
            .html(`Calculando red de ${isChecked ? 'Externos' : 'Internos'}...`);

        // Retardar el hilo intencionalmente para darle tiempo al navegador a pintar el overlay
        setTimeout(() => {
            showExternal = isChecked;
            closeSidebar();
            updateGraph();
            miniLoader.remove();
        }, 80); // 80ms breathing room
    });

    // Drag
    function dragstarted(event, d) { if (!event.active) simulation.alphaTarget(0.3).restart(); d.fx = d.x; d.fy = d.y; }
    function dragged(event, d) { d.fx = event.x; d.fy = event.y; }
    function dragended(event, d) { if (!event.active) simulation.alphaTarget(0); d.fx = null; d.fy = null; }

    // Legend toggle
    let legendBarOpen = true;
    d3.select("#legend-toggle").on("click", function () {
        legendBarOpen = !legendBarOpen;
        d3.select("#legend-panel").classed("hidden", !legendBarOpen);
        d3.select(this).text(legendBarOpen ? "⌄ Ocultar" : "⌃ Mostrar");
    });

    // =====================================================
    // INIT + RESPONSIVE HANDLERS
    // =====================================================

    // Auto-collapse legend on mobile to avoid covering the map
    if (window.matchMedia("(max-width: 768px)").matches) {
        legendBarOpen = false;
        d3.select("#legend-panel").classed("hidden", true);
        d3.select("#legend-toggle").text("⌃ Mostrar");
    }

    // Recalculate D3 force center when window is resized
    window.addEventListener("resize", () => {
        const w = window.innerWidth;
        const h = window.innerHeight;
        simulation
            .force("center", d3.forceCenter(w / 2, h / 2).strength(0.01))
            .force("forceX", d3.forceX(w / 2).strength(0.12))
            .force("forceY", d3.forceY(h / 2).strength(0.12))
            .alpha(0.3).restart();
    });

    updateGraph();
}
