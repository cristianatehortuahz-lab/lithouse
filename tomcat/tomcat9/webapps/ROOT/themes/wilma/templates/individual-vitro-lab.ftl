

<#-- $This file is distributed under the terms of the license in LICENSE$ -->
<#import "lib-microformats.ftl" as mf>

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

<#-- Default individual profile page template -->
<#--@dumpAll /-->
<#include "individual-adminPanel.ftl">

<div class="organizationInfLab">

    <section id=tituloLab>
         <!-- start section individual-info -->
        <section id="individual-infoOrga-Lab" ${infoClass!} role="region">
            <#-- Build URL Image -->
            <#assign individualImage>
            <@p.image individual=individual
                propertyGroups=propertyGroups
                namespaces=namespaces
                editable=editable
                showPlaceholder="with_add_link" />
            </#assign>

            <#if ( individualImage?contains('<img class="individual-photo"') )>
                <#assign infoClass = 'class="withThumb"'/>
                ${individualImage}
            <#else>
                <a href="/images/placeholders/thumbnail.jpg" title="Foto del usuario">
        	        <img class="individual-photo" src="/images/placeholders/thumbnail.jpg" title="no se ha cargado imagen">
                </a>
            </#if>

            <#--  ${individualImage}  -->
        </section>
        <#if contactInf??>
            ${contactInf}
        </#if>
        <#if placeLaboratory??>
            ${placeLaboratory}
        </#if>
    </section>

    <section id="individual-intro-Lab" class="vcard clearfix" role="region" <@mf.sectionSchema individual/>>
        <#if relatedSubject??>
            <h2>${relatedSubject.relatingPredicateDomainPublic} for ${relatedSubject.name}</h2>
            <p><a href="${relatedSubject.url}" title="${i18n().return_to(relatedSubject.name)}">&larr; ${i18n().return_to(relatedSubject.name)}</a></p>
        <#else>
            <h1 class="nameLab" itemprop="name">
                <#-- Label -->
                <@p.label individual editable labelCount localesCount languageCount/>

                <#--  Most-specific types -->
                <#--  se oculta el labCore  -->
                <#--  <@p.mostSpecificTypes individual />  -->
                <!-- span id="iconControlsVitro"><img id="uriIcon" title="${individual.uri}" class="middle" src="${urls.images}/individual/uriIcon.gif" alt="uri icon"/></span -->
            </h1>
        </#if>

         <#--  overview  -->
        <#if individualProductExtensionOverView??>
            ${individualProductExtensionOverView}
        </#if>
        <section class="keywordAgenda">

             <#-- ++++++++++++show keyword of laboratory++++++++++++++ -->
            <#if individualKeyWord??>
                ${individualKeyWord}
            </#if>
            <#--  ============Agendamiento=================      -->
            <#if agendaLaboratory??>
                ${agendaLaboratory}
            </#if>

        </section>
        
                
    </section> <!-- individual-intro-Lab -->
    
</div>

<div id="menufiltro">
        <#assign nameForOtherGroup = "${i18n().other}">
        <#-- Ontology properties -->
        <#if !editable>
            <#-- We don't want to see the first name and last name unless we might edit them. -->
            <#assign skipThis = propertyGroups.pullProperty("http://xmlns.com/foaf/0.1/firstName")!>
            <#assign skipThis = propertyGroups.pullProperty("http://xmlns.com/foaf/0.1/lastName")!>
        </#if>

        
        <!-- Property group menu or tabs -->
        <#--
            With release 1.6 there are now two types of property group displays: the original property group
            menu and the horizontal tab display, which is the default. If you prefer to use the property
            group menu, simply substitute the include statement below with the one that appears after this
            comment section.

            <#include "individual-property-group-menus.ftl">
        -->
        <#--  <#include "individual-property-group-menus.ftl">  -->
        <#include "individual-property-group-tabs-Lab.ftl">
</div>  <#-- ===============fin menu filtro========================== -->

<#assign rdfUrl = individual.rdfUrl>

<#if rdfUrl??>
    <script>
        var individualRdfUrl = '${rdfUrl}';
    </script>
</#if>
<script>
    var i18nStringsUriRdf = {
        shareProfileUri: '${i18n().share_profile_uri}',
        viewRDFProfile: '${i18n().view_profile_in_rdf}',
        closeString: '${i18n().close}'
    };
	var i18nStrings = {
	    displayLess: '${i18n().display_less}',
	    <#--  displayMoreEllipsis: '${i18n().display_more_ellipsis}',  -->
        displayMoreEllipsis: '${i18n().display_more_ellipsis?js_string}',
        showMoreContent: '${i18n().show_more_content?js_string}'
	    <#--  showMoreContent: '${i18n().show_more_content}',  -->
	};

    var individualLocalName = "${individual.localName}";
</script>

${stylesheets.add('<link rel="stylesheet" href="${urls.base}/css/individual/individual.css" />',
                  '<link rel="stylesheet" type="text/css" href="${urls.base}/css/jquery_plugins/qtip/jquery.qtip.min.css" />'
                  '<link rel="stylesheet" href="${urls.base}/themes/wilma/css/perfilLab.css" />')}

${headScripts.add('<script type="text/javascript" src="${urls.base}/js/jquery_plugins/qtip/jquery.qtip.min.js"></script>',
                  '<script type="text/javascript" src="${urls.base}/js/tiny_mce/tiny_mce.js"></script>')}

${scripts.add('<script type="text/javascript" src="${urls.base}/js/imageUpload/imageUploadUtils.js"></script>'
	          <#--  '<script type="text/javascript" src="${urls.base}/js/individual/moreLessController.js"></script>',  -->
              <#--  '<script type="text/javascript" src="${urls.base}/js/individual/individualUriRdf.js"></script>'  -->
              )}

<script type="text/javascript">
    i18n_confirmDelete = "${i18n().confirm_delete}";
</script>

<script>
    var photo,a,contact;
    photo = document.getElementById("photo-wrapper");
    a = photo.getElementsByTagName("a");

    if (a.length<1){
        console.log(a.length);
        contact = document.getElementById("share-contact");
        contact.style.display="none";}
</script>
