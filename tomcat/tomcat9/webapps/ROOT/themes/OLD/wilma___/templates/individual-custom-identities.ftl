<#-- individual-custom-identities.ftl -->
<#if ids??>
    <div class="external-ids">
        <#-- Iteramos sobre la lista de resultados. Si la consulta retorna un solo individuo, solo habrá un mapa en la lista. -->
        <#list ids as id>
            <#if id.youtubeVideo?? || id.curriculum?? || id.curriculumpdf?? || id.curriculumpdf_esp??>
                <div class="dropdown" style="text-align: center">
                    <button class="btn btn-primary dropdown-toggle" type="button" id="curriculum-drop" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        Curriculum
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" aria-labelledby="curriculum-drop">
                        <#if id.youtubeVideo?has_content>
                            <li><a data-toggle="modal" data-target="#videoModal-${id?index}">
                                Video
                            </a></li>
                        </#if>
                        <#if id.curriculum?has_content>
                            <li><a href="${id.curriculum}" target="_blank">
                                Online
                            </a></li>
                        </#if>
                        <#if id.curriculumpdf?has_content>
                            <li><a href="${id.curriculumpdf}" target="_blank">
                                PDF
                            </a></li>
                        </#if>
                        <#if id.curriculumpdf_esp?has_content>
                            <li><a href="${id.curriculumpdf_esp}" target="_blank">
                                PDF_ES
                            </a></li>
                        </#if>
                    </ul>
                </div>
            </#if>
            <ul>
                <#-- Usamos ?has_content para verificar si el valor existe y no está vacío/nulo antes de mostrarlo -->
                <#if id.cvlac?has_content>
                    <a target="_blank" href="${id.cvlac}"><img src="${urls.base}/themes/wilma/images/logos/cvac.png" height="30" width="30" title="CVLAC"></img></a>
                </#if>
                <#if id.orcid?has_content>
	                <a target="_blank"  href="${id.orcid}"><img src="${urls.base}/themes/wilma/images/logos/orcid.png" height="30" width="30" title="ORCID"></img></a>
                </#if>
                <#if id.googlescholar?has_content>
                    <a target="_blank"  href="${id.googlescholar}"><img src="${urls.base}/themes/wilma/images/logos/scholar.png" height="30" width="30" title="Google Scholar"></img></a>
                </#if>
                <#if id.researchgate?has_content>
                    <a target="_blank"  href="${id.researchgate}"><img src="${urls.base}/themes/wilma/images/logos/rgate.png" height="30" width="30" title="ResearchGate"></img></a>
                </#if>
                <#if id.researcherId?has_content>
                    <a target="_blank"  href="${id.researcherId}"><img src="${urls.base}/themes/wilma/images/logos/researcherid.png" height="30" width="30" title="ResearcherID"></img> </a>
                </#if>
                <#if id.scopusId?has_content>
                    <a target="_blank"  href="https://www.scopus.com/authid/detail.url?authorId=${id.scopusId}"><img src="${urls.base}/themes/wilma/images/logos/scoopus.png" height="30" width="30" title="Scopus"></img> </a>
                </#if>
                <#if id.pure?has_content>
                    <a target="_blank"  href="${id.pure}"><img src="${urls.base}/themes/wilma/images/logos/pure.png" height="30" width="30" title="Pure"></img> </a>
                </#if>
                <#if id.repec?has_content> 
                    <a target="_blank" class="test"  href="${id.repec}"><img src="${urls.base}/themes/wilma/images/logos/repec.jpg" height="30" width="30" title="Repec"></img> </a>
                </#if>
                <#if id.behance?has_content>
                    <a target="_blank" class="test"  href="${id.behance}"><img src="${urls.base}/themes/wilma/images/logos/behance.png" height="30" width="30" title="Behance"></img> </a>
                </#if>
            </ul>
            <#-- Modal para Video de YouTube -->
                <#if id.youtubeVideo?has_content>
                    <div class="modal fade" id="videoModal-${id?index}" tabindex="-1" role="dialog" aria-labelledby="videoModalLabel-${id?index}">
                        <div class="modal-dialog modal-xl" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h4 class="modal-title" id="videoModalLabel-${id?index}">Video curriculum</h4>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                </div>
                                <div class="modal-body video-modal-body">
                                    <iframe width="100%" height="100%" src="${id.youtubeVideo}" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                                </div>
                            </div>
                        </div>
                    </div>
                </#if>
        </#list>
    </div>
</#if>