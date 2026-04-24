<#-- $This file is distributed under the terms of the license in LICENSE$ -->
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- Google Chrome Frame open source plug-in brings Google Chrome's open web technologies and speedy JavaScript engine to Internet Explorer-->
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="generator" content="VIVO ${version.label}" />

<title>${(title?html)!siteName!} WILMA HBC</title>

<#-- VIVO OpenSocial Extension by UCSF -->
<#if openSocial??>
    <#if openSocial.visible>
        <#-- Required to add these BEFORE stylesheets.flt and headScripts.ftl are processed -->
        ${stylesheets.add('<link rel="stylesheet" href="${urls.theme}/css/openSocial/gadgets.css" />')}
        ${headScripts.add('<script type="text/javascript" src="${openSocial.containerJavascriptSrc}"></script>',
                          '<script type="text/javascript" language="javascript">${openSocial.gadgetJavascript}</script>',
                          '<script type="text/javascript" src="${urls.base}/js/openSocial/orng.js"></script>')}
    </#if>
</#if>

${headScripts.add('<script type="text/javascript" src="${urls.base}/webjars/floatingui/floating-ui.core.umd.js"></script>')}
${headScripts.add('<script type="text/javascript" src="${urls.base}/webjars/floatingui/floating-ui.dom.umd.js"></script>')}
${headScripts.add('<script type="text/javascript" src="${urls.base}/js/tooltip/tooltip-utils.js"></script>')}


<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<#include "stylesheets.ftl">
<link rel="stylesheet" href="${urls.theme}/css/screen.css" />
<link rel="stylesheet" href="${urls.theme}/css/header-footer.css" />


<#include "headScripts.ftl">

<#if metaTags??>
    ${metaTags.list()}
</#if>

<link rel="shortcut icon" type="image/x-icon" href="${urls.base}/favicon.ico">
<#--  <link rel="stylesheet" href="${urls.theme}/css/footer-institucional.css" />  -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!--[if (gte IE 6)&(lte IE 8)]>
<script type="text/javascript" src="${urls.base}/js/selectivizr.js"></script>
<![endif]-->

<#-- Inject head content specified in the controller. Currently this is used only to generate an rdf link on
an individual profile page. -->
${headContent!}



