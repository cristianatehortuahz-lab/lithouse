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

<div class="rowDepartment" id="organizationInf">
    <section id="generalDeparment">
        <section id="identityDeparment">
        <#-- Imagen -->
            
            <#if ( individualImage?contains('<img class="individual-photo"') )>
                <#assign infoClass = 'class="withThumb"'/>
            </#if>
            
            <#if individualImage??>
                ${individualImage}
            </#if>

                <#--  Productoaltimectric  -->
            <#if individualProductExtensionPreHeader??>
                ${individualProductExtensionPreHeader}
            </#if>

            <#if individualProductExtension??>
                ${individualProductExtension}
            </#if>

            <#--  paginaWEB  -->
            <#include "individual-openSocial.ftl">

            <#if individualcontac??>
                ${individualcontac}
            </#if>

        </section>

        <section id="principalDeparment">

            <#if relatedSubject??>
                <h2>${relatedSubject.relatingPredicateDomainPublic} for ${relatedSubject.name}</h2>
                <p><a href="${relatedSubject.url}" title="${i18n().return_to(relatedSubject.name)}">&larr; ${i18n().return_to(relatedSubject.name)}</a></p>
            <#else>
                <h1 class="fn" itemprop="name">
                    <#-- Label -->
                    <@p.label individual editable labelCount localesCount languageCount/>

                    <#--  Most-specific types -->
                    <#--  <@p.mostSpecificTypes individual />  -->
                    <!-- span id="iconControlsVitro"><img id="uriIcon" title="${individual.uri}" class="middle" src="${urls.images}/individual/uriIcon.gif" alt="uri icon"/></span -->
                </h1>
            </#if>

            <#if individualProductExtensionOverView??>
                ${individualProductExtensionOverView!}
            </#if>
            
            <#if individualProductDepartAdmin??>
                ${individualProductDepartAdmin!}
            </#if>
        </section>
    </section>
    <hr>

    <#--  <section id = "keyWordsDeparment">
         <#if affiliatedResearchAreas??>
            ${affiliatedResearchAreas!}
        </#if>
    </section>   -->

    <#--  Agrega los grupos pertenecientes al departamento  -->
    <section id = "SearchGroupDeparment">
         <#if individualSearchGroup??>
            ${individualSearchGroup!}
        </#if>
    </section>     

    <hr>
    
    <section id = "shortViewDeparmentPeople">
        <#if individualProductDepartProfesor??>
            ${individualProductDepartProfesor!}
        </#if>
    </section>

    <hr>
    
    <section id="left-colum">         
        <section id="menufiltro">
            <#assign nameForOtherGroup = "${i18n().other}">
            <#-- Ontology properties -->
            <#if !editable>
                <#-- We don't want to see the first name and last name unless we might edit them. -->
                <#assign skipThis = propertyGroups.pullProperty("http://xmlns.com/foaf/0.1/firstName")!>
                <#assign skipThis = propertyGroups.pullProperty("http://xmlns.com/foaf/0.1/lastName")!>
            </#if>

                
            <#include "individual-property-group-tabs-AcademicDeparment.ftl">
            <#--  <#include "individual--foaf-person-property-group-tabs.ftl">  -->
        </section>   
    </section>
</div>

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
                  '<link rel="stylesheet" type="text/css" href="${urls.base}/css/jquery_plugins/qtip/jquery.qtip.min.css" />',
                  '<link rel="stylesheet" href="${urls.base}/themes/wilma/css/academicDeparment.css" />')}

${headScripts.add('<script type="text/javascript" src="${urls.base}/js/jquery_plugins/qtip/jquery.qtip.min.js"></script>',
                  '<script type="text/javascript" src="${urls.base}/js/tiny_mce/tiny_mce.js"></script>')}

${scripts.add('<script type="text/javascript" src="${urls.base}/js/imageUpload/imageUploadUtils.js"></script>',
	          <#--  '<script type="text/javascript" src="${urls.base}/js/individual/moreLessController.js"></script>',  -->
              '<script type="text/javascript" src="${urls.base}/js/individual/individualUriRdf.js"></script>')}


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
        contact.style.display="none";
    }
</script>
