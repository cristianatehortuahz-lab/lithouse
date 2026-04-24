
<#import "lib-properties.ftl" as p>

<div class="individual" role="listitem" role="navigation" id="programIndividual">
		<h1>
			<a href="${individual.profileUrl}" title="View the profile page for
				   ${individual.name}}">${individual.name}</a>
		</h1>
		<div id="programDescription">
		<#if (ProgramModality[0].modality)??  >
			<span class="title"><b>Degree:</b> ${ProgramModality[0].modality}</span>
		</#if>
		<#if (ProgramLevel[0].level)??  >
			<span class="title"> | <b> Level:</b>  ${ProgramLevel[0].level}</span>
		</#if>

		<#if (ProgramSemester[0].semester)?? >
			<span class="title"> | <b> Duration:</b> ${ProgramSemester[0].semester}</span>
		</#if>
		</div>
</div>

