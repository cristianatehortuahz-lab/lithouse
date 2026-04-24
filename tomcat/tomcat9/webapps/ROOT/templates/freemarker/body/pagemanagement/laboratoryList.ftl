<link rel="stylesheet" href="${urls.base}/themes/wilma/css/estiloLabList.css">

<section id="pageList">
    <#if labs?has_content>
        <#assign espacio = labs>
    </#if>
    <#if spaces?has_content>
        <#assign espacio = spaces>
    </#if>

    <#if espacio?has_content>
        <#-- <div id="search-container">
            <input type="text" id="searchLab" placeholder="Buscar laboratorio por nombre...">
        </div> -->
        
        <#assign programasUnicos = []>
        <#list espacio as lab>
            <#if lab.listedProgram?has_content>
                <#if !programasUnicos?seq_contains(lab.listedProgram)>
                    <#assign programasUnicos = programasUnicos + [lab.listedProgram]>
                </#if>
            </#if>
        </#list>
        

        <div id="filter-container" class="row pb-5">
            <label for="program-select">Filtrar por unidad académica:</label>
            <select id="program-select">
                <option value="all">Todas las unidades</option>
                <#list programasUnicos as programa>
                    <option value="${programa}">${programa}</option>
                </#list>
            </select>
        </div>

        <ul class="row" role="list" id="IDCard">
            <#list espacio as lab>
                <#assign imagenLab = lab.URLimagen!>
                <#assign nameLab = lab.listedLabTitle!>  
                <#assign uriLab = lab.listedLabUri!>
                <#assign programLab = lab.listedProgram!>
                <#assign overviewLab = lab.listoverview!>
                <#assign URIProgramList = lab.URIProgram!>
                <#assign URICraiSalas = lab.UriCraiSalas!>
                <#assign physicalLocation = lab.physicalLocation!>
                <#assign capacity = lab.capacity!>
                <#assign Type = lab.type!"" >
                <#assign sede = lab.sede!>

                <li class="lista_espacios" data-category="${programLab}">
                    <div class="card">
                        <#if imagenLab?has_content>
                            <img src="${urls.base}${imagenLab}" class="card-img-top" alt="${lab.listedLabTitle?string}"/>
                        <#else>
                            <img src="${urls.base}/images/placeholders/sinImagenLab.png" class="card-img-top" />
                        </#if>
                        <div class="card-body">
                            <h5 class="card-title"><a href="${uriLab}">${nameLab}</a></h5>
                            <p class="card-text">
                                <span id="overviewLab" class="card-summary">
                                    ${overviewLab?replace("<p>"," ")?replace("</p>", " ")}  
                                </span>
                                <#if capacity?has_content>
                                   <span id="capacity" class="small d-block"><strong>Capacidad:</strong> ${capacity} personas</span>
                                </#if>
                                <#if physicalLocation?has_content>
                                   <span id="physicalLocation" class="small d-block"><strong>Ubicación:</strong> ${physicalLocation}</span>
                                </#if>
                                <#if sede?has_content>
                                   <span id="sede" class="small d-block"><strong>Sede:</strong> ${sede}</span>
                                </#if>
                                <#if programLab?has_content>
                                <span class="card-program small d-block">
                                    <a href="${URIProgramList}">${programLab}</a>
                                </span>
                                </#if>
                            </p>
                            <#if URICraiSalas?has_content>
                                <a href="${URICraiSalas}" class="btn btn-primary" target="_blank">AGENDAR</a>
                            </#if>
                        </div>
                    </div>
                </li>
            </#list>
        </ul>
    <#else>
        <div><h1>No tiene contenido</h1></div>
    </#if> 
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.getElementById('searchLab');
            const labCards = document.querySelectorAll('.lista_espacios');
        // Nuevo selector para el menú desplegable
        const programSelect = document.getElementById('program-select');

            // Lógica de filtrado por búsqueda de texto
            if (searchInput) {
            searchInput.addEventListener('input', function() {
                const searchTerm = searchInput.value.toLowerCase();
        // Si el usuario escribe, resetea la selección del desplegable
        if (programSelect) {
        programSelect.value = 'all';
        }

                labCards.forEach(card => {
                const titleElement = card.querySelector('.card-title a');
                const labTitle = titleElement ? titleElement.textContent.toLowerCase() : '';

                if (labTitle.includes(searchTerm)) {
                    card.style.display = ''; 
                } else {
                    card.style.setProperty('display', 'none', 'important');
                }
                });
            });
            }

            // Lógica de filtrado por selección de programa
            if (programSelect) {
            programSelect.addEventListener('change', function() {
                const filterValue = this.value;

                // Limpia el campo de búsqueda al seleccionar una opción
                if (searchInput) {
                searchInput.value = '';
                }

                labCards.forEach(card => {
                const cardCategory = card.getAttribute('data-category');
                if (filterValue === 'all' || cardCategory === filterValue) {
                    card.style.display = '';
                } else {
                    card.style.setProperty('display', 'none', 'important');
                }
                });
            });
            }
        });
    </script>
</section>
<style>
    div#filter-container {
        font-size: 1rem !important;
    }
    
</style>