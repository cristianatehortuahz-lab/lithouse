<header>
    <#include "developer.ftl">       
    <nav class="navbar navbar-expand-lg" id="branding" role="banner">
        <div class="container-fluid logo-ur">
            <a title="${i18n().identity_title}" href="http://www.urosario.edu.co/"><img class="header-icon" src="${urls.base}/themes/wilma/images/VIVO-logo.png" alt=""><span class="displace">${siteName}</span></a>

            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Abrir/Cerrar menú de navegación">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <!-- <div class="language" id="navbarLanguage">
                    <#include "languageSelector.ftl">
                </div>  -->
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <#list menu.items as item>
                        <li class="nav-item" role="listitem">
                            <a href="${item.url}" title="${item.linkText} ${i18n().menu_item}"  class="nav-link active" aria-current="page">${item.linkText}</a>
                        </li>
                    </#list>
                </ul>

                <form class="d-flex" role="search">
                    <label for="searchInput" class="visually-hidden">Buscar en el sitio</label>
                    <input class="form-control me-2" type="search" placeholder="Buscar..." aria-label="Buscar en el sitio" id="searchInput" name="q">
                    <button class="btn btn-outline-success" type="submit">Buscar</button>
                </form>
            </div>
        </div>
    </nav>
    
</header>
 