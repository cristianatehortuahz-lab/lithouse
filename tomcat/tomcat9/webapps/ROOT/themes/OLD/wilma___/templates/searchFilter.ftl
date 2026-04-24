<section id="intro" role="region">
    <div id="search-home" role="region">
        <#--  <h3>${i18n().intro_searchvivo} <span class="search-filter-selected">filteredSearch</span></h3>    -->
        <h3><span class="search-filter-selected">filteredSearch</span></h3>

        <fieldset>
            <legend>${i18n().search_form}</legend>
            <form id="search-homepage" action="${urls.search}" name="search-home" role="search" method="GET" >
                <div id="search-home-field">
                    <input type="text" name="querytext" class="search-homepage" value="" autocapitalize="off" />
                    <a class="filter-search filter-default" href="#" title="${i18n().intro_filtersearch}">
                        <span class="displace">${i18n().intro_filtersearch}</span>
                    </a>
                    <input type="submit" value="${i18n().search_button}" class="search" />
                    <input type="hidden" name="filters_category"  value="" autocapitalize="off" />
                </div>
                <ul id="filter-search-nav">
                    <li><a class="active" href="">${i18n().all_capitalized}</a></li>
                    <@lh.allClassGroupNames vClassGroups! />
                </ul>
            </form>
        </fieldset>
    </div> <!-- #search-home -->
</section>
