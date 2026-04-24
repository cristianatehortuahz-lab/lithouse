mport "lib-properties.ftl" as p>

<li class="individual" role="listitem" role="navigation">

<#if (individual.thumbUrl)??>
    <img src="${individual.thumbUrl}" width="90" alt="${individual.name}" />
    <h1 class="thumb">
        <a href="${individual.profileUrl}" title="View the profile page for
               ${individual.name}}">${individual.name}</a>
    </h1>
<#else>
    <h1>
        <a href="${individual.profileUrl}" title="View the profile page for
               ${individual.name}}">${individual.name}</a>
    </h1>
</#if>


<#if (depart[0].org)?? >
     <span class="title"><a class="black-text" href="${depart[0].fac}" target="_blank">${depart[0].org}</a></span>
</#if>
<#if (details[0].job)?? >
    <span class="title">${details[0].job }</span>
</#if>
<#if (extra[0].pt)?? >
  <span class="title">${extra[0].pt}</span>
</#if>

<#if (pid[0].pidv)?? >
    <a href="mailto:${pid[0].pidv}" class="title title-smaller blue-text">${pid[0].pidv}</a>
</#if>


<#if keywords?has_content >
   <div class="shortview_person-research-areas">
        <#if keywords?has_content>
           <b>&Aacute;reas de Inter&eacute;s: </b>
           <#list keywords as row>
              <a  class="shortview_person-research-area blue-text" href="${row.href}" >${row.word}<#if (row?has_next)>;</#if></a>
           </#list>
        </#if>
   </div>
</#if>
</li>


