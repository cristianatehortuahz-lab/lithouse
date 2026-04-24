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
<#assign visRequestingTemplate = "vivo-program-wilma">


<div id="row-program">

  <!-- -----------------------INICIO DE INFORMACIĂ“N INDIVIDUAL -------------------------------------->

	<div class="contenedor-info col-md-12">
      <div id="contenedor-programa"> 
		   <#include "individual-adminPanel.ftl">
		<div class="row" id="titulo-programa">
			<div class="col-md-12">
				<#if relatedSubject??>
                <h1>${relatedSubject.relatingPredicateDomainPublic} ${i18n().indiv_foafperson_for} ${relatedSubject.name}</h1>
                <a href="${relatedSubject.url}" title="${i18n().indiv_foafperson_return}">&larr; ${i18n().indiv_foafperson_return} ${relatedSubject.name}</a>
				<#else>
					<h1 class="foaf-program JFLF">
						<#-- Label -->
						<span itemprop="name" class="fn"><@p.label individual editable labelCount localesCount/></span>&nbsp;|&nbsp;
						<span itemprop="jobTitle" class="display-title">Degree</span>
						<#--  Display preferredTitle if it exists; otherwise mostSpecificTypes -->
						<#assign title = propertyGroups.pullProperty("http://purl.obolibrary.org/obo/ARG_2000028","http://www.w3.org/2006/vcard/ns#Title")!>
						<#if title?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
							<#if (title.statements?size < 1) >
								<!-- <@p.addLinkWithLabel title editable /> -->
							<#elseif editable>
								<!-- <h2>${title.name?capitalize!}</h2> -->
								<!-- <@p.verboseDisplay title /> -->
							</#if>
							<#list title.statements as statement>
								<span itemprop="jobTitle" class="display-title<#if editable>-editable</#if>">Degree</span>
								<@p.editingLinks "${title.localName}" "${title.name}" statement editable title.rangeUri />
							</#list>
						</#if>
						<#-- If preferredTitle is unpopulated, display mostSpecificTypes -->
						<#if ! (title.statements)?has_content>
							<!-- <@p.mostSpecificTypes individual /> -->
						</#if>
					</h1>
				</#if>
				<#include "individual-webpage.ftl">  
			</div>

		</div>
		 
		<div class="row" id="overview-program">
				
				<#include "individual-overview.ftl">

		</div>
	
	
	
	<section id="individual-tabs" class="row">
			
		<#assign nameForOtherGroup = "${i18n().other}">
			
		<#-- Ontology properties -->


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
