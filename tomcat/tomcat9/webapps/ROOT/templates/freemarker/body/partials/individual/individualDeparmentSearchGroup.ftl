
<#-- $This file is distributed under the terms of the license in LICENSE$ -->
<#if researchGroup?has_content>
    <#-- If the organization is an Academic Department, we use a different datagetter and detail page. This -->
    <#-- is strictly a usability issue so we can refer accurately to "faculty members" within the dept.     -->
    <#assign urlForDetailsPage = "affiliatedResearchAreas" />
    <#assign headingText = "${i18n().faculty_research_group}" />
   

    <h2 id="facultyResearchAreas" class="mainPropGroup">
        ${headingText}
    </h2>

    <ul id="individual-hasResearchGroup" role="list">
        <#assign totalLength = 0 >
        <#assign moreDisplayed = false>
        <#list researchGroup as resultResearchGroup>
            <#if ( totalLength > 720 ) && !moreDisplayed >
                <li id="sgMoreContainer" style="border:none">(...<a id="sgMore" href="javascript:">mas</a>)</li>
                <li class="col-lg-2 col-md-3 col-sm-4 sgLinkMore" role="listitem" role="navigation" style="display:none">
                <#assign moreDisplayed = true>
            <#elseif ( totalLength > 720 ) && moreDisplayed >
                <li class="col-lg-2 col-md-3 col-sm-4 sgLinkMore" role="listitem" role="navigation" style="display:none">
            <#else>
                <li class="col-lg-2 col-md-3 col-sm-4 raLink">
            </#if>

                <div class="vcard-container">
                    <div class="vcard">
                        <a class="raLink" href='${resultResearchGroup["urlGroup"]}'>
                            ${resultResearchGroup["nameGroup"]!!}
                        </a>
                    </div>
                </div>
            </li>
            <#assign totalLength = totalLength + resultResearchGroup["urlGroup"]?length >
        </#list>
        <#if ( totalLength > 720 ) ><li id="sgLessContainer" style="display:none">(<a id="sgLess" href="javascript:">menos</a>)</li></#if>
    </ul>
</#if>
<script>
$('a#sgMore').click(function() {
    $('li.sgLinkMore').each(function() {
        $(this).show();
    });
    $('li#sgMoreContainer').hide();
    $('li#sgLessContainer').show();
});
$('a#sgLess').click(function() {
    $('li.sgLinkMore').each(function() {
        $(this).hide();
    });
    $('li#sgMoreContainer').show();
    $('li#sgLessContainer').hide();
});
</script>