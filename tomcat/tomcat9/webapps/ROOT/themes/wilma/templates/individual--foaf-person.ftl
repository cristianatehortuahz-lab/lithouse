<#-- $This file is distributed under the terms of the license in LICENSE$ -->

<#--
    Individual profile page template for foaf:Person individuals. This is the default template for foaf persons
    in the Wilma theme and should reside in the themes/wilma/templates directory.
-->

<#include "individual-setup.ftl">
<#import "lib-vivo-properties.ftl" as vp>
<#import "individual-qrCodeGenerator.ftl" as qr>

<#--Number of labels present-->
 <#if !labelCount??>
     <#assign labelCount = 0 >
 </#if>
<#--Number of available locales-->
 <#if !localesCount??>
   <#assign localesCount = 1>
 </#if>
<#--Number of distinct languages represented, with no language tag counting as a language, across labels-->
<#if !languageCount??>
  <#assign languageCount = 1>
</#if>
<#assign qrCodeIcon = "qr-code-icon.png">
<#assign visRequestingTemplate = "foaf-person-wilma">

<#--add the VIVO-ORCID interface -->
<#include "individual-orcidInterface.ftl">

<div class="row" id="person-info">
	<div class="col-md-3 col-sm-4 col-xs-12">
        <section id="individual-intro" class="vcard person" role="region">
            <section id="share-contact" role="region">
                <!-- Image -->
                <#assign individualImage>
                    <@p.image individual=individual
                            propertyGroups=propertyGroups
                            namespaces=namespaces
                            editable=editable
                            showPlaceholder="always" />
                </#assign>
                <#if ( individualImage?contains('<img class="img-circle">') )>
                            <#assign infoClass='class="withThumb"' />
                        </#if>
                <div id="photo-custom-person-wrapper">
                    ${individualImage}
                </div>
                
                <#--  <#if ( individualImage?contains('<img class="individual-photo"') )>
                    <#assign infoClass = 'class="withThumb"'/>
                </#if>  
                <div id="photo-wrapper">${individualImage}</div>
                -->

                <#include "individual-custom-identities.ftl">
                <section id="concat">
                    <#include "individual-custom-contactInfo.ftl">
                    <#include "individual-custom-webpage.ftl">
                </section>
                
                <#--  <#include "individual-contactInfo.ftl">  -->

                <!-- Websites -->
                <#--  <#include "individual-webpage.ftl">  -->
            </section>
        </section>
    </div>
    
    <div class="col-md-9 col-sm-8 col-xs-12">
        <section id="individual-info" ${infoClass!} role="region">
            <#include "individual-adminPanel.ftl">
            <header>
                <#if relatedSubject??>
                    <h2>
                        ${relatedSubject.relatingPredicateDomainPublic} ${i18n().indiv_foafperson_for} ${relatedSubject.name}
                    </h2>
                    <p>
                        <a href="${relatedSubject.url}" title="${i18n().indiv_foafperson_return}">&larr; ${i18n().indiv_foafperson_return} ${relatedSubject.name}
                        </a>
                    </p>
                <#else>

                    <section class="header-section">
                        <h1 class="foaf-person">
                            <#-- Label -->
                            <span itemprop="name" class="fn"><@p.label individual editable labelCount localesCount languageCount /></span>
                        </h1>
                        <div id="individual-tools-people" class="tools-right">
                            <span id="iconControlsLeftSide">
                                <#--  <img id="uriIcon" title="${individual.uri}" src="${urls.images}/individual/uriIcon.gif" alt="${i18n().uri_icon}"/>  -->

                                <#if checkNamesResult?has_content >
                                    <div class="export-qr d-flex">
                                        <span class="export-qr-code">${i18n().export_qr_code} <em>(<a href="/about_qrcode" title="${i18n().more_qr_info}">?<#--  ${i18n().what_is_this}  --></a>)</em></span>
                                        <img id="qrIcon"  src="${urls.images}/individual/qr_icon.png" alt="${i18n().qr_icon}" />
                                        <span id="qrCodeImage" class="hidden">${qrCodeLinkedImage!}
                                            <a class="qrCloseLink" href="#"  title="${i18n().qr_code}">${i18n().close_capitalized}</a>
                                        </span>
                                    </div>
                                </#if>
                            </span>
                        </div>
                    </section>
                </#if>
            </header>
                <!-- Positions -->
                <#include "individual-custom-positions.ftl">
            
            <#include "individual-custom-researchAreas.ftl">
            <#include "individual-openSocial.ftl">
        </section>
    </div>
</div>

<div class="separate " style="background-color: #FFF;margin:auto ;">
    <#assign nameForOtherGroup="${i18n().other}">
	<#-- Ontology properties -->
	<#if !editable>
		<#assign skipThis=propertyGroups.pullProperty("http://xmlns.com/foaf/0.1/firstName")!>
		<#assign skipThis=propertyGroups.pullProperty("http://xmlns.com/foaf/0.1/lastName")!>
	</#if>
</div>
<#include "individual--foaf-person-property-group-tabs.ftl">


    

<#assign rdfUrl = individual.rdfUrl>

<#if rdfUrl??>
    <script>
        var individualRdfUrl = '${rdfUrl}';
    </script>
</#if>
<script>
    var imagesPath = '${urls.images}';
	var individualUri = '${individual.uri!}';
	var individualPhoto = '${individual.thumbNail!}';
	var exportQrCodeUrl = '${urls.base}/qrcode?uri=${individual.uri!}';
	var baseUrl = '${urls.base}';
    var i18nStrings = {
        displayLess: '${i18n().display_less?js_string}',
        displayMoreEllipsis: '${i18n().display_more_ellipsis?js_string}',
        showMoreContent: '${i18n().show_more_content?js_string}',
        verboseTurnOff: '${i18n().verbose_turn_off?js_string}',
        exportQrCodes: '${i18n().export_qr_codes?js_string}',
        researchAreaTooltipOne: '${i18n().research_area_tooltip_one?js_string}',
        researchAreaTooltipTwo: '${i18n().research_area_tooltip_two?js_string}'
    };
    var i18nStringsUriRdf = {
        shareProfileUri: '${i18n().share_profile_uri?js_string}',
        viewRDFProfile: '${i18n().view_profile_in_rdf?js_string}',
        closeString: '${i18n().close?js_string}'
    };
</script>

<#-- Scripts y Estilos movidos o diferidos para Performance 100/100 -->
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/css/individual/individual.css" />',
                  '<link rel="stylesheet" href="${urls.base}/css/individual/individual-vivo.css" />',
                  '<link rel="stylesheet" href="${urls.base}/webjars/jquery-ui-themes/smoothness/jquery-ui.min.css" />',
                  '<link rel="stylesheet" href="${urls.base}/themes/wilma/css/individual-foaf-person.css" />')}

${scripts.add('<script defer type="text/javascript" src="${urls.base}/js/tiny_mce/tiny_mce.js"></script>',
              '<script defer type="text/javascript" src="${urls.base}/js/jquery_plugins/jquery.truncator.js"></script>',
              '<script defer type="text/javascript" src="${urls.base}/js/individual/individualUtils.js"></script>',
              '<script defer type="text/javascript" src="${urls.base}/js/individual/individualTooltipBubble.js"></script>',
              '<script defer type="text/javascript" src="${urls.base}/js/individual/individualUriRdf.js"></script>',
			  '<script defer type="text/javascript" src="${urls.base}/js/individual/moreLessController.js"></script>',
              '<script defer type="text/javascript" src="${urls.base}/webjars/jquery-ui/jquery-ui.min.js"></script>',
              '<script defer type="text/javascript" src="${urls.base}/js/imageUpload/imageUploadUtils.js"></script>',
              '<script async defer type="text/javascript" src="https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js"></script>',
              '<script async defer type="text/javascript" src="//cdn.plu.mx/widget-popup.js"></script>')}