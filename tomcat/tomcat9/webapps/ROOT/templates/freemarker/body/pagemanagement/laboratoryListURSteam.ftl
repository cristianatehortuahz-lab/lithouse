<link rel="stylesheet" href="${urls.base}/themes/wilma/css/estiloLabList.css">

<section id="pageList">
    <#if labs?has_content>
        <#assign espacio = labs>
    </#if>
    <#if spaces?has_content>
        <#assign espacio = spaces>
    </#if>

    <#if espacio?has_content>
        <div id="search-container">
            <input type="text" id="searchLab" placeholder=" Buscar laboratorio por nombre...">
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
        const searchLab = document.getElementById('searchLab');
        const labCards = document.querySelectorAll('.lista_espacios');

        if (searchLab && labCards.length > 0) {
            searchLab.addEventListener('input', function() {
                // Mensaje de depuración en la consola
                console.log('Tecla oprimida. Valor del campo de búsqueda:', searchLab.value);

                const searchTerm = searchLab.value.toLowerCase();

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
        } else {
            console.log("No se encontraron los elementos necesarios para el script.");
        }
    });
</script>
</section>