<!-- #search-home UR JCCJ-->
										<div class="row" id="buscador_home">
												<section id="search-home" role="region">
													<h3>${i18n().intro_searchvivo} <span class="search-filter-selected">filteredSearch</span>
													</h3>

													<fieldset>
														<legend>${i18n().search_form}</legend>
														<form id="search-homepage" action="${urls.search}" name="search-home" role="search" method="post" > 
															<div id="search-home-field">
																<input type="text" name="querytext" class="search-homepage" value="" autocapitalize="off" />
																<input type="submit" value="${i18n().search_button}" class="search" />
																<input type="hidden" name="classgroup"  value="" autocapitalize="off" />
															</div>

															<a class="filter-search filter-default" href="#" title="${i18n().intro_filtersearch}">
																<span class="displace">${i18n().intro_filtersearch}</span>
															</a>

															<ul id="filter-search-nav">
																<li>
																	<a class="active" href="">${i18n().all_capitalized}</a>
																</li>
																<@lh.allClassGroupNames vClassGroups! />  
															</ul>
														</form>
													</fieldset>
												</section> 
											</div>


<!-- #fin search-home -->