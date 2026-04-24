<#assign baseURL ="https://research-hub.urosario.edu.co"> 

<script type="application/ld+json">
  <#if coreSchemal??>
  {
    "@context": "https://schema.org",
    "@type": "Person",
    "@id": "${baseURL}/individual/${individual.localName}",
    "url": "${baseURL}/individual/${individual.localName}",
    <#list coreSchemal as infPerson>
      <#if infPerson["name"]??>
        "name": "${infPerson["name"]}",
      </#if>
      <#if infPerson["jobTitle"]??>
        "jobTitle": "${infPerson["jobTitle"]}",
      </#if>
      <#if infPerson["imagen"]??>
        "image": "${baseURL}${infPerson["imagen"]}",
      </#if>
      <#if infPerson["email"]??>
        "email": "${infPerson["email"]}",
      </#if>
      <#if infPerson["telephone"]??>
        "telephone": "${infPerson["telephone"]}", 
      </#if>

    <#if positionSchemal??>
    "affiliation": [
    <#list positionSchemal as position>
      {
        "@type": "Organization",
        <#if position["affi1"]?? && position["label1"]??>
          "name": "${position["affi1"]} - Universidad del Rosario",
          "startDate": "${position["label1"]}"
        </#if>
      }<#if position_has_next>,</#if>
    </#list>
    </#if>
    ],

    "sameAs": [
      <#if infPerson["scopusId"]??>
        "https://www.scopus.com/authid/detail.uri?authorId=${infPerson["scopusId"]}",
      </#if>
      <#assign enlaces = [] />
      <#list ["googlescholar","pure","cvlac","orcid","repec","behance","researchgate","researcherId","youtubeVideo","curriculum","curriculumpdf"] as key>
        <#if coreSchemal[0][key]??>
          <#assign enlaces = enlaces + [coreSchemal[0][key]] />
        </#if>
      </#list>
      <#list enlaces as enlace>
        "${enlace}"<#if enlace_has_next>,</#if>
      </#list>
    ],
    </#list>

    "worksFor": {
      "@type": "Organization",
      "name": "Universidad del Rosario",
      "location": {
      "@type": "Place",
      "name": "Bogotá, Colombia",
      "address": {
        "@type": "PostalAddress",
        "streetAddress": "Calle 12C Nº 6-25",
        "addressLocality": "Bogotá",
        "addressCountry": "Colombia"
      }
      }
    }
  }
  <#else>
    {
      "@context": "https://schema.org",
      "@graph": [
        {
          "@type": "Organization",
          "@id": "https://www.urosario.edu.co/#organization",
          "name": "Universidad del Rosario",
          "alternateName": "URosario",
          "url": "https://www.urosario.edu.co/",
          "logo": {
            "@type": "ImageObject",
            "url": "https://research-hub.urosario.edu.co/themes/wilma/images/header/logoUR.webp",
            "width": 250,
            "height": 60
          },
          "contactPoint": {
            "@type": "ContactPoint",
            "telephone": "+57-1-2970200",
            "contactType": "General Information",
            "areaServed": "CO",
            "availableLanguage": ["es", "en"]
          },
          "address": {
            "@type": "PostalAddress",
            "streetAddress": "Calle 12C No. 6-25",
            "addressLocality": "Bogotá",
            "addressRegion": "Cundinamarca",
            "postalCode": "111711",
            "addressCountry": "CO"
          },
          "sameAs": [
            "https://www.facebook.com/uRosario",
            "https://twitter.com/uRosario",
            "https://www.linkedin.com/school/universidad-del-rosario/",
            "https://www.instagram.com/uRosario",
            "https://www.youtube.com/@UniversidaddelRosarionews"
          ]
        },
        {
          "@type": "WebSite",
          "@id": "https://research-hub.urosario.edu.co/#website",
          "url": "https://research-hub.urosario.edu.co/",
          "name": "HUB-UR | Services & Experts Finder",
          "alternateName": "Portal de Fortalezas Institucionales - Universidad del Rosario",
          "description": "Portal que centraliza información sobre expertos, laboratorios, recursos y capacidades de investigación de la Universidad del Rosario, facilitando la colaboración científica y académica.",
          "publisher": { "@id": "https://www.urosario.edu.co/#organization" },
          "inLanguage": "es-CO",
          "potentialAction": {
            "@type": "SearchAction",
            "target": {
              "@type": "EntryPoint",
              "urlTemplate": "https://research-hub.urosario.edu.co/search"
            }
          }
        }
      ]
    }
  </#if>
</script>