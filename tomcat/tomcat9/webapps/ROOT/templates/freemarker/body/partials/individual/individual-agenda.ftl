<#if dateSiteLaboratory?has_content>
    <#list dateSiteLaboratory as Place>
        <#assign agendaLab = Place.agenda!>
        <#--
	<button id="agendar" class="buttonAgenda"name="agendaEspacio">
            <a href="${agendaLab}"></a>
        </button>
	-->
	<#if agendaLab?? && agendaLab?has_content>
	        <button onclick="window.open('${agendaLab}', '_blank')" id="agendar" class="buttonAgenda"name="agendaEspacio"></button>    
	</#if>
</#list>
</#if>
