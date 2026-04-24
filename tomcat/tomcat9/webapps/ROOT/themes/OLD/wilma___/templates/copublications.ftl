<#-- $This file is distributed under the terms of the license in LICENSE$ -->

<h1 class='copubs-h'>Copublications of ${sourceName} and ${targetName}</h1>

<ul class="property-list long-list" role="list" id="relatedBy-Authorship-List">
  <#list statements as statement>
    <li role="listitem"><#include "copublication.ftl"></li>
  </#list>
</ul>
