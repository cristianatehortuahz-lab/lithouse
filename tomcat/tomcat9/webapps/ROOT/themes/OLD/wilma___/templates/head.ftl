<#-- $This file is distributed under the terms of the license in LICENSE$ -->

<meta charset="utf-8" />
<!-- Google Chrome Frame open source plug-in brings Google Chrome's open web technologies and speedy JavaScript engine to Internet Explorer-->
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="generator" content="VIVO ${version.label}" />

<title>${(title?html)!siteName!}</title>

<!-- JCCJ AGREGAR BOOSTRAP A LA PLANTILLA PREDETERMINADA: Se CDN de boostrap y se crea un estilo nuevo. Se agrega JS para efectos -->

<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>

<script type="text/javascript" src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js" ></script>

<#--  parametro en falla  -->
		<#--  <script type="text/javascript">
				jQuery(function ($) {
			var scrollingStartDistance = $(".mn").offset().top;

			$(document).scroll(function () {
				var scrollTop = $(document).scrollTop();
				
				$(".mn").toggleClass("scrolling", scrollTop > scrollingStartDistance);
			});
		});
		 </script>  -->


<LINK href="${urls.base}/themes/wilma/css/ihover.css" rel="stylesheet" type="text/css">
<LINK href="${urls.base}/themes/wilma/css/config.css" rel="stylesheet" type="text/css">
<!--<LINK href="${urls.base}/themes/wilma/css/estilos.css" rel="stylesheet" type="text/css">-->
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" crossorigin="anonymous">

<!--JCCJ FIN AGREGAR BOOSTRAP A LA PLANTILLA PREDETERMINADA: ------------------------------ -->

<!--JFLF header institucional-->
<link type="text/css" rel="stylesheet" href="${urls.base}/themes/wilma/css/footer-institucional.css" />
<link rel="stylesheet" href="https://urosario.edu.co/PortalUrosario/media/UR-V4/CEAP/css/main.css">
<link href="https://urosario.edu.co/PortalUrosario/media/UR-V4/CEAP/css/tabs-style.css" rel="stylesheet">
<link href="https://urosario.edu.co/App_Themes/Default/Images/favicon.ico" type="image/x-icon" rel="shortcut icon">
<link href="https://urosario.edu.co/App_Themes/Default/Images/favicon.ico" type="image/x-icon" rel="icon">
<link href="https://urosario.edu.co/PortalUrosario/media/UR-V4/Home/css/header-footer.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Open+Sans:400,300,600,300italic,700" rel="stylesheet" type="text/css">

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.4.1/css/bootstrap.min.css">
<!-- fontawesome css -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/css/all.min.css" rel="stylesheet"
	type="text/css">
<!-- Tipografía -->
<link
	href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i|Roboto+Mono:100,100i,300,300i,400,400i,500,500i,700,700i&amp;display=swap"
	rel="stylesheet">

<!-- Jquery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<!-- cookies jquery -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/js-cookie/2.2.1/js.cookie.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<!-- bootstrap 4 js -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.3.1/js/bootstrap.bundle.min.js"></script>
<!-- OwlCarousel2 js -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js"></script>

<script type="text/javascript"
	src="https://urosario.edu.co/PortalUrosario/media/UR-V4/Home/js/urosario.js"></script>
		
<!-- fontawesome css -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/css/all.min.css" rel="stylesheet"
	type="text/css">
<!-- Crazy egg -->
<script type="text/javascript">
	setTimeout(function () {
		var a = document.createElement("script");
		var b = document.getElementsByTagName("script")[0];
		a.src = document.location.protocol + "//script.crazyegg.com/pages/scripts/0042/1576.js?" + Math.floor(new Date().getTime() / 3600000);
		a.async = true; a.type = "text/javascript"; b.parentNode.insertBefore(a, b)
	}, 1);
</script>
	<!-- End crazy egg -->
<!--JFLF fin header institucional-->





<#-- VIVO OpenSocial Extension by UCSF -->
<#if openSocial??>
    <#if openSocial.visible>
        <#-- Required to add these BEFORE stylesheets.flt and headScripts.ftl are processed -->
        ${stylesheets.add('<link rel="stylesheet" href="${urls.theme}/css/openSocial/gadgets.css" />')}
        ${headScripts.add(
							'<script type="text/javascript" src="${openSocial.containerJavascriptSrc}"></script>',
                        	'<script type="text/javascript" language="javascript">${openSocial.gadgetJavascript}</script>'
                          	'<script type="text/javascript" src="${urls.base}/js/openSocial/orng.js"></script>'
						)}
    </#if>
</#if>

<#include "stylesheets.ftl">
<link rel="stylesheet" href="${urls.theme}/css/screen.css" />

<#include "headScripts.ftl">

<#if metaTags??>
    ${metaTags.list()}
</#if>

<!--[if (gte IE 6)&(lte IE 8)]>
<script type="text/javascript" src="${urls.base}/js/selectivizr.js"></script>
<![endif]-->

<#-- Inject head content specified in the controller. Currently this is used only to generate an rdf link on
an individual profile page. -->
${headContent!}

<link rel="shortcut icon" type="image/x-icon" href="${urls.base}/favicon.ico">