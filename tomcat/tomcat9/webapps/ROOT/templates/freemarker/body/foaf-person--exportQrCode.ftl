<#-- $This file is distributed under the terms of the license in LICENSE$ -->

<#-- Page providing options for disseminating QR codes -->
<#assign qrCodeWidth = "150">

<#include "individual-qrCodeGenerator.ftl">
<div class="container my-5">
	<h2>${i18n().export_qr_code} <em>(<a href="${qrData.aboutQrCodesUrl}" title="${i18n().more_qr_info}">${i18n().what_is_this}</a>)</em></h2>

	<#assign thumbUrl = individual.thumbUrl! "${urls.images}/placeholders/person.thumbnail.jpg" >
	<img class="individual-photo qrCode" src="${thumbUrl}" width="160" alt="${i18n().alt_thumbnail_photo}"/>

	<h3 class="qrCode"><a href="${individual.profileUrl}" title="${i18n().view_this_profile}">${individual.nameStatement.value}</a></h3>

	<section class="vcard">
		<h4>${i18n().vcard}</h4>
		<div class="row align-items-center g-3">
			<div class="col-auto">
				<@qrCodeVCard qrCodeWidth />
			</div>
			<div class="col">
				<textarea name="qrCodeVCard" readonly>
					&lt;img src="${getQrCodeUrlForVCard(qrCodeWidth)!}" /&gt;<#t>
				</textarea><#t>
			</div>
		</div>
	</section>

	<section>
		<h4>${i18n().hyperlink}</h4>
		<div class="row align-items-center g-3">
			<div class="col-auto">
				<@qrCodeLink qrCodeWidth />
			</div>
			<div class="col">
				<textarea name="qrCodeLink" readonly>
					&lt;img src="${getQrCodeUrlForLink(qrCodeWidth)!}" /&gt;<#t>
				</textarea><#t>
			</div>
		</div>
	</section>

</div>
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/css/individual/individual-qr.css" />')}
${stylesheets.add('<link rel="stylesheet" href="${urls.theme}/css/individual-qr.css" />')}
