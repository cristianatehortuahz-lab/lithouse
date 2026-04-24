<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#--
    Individual profile page template for foaf:Person individuals. This is the default template for foaf persons
    in the Wilma theme and should reside in the themes/wilma/templates directory.
-->

<#include "individual-setup.ftl">
<#import "lib-vivo-properties.ftl" as vp>
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
<#assign visRequestingTemplate = "foaf-person-wilma">

<#--add the VIVO-ORCID interface -->
<#include "individual-orcidInterface.ftl">

<!--<section id="individual-intro" class="vcard person clearfix" role="region">-->

<div class="row">
  <!-- -----------------------INICIO DE DATOS DE CONTACTO CON FOTOGRAFIA -------------------------------------->
    <div class="contenedor col-md-3" >
		<div class="individual_content">
			<section id="contenedor-foto">
				  <!-- Image -->
				  <#assign individualImage>
					  <@p.image individual=individual
								propertyGroups=propertyGroups
								namespaces=namespaces
								editable=editable
								showPlaceholder="always" />
				  </#assign>

				  <#if ( individualImage?contains('<img class="individual-photo"') )>
					  <#assign infoClass = 'class="withThumb"'/>
				  </#if>

				  <div class="col-md-1 ih-item square colored effect4" id="photo-wrapper">${individualImage}
				  </div>
				  <div class="row individual-ids">
					  <#if ids?? && ids[0]??>
						<div class="shortview_person-social">
							<#if ids[0].cvlac??>
							  <a target="_blank" href="${ids[0].cvlac}"><img src="${urls.base}/themes/wilma/images/logos/cvac.png" height="30" width="30" title="CVLAC"></img></a>
							</#if>
							<#if ids[0].orcid??>
							  <a target="_blank"  href="${ids[0].orcid}"><img src="${urls.base}/themes/wilma/images/logos/orcid.png" height="30" width="30" title="ORCID"></img></a>
							</#if>
							<#if ids[0].googlescholar??>
							  <a target="_blank"  href="${ids[0].googlescholar}"><img src="${urls.base}/themes/wilma/images/logos/scholar.png" height="30" width="30" title="Google Scholar"></img></a>
							</#if>
							<#if ids[0].researchgate??>
							  <a target="_blank"  href="${ids[0].researchgate}"><img src="${urls.base}/themes/wilma/images/logos/rgate.png" height="30" width="30" title="ResearchGate"></img></a>
							</#if>
							<#if ids[0].researcherId??>
							  <a target="_blank"  href="${ids[0].researcherId}"><img src="${urls.base}/themes/wilma/images/logos/researcherid.png" height="30" width="30" title="ResearcherID"></img> </a>
							</#if>
							<#if ids[0].scopusId??>
							  <a target="_blank"  href="https://www.scopus.com/authid/detail.url?authorId=${ids[0].scopusId}"><img src="${urls.base}/themes/wilma/images/logos/scoopus.png" height="30" width="30" title="Scopus"></img> </a>
							</#if>
							<#if ids[0].pure??>
							  <a target="_blank"  href="${ids[0].pure}"><img src="${urls.base}/themes/wilma/images/logos/pure.png" height="30" width="30" title="Pure"></img> </a>
							</#if>
							<#if ids[0].repec??>
                                                          <a target="_blank" class="test"  href="${ids[0].repec}"><img src="${urls.base}/themes/wilma/images/logos/repec.jpg" height="30" width="30" title="Repec"></img> </a>
                                                        </#if>

						</div>
					</#if>
				  </div>

				  <!-- Contact Info -->
				  <div class="" id="individual-tools-people">
					
					<!-- span id="iconControlsLeftSide">
						  <img id="uriIcon" title="${individual.uri}" src="${urls.images}/individual/uriIcon.gif" alt="${i18n().uri_icon}"/>
						<#if checkNamesResult?has_content >
						  <#--
						  <img id="qrIcon"  src="${urls.images}/individual/qr_icon.png" alt="${i18n().qr_icon}" />
						  <span id="qrCodeImage" class="hidden">${qrCodeLinkedImage!}
							<a class="qrCloseLink" href="#"  title="${i18n().qr_code}">${i18n().close_capitalized}</a>
						  </span>
						  -->
						</#if>
					</span -->
					
					<#include "individual-contactInfo.ftl">

				</div>
			</section>
				<!---------------------- FIN DE  DATOS DE CONTACTO CON FOTOGRAFIA ----------------------------------------->
				<!---------------------- CONTENEDOR DE ESTADISTICAS ----------------------------------------->
			<div class="space_line"></div>	
			<section id="right-hand-column" role="region">
				<#include "individual-visualizationFoafPerson.ftl">
			</section>
			<!---------------------- FIN CONTENEDOR DE ESTADISTICAS ----------------------------------------->
		</div>
	</div>
    
	
	
	
	


  <!-- -----------------------INICIO DE INFORMACIÓN INDIVIDUAL -------------------------------------->

	<div class="contenedor-info col-md-9" id="person-inform">
      <div class="individual_content"> 
		   <#include "individual-adminPanel.ftl">
		<div class="row">
			<div class="col-md-9">
				<#if relatedSubject??>
                <h1>${relatedSubject.relatingPredicateDomainPublic} ${i18n().indiv_foafperson_for} ${relatedSubject.name}</h1>
                <a href="${relatedSubject.url}" title="${i18n().indiv_foafperson_return}">&larr; ${i18n().indiv_foafperson_return} ${relatedSubject.name}</a>
				<#else>
					<h1 class="foaf-person">
						<#-- Label -->
						<span itemprop="name" class="fn"><@p.label individual editable labelCount localesCount/></span>&nbsp;|&nbsp;

						<#--  Display preferredTitle if it exists; otherwise mostSpecificTypes -->
						<#assign title = propertyGroups.pullProperty("http://purl.obolibrary.org/obo/ARG_2000028","http://www.w3.org/2006/vcard/ns#Title")!>
						<#if title?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
							<#if (title.statements?size < 1) >
								<@p.addLinkWithLabel title editable />
							<#elseif editable>
								<h2>${title.name?capitalize!}</h2>
								<@p.verboseDisplay title />
							</#if>
							<#list title.statements as statement>
								<span itemprop="jobTitle" class="display-title<#if editable>-editable</#if>">${statement.preferredTitle}</span>
								<@p.editingLinks "${title.localName}" "${title.name}" statement editable title.rangeUri />
							</#list>
						</#if>
						<#-- If preferredTitle is unpopulated, display mostSpecificTypes -->
						<#if ! (title.statements)?has_content>
							<@p.mostSpecificTypes individual />
						</#if>
					</h1>
				</#if>
			</div>
			<div class="col-md-3">
				<section id="kpi_stats">
				<#if count?? && count[0]??>
					<#if count[0].tutoredTheses?? && (count[0].tutoredTheses?number &gt; 0)>
						<div class="kpi_stats_count"> Tutored <#if 1 == count[0].tutoredTheses?number>Thesis<#else>Theses</#if>:  ${count[0].tutoredTheses!}</div>
					</#if>
					<#if count[0].grants?? && (count[0].grants?number &gt; 0)>
						<div class="kpi_stats_count"><#if 1 == count[0].grants?number>Grant<#else>Grants</#if>: ${count[0].grants!}</div>
					</#if>
					<#if count[0].publications?? && (count[0].publications?number &gt; 0)>
						<div class="kpi_stats_count"><#if 1 == count[0].publications?number>Publication<#else>Publications</#if>: ${count[0].publications!}</div>
					</#if>
				</#if>
				</section>
			</div>
		</div>
		 
		<section id="individual-info" class="clearfix" ${infoClass!} role="region">
		
			<!--<header class="individual-info-header">-->
				
				<!-- Positions -->
				<#include "individual-positions.ftl">
				<!-- Overview -->
				<#include "individual-overview.ftl">
				<!-- Websites -->
				<#include "individual-webpage.ftl">        
			<!--</header>-->
			<!-- Research Areas -->
			<#include "individual-researchAreas.ftl">

			<!-- Geographic Focus
			<#include "individual-geographicFocus.ftl"> -->

			<!-- OpenSocial 
			<#include "individual-openSocial.ftl">-->
		</section>
	
	
	
	<section id="individual-tabs" class="row">
			
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
		<#include "individual-property-group-tabs.ftl">
	</section>
  </div>
  </div>
<!-- </section>-->
<!-------------------------------------------------------------------------------------------------------------------------------------------------->
<!-------------------------------------------------------------------------------------------------------------------------------------------------->


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
        displayLess: '${i18n().display_less}',
        displayMoreEllipsis: '${i18n().display_more_ellipsis}',
        showMoreContent: '${i18n().show_more_content}',
        verboseTurnOff: '${i18n().verbose_turn_off}',
        researchAreaTooltipOne: '${i18n().research_area_tooltip_one}',
        researchAreaTooltipTwo: '${i18n().research_area_tooltip_two}'
    };
    var i18nStringsUriRdf = {
        shareProfileUri: '${i18n().share_profile_uri}',
        viewRDFProfile: '${i18n().view_profile_in_rdf}',
        closeString: '${i18n().close}'
    };
</script>

${stylesheets.add('<link rel="stylesheet" href="${urls.base}/css/individual/individual.css" />',
                  '<link rel="stylesheet" href="${urls.base}/css/individual/individual-vivo.css" />',
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
