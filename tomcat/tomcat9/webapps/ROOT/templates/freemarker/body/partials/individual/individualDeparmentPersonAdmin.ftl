<#if departmentPeople?has_content>
    <div class="row directivos">   
            <#list departmentPeople?sort_by("jobTitle") as AcademicPeople>
                <#if AcademicPeople["jobTitle"]?starts_with("Decana") || AcademicPeople["jobTitle"]?starts_with("Decano") || AcademicPeople["jobTitle"]?starts_with("Vicedecano") || AcademicPeople["jobTitle"]?starts_with("Vicedecana") ||  AcademicPeople["jobTitle"]?starts_with("Director")>
                    <div class="col-lg-3 col-md-4 col-sm-6"  role="listitem" role="navigation">
                        <div class="card admin">
                            <div class = "imagenes">
                                <#if AcademicPeople["imagenPerson"]??>
                                    <img src='${AcademicPeople["imagenPerson"]}' class="card-img-top" alt='${AcademicPeople["namePerson"]}' />
                                    <#if AcademicPeople["email"]??>
                                        <a href='mailto:${AcademicPeople["email"]}' target="_blank" class="icono-link" >
                                            <img src="../../../images/individual/iconEmail.png" alt="Icono" id="iconEmail"/>
                                        </a>
                                    </#if>
                                <#else>
                                    <img src="${urls.base}/images/placeholders/person.thumbnail.jpg" class="card-img-top" alt='${AcademicPeople["namePerson"]}' />
                                    <#if AcademicPeople["email"]??>
                                        <a href='mailto:${AcademicPeople["email"]}' target="_blank" class="icono-link" >
                                            <img src="../../../images/individual/iconEmail.png" alt="Icono" id="iconEmail"/>
                                        </a>
                                    </#if>
                                </#if>
                            </div>
                            <div class="card-body">
                                <h5 class="card-title">
                                    <a href='${AcademicPeople["personURL"]}' title='${AcademicPeople["namePerson"]}'>${AcademicPeople["namePerson"]}</a>
                                </h5>
                                <h5 class="card-title">${AcademicPeople["jobTitle"]}</h5>
                            </div> 
                        </div> 
                    </div> 
                </#if>
                    <#--  <h3>${AcademicPeople["imagenPerson"]!"No hay imagen disponible"}</h3>  -->
                    <#--  <img class="individual-photo" src='${AcademicPeople["imagenPerson"]}' title='${AcademicPeople["namePerson"]}'  width=180 />  -->
            </#list>
    </div>
</#if>




