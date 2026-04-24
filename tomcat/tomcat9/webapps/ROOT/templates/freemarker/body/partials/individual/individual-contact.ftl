<#-- $This file is distributed under the terms of the license in LICENSE$ -->
<#if dateDepartment?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
    <#list dateDepartment as datos>
        <ul style="font-size:0.9em;padding-bottom:4px">
            <li>
                <h1>${datos["contac"]!!}</h1>
            </li>
        </ul>
    </#list> 
</#if>
