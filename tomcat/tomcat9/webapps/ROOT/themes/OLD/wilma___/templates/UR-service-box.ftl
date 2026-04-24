
<!-- --------------------------------------comentado JCCJ #carrusel de imagenes -->

<div class="titleServices">
	<h1> ${i18n().titleServices}</h1>
</div>

<div class="card" id="home_services" role="listitem" role="navigation">

	<div class="col-lg-3 col-md-6 col-sm-12" id="service-box">
		<img id="imgService" src="./themes/wilma/images/servicios/s1_new.jpg" alt="Servicio1">
		<div class="card-body" id="box-message">
			<p>${i18n().find_supervisor}</p>
			<div class="contenedor" id="search-service">
				<form class='js-form' action="${urls.base}/find-a-supervisor" method="GET">
					<div class="autocomplete-box ">
						<div class="js-autocomplete-hints"></div>
						<input type="text" autocomplete="off" name="querytext" id="search-bar-service" class="" placeholder="${i18n().service_search}">
					</div>
					<input type="submit" id="go-button" class="btn js-submit js-disabled" value="${i18n().service_go}">
					<input type="hidden" name="classgroup" value="http://vivoweb.org/ontology#vitroClassGrouppeople"/>
				</form>
			</div>
		</div>
	</div>



	<div class="col-lg-3 col-md-6 col-sm-12" id="service-box2">
		<img id="imgService" src="./themes/wilma/images/servicios/s2_new.jpg" alt="Servicio2">
		<div class="card-body" id="box-message">
			<p>${i18n().find_partner}</p>
			<div class="contenedor" id="search-service">
				<form class='js-form' action="${urls.base}/find-a-partner" method="GET">
					<div class="autocomplete-box {">
						<div class="js-autocomplete-hints" tabindex="-1"></div>
						<input type="text" autocomplete="off" name="querytext" id="search-bar-service" class="" placeholder="${i18n().service_search}">
					</div>
					<input type="submit" id="go-button" class="btn js-submit js-disabled" value="${i18n().service_go}">
					<input type="hidden" name="classgroup" value="http://vivoweb.org/ontology#vitroClassGrouppeople"/>
				</form>
			</div>
		</div>
	</div>


	<div class="col-lg-3 col-md-6 col-sm-12" id="service-box3">
		<img id="imgService" src="./themes/wilma/images/servicios/s3_new.jpg" alt="Servicio3">
		<div class="card-body" id="box-message">
			<p>${i18n().find_degree}</p>
			<div class="contenedor" id="search-service">
				<form action="${urls.base}/find-a-program" method="POST" class='js-form'>
					<div class="autocomplete-box ">
						<div class="js-autocomplete-hints"></div>
						<input type="text" autocomplete="off" name="querytext" id="search-bar-service-degree" class="" placeholder="${i18n().service_search}">
					</div>
					<input type="submit" id="go-button" class="btn js-submit js-disabled" value="${i18n().service_go}">
					<input type="hidden" name="classgroup" value="http://vivoweb.org/ontology#vitroClassGrouporganizations"/>
				</form>
			</div>
		</div>
	</div>

	<#--  Servicie Speaker  -->
	<#--  <div class="col-sm-3" id="service-box4">
		<div class="contenedor">
			<div class="col-sm-12" id="box-message">
				<p>${i18n().find_speaker}</p>
			<div class="contenedor" id="search-service">
				<form action="${urls.base}/find-a-speaker" method="GET" class='js-form'>
					<div class="autocomplete-box ">
						<div class="js-autocomplete-hints"></div>
						<input type="text" autocomplete="off" name="querytext" id="search-bar-service" class="" placeholder="${i18n().service_search}">
					</div>
					<input type="submit" id="go-button" class="btn js-submit js-disabled" value="${i18n().service_go}">
					<input type="hidden" name="type" value="http://vivoweb.org/ontology/core#presentador"/>

					<div class="search-radio-box">
						<label>
							<input type="radio" name="searchBy" value="keyword" checked="">${i18n().service_keyword}
						</label>
						<label>
							<input id="by-name-radio" type="radio" name="searchBy" value="name">${i18n().service_speaker}
						</label>
					</div>
				</form>
			</div>
		</div>
	</div>  -->

	<#--  servicio de laboratorio  -->
	<div class="col-lg-3 col-md-6 col-sm-12" id="service-box5">
		<img id="imgService" src="./themes/wilma/images/servicios/s5.jpg" alt="Servicio5">
		<div class="card-body" id="box-message">
			<p>${i18n().find_lab}</p>
			<div class="contenedor" id="search-service">
				<form action="${urls.base}/find-a-lab" method="GET" class='js-form'>
					<div class="autocomplete-box ">
						<div class="js-autocomplete-hints"></div>
						<input type="text" autocomplete="off" name="querytext" id="search-bar-service" class="" placeholder="${i18n().service_search}">
					</div>
					<input type="submit" id="go-button" class="btn js-submit js-disabled" value="${i18n().service_go}">
					<input type="hidden" name="classgroup" value="http://vivoweb.org/ontology#vitroClassGrouporganizations"/>

				</form>
			</div>
		</div>
	</div>

</div>

${scripts.add('<script type="text/javascript" src="${urls.base}/themes/wilma/js/autocomplete.js"></script>')}
<script>var baseUrl = "${urls.base}"</script>

<script>
	var input = document.getElementById("search-bar-service-degree");
	input.addEventListener("keyup", function(event) {
	// Number 13 is the "Enter" key on the keyboard
		if (event.keyCode === 13) {
			event.preventDefault();
			toService3();
			//document.getElementById("go-button-degree").click();
			}
		});

		function toService3(){
		//var input-degree=document.getElementById("search-bar-service-degree").value;
		
		/*if (document.getElementById('degree-radio-keyword').checked) {
		rate_value = document.getElementById('degree-radio-keyword').value;
		console.log(rate_value);
		window.location.href='http://10.194.194.96:8080/find-a-program?querytext='+document.getElementById("search-bar-service-degree").value+'';
		}*/	
		if (document.getElementById('degree-radio-name').checked) {
		rate_value = document.getElementById('degree-radio-name').value;
		console.log(rate_value);
		window.location.href='http://10.194.194.96:8080/vivo115/find-a-program?querytext=acNameStemmed:"'+document.getElementById("search-bar-service-degree").value+'"';
		}
		}
</script>

<!-- ---------------------------------------------comentado JCCJ #fin carrusel de imagenes ----------------------------------------->
