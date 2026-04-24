<#if departmentPeople?has_content>
   <div class="scroll-container"> 
    <div class="row" role="list">
        <#list departmentPeople as AcademicPeople>

            <div class="col-lg-2 col-md-3 col-sm-4 adLink"  role="listitem" role="navigation">
                <div class="card">
                    <div class = "imagenes">
                        <#if AcademicPeople["imagenPerson"]??>
                            <img src='${AcademicPeople["imagenPerson"]}' class="card-img-top" alt='${AcademicPeople["namePerson"]}' />
                            <#if AcademicPeople["email"]??>
                                <a href='mailto:${AcademicPeople["email"]}' target="_blank" class="icono-link" >
                                    <img src="../../../images/individual/iconEmail.png" alt="Icono"  id="iconEmail"/>
                                </a>
                            </#if>
                        <#else>
                            <img src="${urls.base}/images/placeholders/person.thumbnail.jpg" class="card-img-top" alt='${AcademicPeople["namePerson"]}' />
                            <#if AcademicPeople["email"]??>
                                <a href='mailto:${AcademicPeople["email"]}' target="_blank" class="icono-link" >
                                    <img src="../../../images/individual/iconEmail.png" alt="Icono"  id="iconEmail"/>
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


        </#list>
        </div>
    </div>
</#if>
