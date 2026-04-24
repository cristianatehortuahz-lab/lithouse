
<#--  <div class="card" id="home_services" role="listitem" role="navigation">  -->

<div class="services-panel">

	<div class="container ">
		<div class="titleServices">
			<h1>
				${i18n().titleServices}
			</h1>
		</div>
	<div class="row d-flex">

	<#--  Primer servicio TUTOR  -->
		<div class="col-lg-3 col-md-6 col-sm-12">
			<div class="card h-100" id="service-box">
				<img src="${urls.base}/themes/wilma/images/servicios/s1.webp" class="card-img-top" alt="Servicio1" width="270" height="180" fetchpriority="high">
				<div class="card-body" id="box-message">
					<p class="card-text">
						${i18n().find_supervisor}
					</p>
					
					<div class="contenedor" id="search-service">
						<form class="js-form d-flex align-items-center" action="${urls.base}/find-a-supervisor" method="GET">
							<input type="submit" id="go-button" class="btn btn-primary js-submit js-disabled" value="IR">
							<div class="autocomplete-box flex-grow-1 me-2">
								<div class="js-autocomplete-hints"></div>
								<input type="text" autocomplete="off" name="querytext" id="search-bar-service" class="form-control" placeholder="${i18n().service_search}">
							</div>
							<input type="hidden" name="classgroup" value="http://vivoweb.org/ontology#vitroClassGrouppeople">

							
							<#--  <div class="search-radio-box">
								<label>
									<input type="radio" name="querytype" value="keyword" checked="">${i18n().service_keyword}
								</label>
								<label>
									<input id="by-name-radio" type="radio" name="querytype" value="name">${i18n().service_expert}
								</label>
							</div>  -->
							
						</form>
					</div>

				</div>
			</div>
		</div>

		<#--  Segundo servicio Experso  -->
		<div class="col-lg-3 col-md-6 col-sm-12">
			<div class="card h-100" id="service-box2">
				<img src="${urls.base}/themes/wilma/images/servicios/s2.webp" class="card-img-top" alt="Servicio2" width="270" height="180" loading="lazy">
				<div class="card-body" id="box-message">
					<p class="card-text">
						${i18n().find_partner}
					</p>
					<div class="contenedor" id="search-service">
						<form class='js-form d-flex align-items-center' action="${urls.base}/find-a-partner" method="GET">
							<input type="submit" id="go-button" class="btn btn-primary  js-submit js-disabled" value="${i18n().service_go}">
							<div class="autocomplete-box">
								<div class="js-autocomplete-hints" tabindex="-1"></div>
								<input type="text" autocomplete="off" name="querytext" id="search-bar-service" class="form-control" placeholder="${i18n().service_search}">
							</div>

							<input type="hidden" name="classgroup" value="http://vivoweb.org/ontology#vitroClassGrouppeople" />
						</form>
					</div>
				</div>
			</div>
		</div>

		<#--  Tercer servicio Laboratorios  -->
		<div class="col-lg-3 col-md-6 col-sm-12">
			<div class="card h-100" id="service-box5">
				<img src="${urls.base}/themes/wilma/images/servicios/s5.webp" class="card-img-top" alt="Servicio5" width="270" height="180" loading="lazy">
				<div class="card-body" id="box-message">
					<p class="card-text">
						${i18n().find_lab}
					</p>
					<div class="contenedor" id="search-service">
						<form action="${urls.base}/find-a-lab" method="GET" class="js-form d-flex align-items-center">
							
							<input type="submit" id="go-button" class="btn btn-primary  js-submit js-disabled" value="${i18n().service_go}">
							<div class="autocomplete-box">
								<div class="js-autocomplete-hints"></div>
								<input type="text" autocomplete="off" name="querytext" id="search-bar-service" class="form-control" placeholder="${i18n().service_search}">
							</div>
							<input type="hidden" name="classgroup" value="http://vivoweb.org/ontology#vitroClassGrouporganizations" />
						</form>
					</div>
				</div>
			</div>
		</div>

		<#-- Servicie Speaker -->
		<#-- <div class="col-sm-3" id="service-box4">
		<div class="contenedor">
			<div class="col-sm-12" id="box-message">
				<p>
					${(i18n().find_speaker)! "Encuentre un experto para su charla"}
				</p>
				<div class="contenedor" id="search-service">
					<form action="${urls.base}/find-a-speaker" method="GET" class='js-form'>
						<div class="autocomplete-box ">
							<div class="js-autocomplete-hints"></div>
							<input type="text" autocomplete="off" name="querytext" id="search-bar-service" class="" placeholder="${i18n().service_search}">
						</div>
						<input type="submit" id="go-button" class="btn js-submit js-disabled" value="${i18n().service_go}">
						<input type="hidden" name="type" value="http://vivoweb.org/ontology/core#presentador" />
						<div class="search-radio-box">
							<label>
								<input type="radio" name="searchBy" value="keyword" checked="">
								${i18n().service_keyword}
							</label>
							<label>
								<input id="by-name-radio" type="radio" name="searchBy" value="name">
								${(i18n().service_speaker)! "Nombre del experto"}
							</label>
						</div>
					</form>
				</div>
			</div>
		</div> -->

		<#--  Cuarto servicio Programas Academicos  -->
		<div class="col-lg-3 col-md-6 col-sm-12">
			<div class="card h-100" id="service-box3">
				<img src="${urls.base}/themes/wilma/images/servicios/s3.webp" class="card-img-top" alt="Servicio3" width="270" height="180" loading="lazy">
				<div class="card-body" id="box-message">
					<p class="card-text">
						${i18n().find_degree}
					</p>
					<div class="contenedor" id="search-service">
						<form action="${urls.base}/find-a-program" method="POST" class='js-form d-flex align-items-center'>
							
							<input type="submit" id="go-button" class="btn btn-primary js-submit js-disabled" value="${i18n().service_go}">
							<div class="autocomplete-box">
								<div class="js-autocomplete-hints"></div>
								<input type="text" autocomplete="off" name="querytext" id="search-bar-service-degree" class="form-control" placeholder="${i18n().service_search}">
							</div>
							<input type="hidden" name="classgroup" value="http://vivoweb.org/ontology#vitroClassGrouporganizations" />
						</form>
					</div>
				</div>
			</div>
		</div>
		
		
	</div>
</div>

${scripts.add('<script defer type="text/javascript" src="${urls.base}/themes/wilma/js/autocomplete.js"></script>')}
<script>
var baseUrl = "${urls.base}"
</script>
<script>
document.addEventListener("DOMContentLoaded", function() {
	var input = document.getElementById("search-bar-service-degree");
	if (input) {
		input.addEventListener("keyup", function(event) {
			if (event.keyCode === 13) {
				event.preventDefault();
				toService3();
			}
		});
	}

	function toService3() {
		var degreeNameRadio = document.getElementById('degree-radio-name');
		if (degreeNameRadio && degreeNameRadio.checked) {
			var rate_value = degreeNameRadio.value;
			console.log(rate_value);
			window.location.href = '${urls.base}'+"/find-a-program?querytext=acNameStemmed:\"" + document.getElementById("search-bar-service-degree").value + "\"";
		} else {
             // Default search behavior if needed, currently empty in original code
             window.location.href = '${urls.base}'+"/find-a-program?querytext=" + document.getElementById("search-bar-service-degree").value;
        }
	}
});
</script>
