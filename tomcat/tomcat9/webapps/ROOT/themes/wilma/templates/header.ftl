<header id="branding" role="banner">
    <#include "developer.ftl">
        <div class="header-container">
            <h1 class="logo-ur">
                <a title="${i18n().identity_title}" href="https://urosario.edu.co/" target="_blank">
                    <img class="header-icon" src="${urls.base}/themes/wilma/images/header/logoUR.webp" alt="" width="200" height="50">
                    <span class="displace">
                        ${siteName}
                    </span>
                </a>
                <hr class="lineaVertical">
                <a title="${i18n().identity_title}" href="https://research-hub.urosario.edu.co/">
                    <img class="header-icon-HUB" src="${urls.base}/themes/wilma/images/header/logoHUB.webp" alt="" width="150" height="50">
                    <span class="displace">
                        ${siteName}
                    </span>
                </a>
            </h1>
            <#if user.loggedIn>
                <div class="user-menu">
                    <#-- COMMENTING OUT THE EDIT PAGE LINK FOR RELEASE 1.5. WE NEED TO IMPLEMENT THIS IN A MORE
                        USER FRIENDLY WAY. PERHAPS INCLUDE A LINK ON THE PAGES THEMSELVES AND DISPLAY IF THE
                        USER IS A SITE ADMIN. tlw72
                        <#if (page??) && (page?is_hash || page?is_hash_ex) && (page.URLToEditPage??)>
                        <li role="listitem"><a href="${page.URLToEditPage}" title="${i18n().identity_edit}">
                                ${i18n().identity_edit}
                            </a></li>
                        </#if>
                        -->
                    <#if user.hasSiteAdminAccess>
                        <li role="listitem">
                            <a href="${urls.siteAdmin}" title="${i18n().identity_admin}">${i18n().identity_admin}</a>
                        </li>
                    </#if>

                    <#if user.hasSiteAdminAccess>
                        <#--  <li role="listitem">
                            <div class="language" id="navbarLanguage">  -->
                                <#include "languageSelector.ftl">
                            <#--  </div>
                        </li>  -->
                    </#if>
                
                    <li role="listitem">
                        <ul class="dropdown">
                            <li id="user-menu">
                                <a href="#" title="${i18n().identity_user}">${user.loginName}</a>
                                <ul class="sub_menu">
                                    <#if user.hasProfile>
                                        <li role="listitem">
                                            <a href="${user.profileUrl}" title="${i18n().identity_myprofile}"> ${i18n().identity_myprofile}</a>
                                        </li>
                                    </#if>
                                    <#if urls.myAccount??>
                                        <li role="listitem">
                                            <a href="${urls.myAccount}" title="${i18n().identity_myaccount}">${i18n().identity_myaccount}</a>
                                        </li>
                                    </#if>
                                    <li role="listitem">
                                        <a href="${urls.logout}" title="${i18n().menu_logout}"> ${i18n().menu_logout}</a>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                    ${scripts.add('<script type="text/javascript" src="${urls.base}/js/userMenu/userMenuUtils.js"></script>')}
                </div>
            </#if>
        </div>
        <nav class="navbar navbar-expand-lg" id="branding">
            <div class="container-fluid ">
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Abrir/Cerrar menú de navegación">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                        <#list menu.items as item>
                            <li class="nav-item" role="listitem">
                                <a href="${item.url}" title="${item.linkText} ${i18n().menu_item}" class="nav-link active" aria-current="page">
                                    ${item.linkText}
                                </a>
                            </li>
                        </#list>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                Mapas <i class="fa fa-chevron-down"></i>
                            </a>
                            <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                <li>
                                    <a class="dropdown-item item" href="/vis/capabilitymap">
                                        Mapa de capacidades
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item item" href="/coauthorNetwork">
                                        Mapa de coautorías
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </ul>
                    <#if isHomePage?? && isHomePage>
                        <#-- //do nothing -->
                            <#else>
                                <form class="nav-search-from d-flex" role="search" action="${urls.search}" method="GET">
                                    <label for="searchInput" class="visually-hidden">Buscar en el sitio</label>
                                    <input class="form-control me-2" type="search" placeholder="Buscar..." aria-label="Buscar en el sitio" id="searchInput" name="querytext" autocapitalize="off">
                                    <input type="hidden" name="filters_category" value="" autocapitalize="off" />
                                    <button class="btn btn-outline-success" type="submit">
                                        ${i18n().search_button}
                                    </button>
                                </form>
                    </#if>
                </div>
            </div>
        </nav>
        <script>
        document.addEventListener("DOMContentLoaded", function() {
            if (window.location.pathname === "/" || window.location.pathname.includes("home")) {
                const elemento = document.querySelector(".nav-search-from");
                if (elemento) {
                    elemento.style.display = "none";
                }
            }
        });
        </script>
</header>
