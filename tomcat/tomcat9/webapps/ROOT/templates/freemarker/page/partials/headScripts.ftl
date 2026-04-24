<#ftl encoding="UTF-8">
<#-- $This file is distributed under the terms of the license in LICENSE$ -->

<#-- script for enabling new HTML5 semantic markup in IE browsers -->
<!--[if lt IE 9]>
<script type="text/javascript" src="${(urls.base)!""}/js/html5.js"></script>
<![endif]-->

<script>
    <#assign allCap = "All">
    <#if i18n?? && i18n().all_capitalized??><#assign allCap = i18n().all_capitalized></#if>
    var i18nStrings = { allCapitalized: '${allCap?js_string}' };
</script>

${headScripts.list()}
