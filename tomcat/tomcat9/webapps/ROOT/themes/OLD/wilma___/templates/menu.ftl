<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#include "developer.ftl">
    <div class="collapse navbar-collapse navbar-left" id="navbarContent">
        <ul id="main-nav" role="list">
            <#list menu.items as item>
                <#--  <li class="nav-item" role="listitem" <#if item.active> class="active" </#if>><a href="${item.url}" title="${item.linkText} ${i18n().menu_item}" class="nav-link">${item.linkText}</a></li>  -->
                <li role="listitem">
                    <a href="${item.url}" title="${item.linkText} ${i18n().menu_item}" <#if item.active> class="selected" </#if>>${item.linkText}</a>
                </li>
            </#list>
        </ul>
    </div>
    <div class="language" id="navbarLanguage">
        <#include "languageSelector.ftl">
    </div>