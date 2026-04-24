<#import "lib-properties.ftl" as p>
<#import "lib-vivo-properties.ftl" as p>

<li class="col-lg-3 col-md-6 col-sm-12"  role="listitem" role="navigation">
    <div class="card">
        <#if (individual.thumbUrl)??>
            <img src="${individual.thumbUrl}" class="card-img-top" alt="${individual.name}" />
            
        <#else>
            <img src="${urls.base}/images/placeholders/person.thumbnail.jpg" class="card-img-top" alt="${individual.name}" />
        </#if>
        <div class="card-body">
            <h5 class="card-title">
                <a href="${individual.profileUrl}" title="${i18n().view_profile_page_for} ${individual.name}">${individual.name}</a>
            </h5>
            <#--  <br/>  -->
            <section class="card-text">
                <#if (depart[0].div)?? >
                    <a href="${depart[0].fac}" target="_blank">${depart[0].div}</a>
                <#elseif (depart[0].org)?? >
                    <a href="${depart[0].fac}" target="_blank">${depart[0].org}</a>
                <#elseif (depart[0].grp)?? >
                    <a href="${depart[0].fac}" target="_blank">${depart[0].grp}</a>
                </#if>
            </section>
            
            <p class="card-footer">
                <#list details as job>
                    <#--  <br/>  -->
                    ${job.job}
                </#list>
            </p>
                <#--  <#if (details[0].job)?? >
                    <span class="title">${details[0].job }</span>
                </#if>  -->
                <#if (extra[0].pt)?? >
                    <span class="card-text">${extra[0].pt}</span>
                </#if>

                
        </div>
    </div>
</li>


<script>
  const ul = document.getElementById("milista");
  const items = Array.from(ul.querySelectorAll("li"));

  // Ordenar por el nombre dentro de h5 > a
  items.sort((a, b) => {
    const nameA = a.querySelector("h5.card-title a").textContent.trim();
    const nameB = b.querySelector("h5.card-title a").textContent.trim();
    return nameA.localeCompare(nameB);
  });

  // Reinserta los items ordenados
  ul.innerHTML = "";
  items.forEach(item => ul.appendChild(item));
</script>