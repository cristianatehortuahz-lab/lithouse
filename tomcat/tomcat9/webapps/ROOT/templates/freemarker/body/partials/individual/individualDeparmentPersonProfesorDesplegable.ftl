<#if departmentPeople?has_content>

    <#assign totalLength = 0 >
    <#assign moreDisplayed = false>
    <#list departmentPeople as AcademicPeople>
        <#if ( totalLength > 330 ) && !moreDisplayed >
            <li id="adMoreContainer" style="border:none; list-style-type: none">(...<a id="adMore" href="javascript:">more</a>)</li>
            <li class="col-lg-2 col-md-3 col-sm-4 adLinkMore"  role="listitem" role="navigation" style="display:none">
            <#assign moreDisplayed = true>
        <#elseif ( totalLength > 330 ) && moreDisplayed >
            <li class="col-lg-2 col-md-3 col-sm-4 adLinkMore"  role="listitem" role="navigation" style="display:none">
        <#else>
            <li class="col-lg-2 col-md-3 col-sm-4 adLink"  role="listitem" role="navigation">
        </#if>
                <div class="card">
                    <div class = "imagenes">
                        <#if AcademicPeople["imagenPerson"]??>
                            <img src='${AcademicPeople["imagenPerson"]}' class="card-img-top" alt='${AcademicPeople["namePerson"]}' />
                            <#if AcademicPeople["email"]??>
                                <a href='mailto:${AcademicPeople["email"]}' target="_blank" class="icono-link" >
                                    <img src="../../../images/individual/emailIcon.gif" alt="Icono" />
                                </a>
                            </#if>
                        <#else>
                            <img src="${urls.base}/images/placeholders/person.thumbnail.jpg" class="card-img-top" alt='${AcademicPeople["namePerson"]}' />
                            <#if AcademicPeople["email"]??>
                                <a href='mailto:${AcademicPeople["email"]}' target="_blank" class="icono-link" >
                                    <img src="../../../images/individual/emailIcon.gif" alt="Icono" />
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
            </li>
            <#assign totalLength = totalLength + AcademicPeople["namePerson"]?length >
        <#--  <h3>${AcademicPeople["imagenPerson"]!"No hay imagen disponible"}</h3>  -->
        <#--  <img class="individual-photo" src='${AcademicPeople["imagenPerson"]}' title='${AcademicPeople["namePerson"]}'  width=180 />  -->
    </#list>
    <#if ( totalLength > 330 ) ><li id="adLessContainer" style="display:none; list-style-type: none">(<a id="acLess" href="javascript:">less</a>)</li></#if>
</#if>

<script>
$('a#adMore').click(function() {
    $('li.adLinkMore').each(function() {
        $(this).show();
    });
    $('li#adMoreContainer').hide();
    $('li#adLessContainer').show();
});
$('a#acLess').click(function() {
    $('li.adLinkMore').each(function() {
        $(this).hide();
    });
    $('li#adMoreContainer').show();
    $('li#adLessContainer').hide();
});
</script>
