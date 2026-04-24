<#-- Default individual search view -->

<#import "lib-properties.ftl" as p>

<div class="shortview_person">
        <div class="col-md-2 col-xs-2">
          <a href="${individual.profileUrl}" class="shortview_person-img">
                <!-- <img src="http://via.placeholder.com/140x140"></img> -->
                <#if (individual.thumbUrl)??>
                  <img src="${individual.thumbUrl}" width="100%" alt="${individual.name}" style="border-radius:5px"/>
                </#if>
          </a>
        </div>
        <div class="col-md-10 col-xs-10">
          <div class="shortview_person-data">
                <div class="person-header">
                        <div class="col-md-12 col-xs-12 text-left">
                                <h3 class="shortview_person-name"><a href="${individual.profileUrl}" title="${i18n().name}">${individual.name}</a></h3>
                                  <#if (depart[0].org)?? >
                                    <span class="title"><a class="black-text" href="${depart[0].fac}" target="_blank">${depart[0].org}</a></span>
                                </#if>
                                <#if (details[0].job )?? >
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
                                           <b class="title-smaller">&Aacute;reas de Inter&eacute;s: </b>
                                           <#list keywords as row>
                                                <a  class="title-smaller blue-text shortview_person-research-area"  href="${row.href}" target="_blank">${row.word}<#if (row?has_next)>;</#if></a>
                                           </#list>
					</#if>
                                   </div>
                                </#if>


                        </div>
                </div>
          </div>
        </div>
</div>
