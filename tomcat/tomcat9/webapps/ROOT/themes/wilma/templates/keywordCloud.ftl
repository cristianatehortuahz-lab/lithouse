<div id="body">
  <h2>${individual.name}</h2>
  <div id="word-selection">
    <label>
      <input type="radio" name="word-selection" checked value="featuredKeywords" id="featured-k"/>
      Featured Keywords
    </label>
    <label>
      <input type="radio" name="word-selection" value="articleKeywords" id="article-k"/>
      Article Keywords
    </label>
    <label>
      <input type="radio" name="word-selection" value="articleSubjectAreas" id="external-k"/>
      External Vocab. Terms
    </label>
    <#--
    <label>
      <input type="radio" name="word-selection" value="minedKeywords" id="mixed-k"/>
      Mined Keywords
    </label>
    -->
  </div>
  <div id="cloud"></div>
</div>

<script>
  var baseUrl = '${urls.base}';
  var individualUri = '${individual.URI}';
</script>

${scripts.add('<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.17/d3.min.js"></script>',
    '<script type="text/javascript" src="https://cdn.rawgit.com/jasondavies/d3-cloud/v1.2.1/build/d3.layout.cloud.js"></script>',
    '<script type="text/javascript" src="${urls.base}/themes/wilma/js/cloudword.js"></script>')}

${stylesheets.add('<link rel="stylesheet" href="${urls.base}/themes/wilma/css/wordcloud-section.css" />')}
