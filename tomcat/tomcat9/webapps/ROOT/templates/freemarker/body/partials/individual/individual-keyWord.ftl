<#assign overview = propertyGroups.pullProperty("${core}freetextKeyword")!>
<#if overview?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
    <@p.addLinkWithLabel overview editable />
    <h3 class="titleKeyWord">Palabras Claves</h3>
    <ul class="individual-keyWord">
        <#list overview.statements as statement>
                <li class="keyWord-value">
                    ${statement.value}
                </li>
                <div class="editKeyWordLab">
                    <@p.editingLinks "${overview.name}" "" statement editable />
                </div>
        </#list>
    </ul>
</#if>