<#if temporalVisualizationEnabled || mapOfScienceVisualizationEnabled>
    <#assign classSpecificExtension>
        <section id="right-hand-column" role="region">
            <#if temporalVisualizationEnabled>
                <#include "individual-visualizationTemporalGraph.ftl">
            </#if>
            <#if mapOfScienceVisualizationEnabled>
                <#include "individual-visualizationMapOfScience.ftl">
            </#if>
        </section> <!-- #right-hand-column -->
    </#assign>
</#if>



<#if individual.mostSpecificTypes?seq_contains("Academic Department") && getGrantResults?has_content>
    <#assign departmentalGrantsExtension>    
        <div id="activeGrantsLink">
        <img src="${urls.base}/images/individual/arrow-green.gif">
            <a href="${urls.base}/deptGrants?individualURI=${individual.uri}" title="${i18n().view_all_active_grants}">
                ${i18n().view_all_active_grants}
            </a>    
        </div>
    </#assign>
</#if>

<#-- $This file is distributed under the terms of the license in LICENSE$ -->

<#-- Default VIVO individual profile page template (extends individual.ftl in vitro) -->

<#include "individual-setup.ftl">
<#import "lib-vivo-properties.ftl" as vp>

<#assign individualImage>
    <section id="ADphotoOrganization">
        <@p.image individual=individual
        propertyGroups=propertyGroups
        namespaces=namespaces
        editable=editable
        showPlaceholder="with_add_link" />
    </section>
</#assign>

<#assign individualProductExtensionPreHeader>
    <#include "individual-altmetric.ftl">
    <#-- <#include "individual-plum.ftl"> -->
</#assign>

<#assign individualProductExtensionOverView>
    <section id="ADindividualOverview">
        <#include "individual-overview.ftl">
    </section>
</#assign>

<#assign individualProductDepartAdmin>
    <section id="ADindividualPersonAdmin">
        <#include "individualDeparmentPersonAdmin.ftl">
    </section>
</#assign>

<#assign individualProductDepartProfesor>
    <section id="ADindividualPersonProfesor">
        <h2>Profesores e Investigadores</h2>
        <#include "individualDeparmentPersonProfesor.ftl">
        <#--  <#include "individualDeparmentPersonProfesorDesplegable.ftl">      -->
    </section>
</#assign>

<#assign individualProductExtension>
    <section id="ADpaginaWEB">
        <#include "individual-webpage.ftl">
    </section>
</#assign>

<#assign individualcontac>
    <section id="ADContact">
        <#include "individual-contact.ftl">
    </section>
</#assign>

<#assign affiliatedResearchAreas>
    <section id="ADkeywords">
        <#include "individual-affiliated-research-areas.ftl">
    </section>
</#assign>

<#assign individualSearchGroup>
    <section id="ADSearchGroup">
        <#include "individualDeparmentSearchGroup.ftl">
    </section>
</#assign>

<#--  APR crea assign de estadisticos  -->
<#assign stadisticos>
     <#-- Include for any class specific template additions -->
    ${classSpecificExtension!}
    ${departmentalGrantsExtension!}
</#assign>

<#if individual.conceptSubclass() >
    <#assign overview = propertyGroups.pullProperty("http://www.w3.org/2004/02/skos/core#broader")!>
    <#assign overview = propertyGroups.pullProperty("http://www.w3.org/2004/02/skos/core#narrower")!>
    <#assign overview = propertyGroups.pullProperty("http://www.w3.org/2004/02/skos/core#related")!>

</#if>

<#--  <#assign tipoOrganization = propertyGroups.pullProperty(http://www.w3.org/2004/02/skos/core#narrower)!>  -->

<#include "individual-vitro-AcademicDepartment.ftl">


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
console.log(individualUri);
console.log(i18nStrings);

var i18nStrings = {
    displayLess: '${i18n().display_less}',
    displayMoreEllipsis: '${i18n().display_more_ellipsis}',
    showMoreContent: '${i18n().show_more_content}',
    verboseTurnOff: '${i18n().verbose_turn_off}',
};
console.log("Individual");
    console.log(url);
    console.log(vclassName);
    console.log(results);
    console.log(VURI);

</script>

<#--  ${stylesheets.add('<link rel="stylesheet" href="${urls.base}/css/individual/individual-vivo.css" />')}

${headScripts.add('<script type="text/javascript" src="${urls.base}/js/jquery_plugins/jquery.truncator.js"></script>')}
${scripts.add('<script async type="text/javascript" src="${urls.base}/js/individual/individualUtils.js"></script>')}
${scripts.add('<script async type="text/javascript" src="//cdn.plu.mx/widget-popup.js"></script>')}  -->

${scripts.add(<#--'<script async type="text/javascript" src="https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js"></script>' altmetrics script-->)}


${stylesheets.add('<link rel="stylesheet" href="${urls.base}/css/individual/individual.css" />',
                  '<link rel="stylesheet" href="${urls.base}/css/individual/individual-vivo.css" />',
                  '<link rel="stylesheet" href="${urls.base}//themes/wilma/css/academicDeparment.css" />',
                  '<link rel="stylesheet" href="${urls.base}/js/jquery-ui/css/smoothness/jquery-ui-1.12.1.css" />')}

${headScripts.add('<script type="text/javascript" src="${urls.base}/js/tiny_mce/tiny_mce.js"></script>',
                  '<script type="text/javascript" src="${urls.base}/js/jquery_plugins/qtip/jquery.qtip.min.js"></script>',
                  '<script type="text/javascript" src="${urls.base}/js/jquery_plugins/jquery.truncator.js"></script>')}

${scripts.add('<script type="text/javascript" src="${urls.base}/js/individual/individualUtils.js"></script>',
              '<script type="text/javascript" src="${urls.base}/js/individual/individualQtipBubble.js"></script>',
              '<script type="text/javascript" src="${urls.base}/js/individual/individualUriRdf.js"></script>',
			  '<script type="text/javascript" src="${urls.base}/js/individual/moreLessController.js"></script>',
              '<script type="text/javascript" src="${urls.base}/js/jquery-ui/js/jquery-ui-1.12.1.min.js"></script>',
              '<script type="text/javascript" src="${urls.base}/js/imageUpload/imageUploadUtils.js"></script>',
              <#-- '<script type="text/javascript" src="https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js"></script>', altmetrics script -->
	      	  '<script type="text/javascript" src="//d39af2mgp1pqhg.cloudfront.net/widget-popup.js"></script>')}

<script type="text/javascript">
    i18n_confirmDelete = "${i18n().confirm_delete?js_string}";
</script>