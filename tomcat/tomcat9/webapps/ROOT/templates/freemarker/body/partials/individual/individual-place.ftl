<#--  <#if dateSiteLaboratory?has_content>
    <ul class="individual-place">
        <#list dateSiteLaboratory as Place>
            <li role="listitem" class="list-place">
                <a itemprop="place" class="place">${Place["place"]}</a>
            </li>
        </#list>
    </ul>	
</#if>  -->


<#--  <#assign place = propertyGroups.pullProperty("${core}physicalLocation")!>  -->
<#--  <#assign groups = propertyGroups.all>


<#list groups as g>
    Nombre: ${g.name!}
    Label: ${g.publicName!}
    Propiedades: ${g.properties?size!}

    <#list g.properties as p>
        URI: ${p.uri!}
        Label: ${p.name!}
        Template: ${p.template!}
        Tiene statements: ${p.statements?size!}
    </#list>
</#list>  -->


<#if dateSiteLaboratory?has_content>
    <ul class="individual-place">
        <#list dateSiteLaboratory as Place>
            <#if Place["place"]?? && Place["place"]?has_content>
                <li role="listitem" class="list-place">
                    <a itemprop="place" class="place">${Place["place"]}</a>
                </li>
            </#if>
        </#list>
    </ul>	
</#if>
