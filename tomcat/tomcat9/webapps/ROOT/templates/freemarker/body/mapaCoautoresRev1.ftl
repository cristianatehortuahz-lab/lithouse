<style>
  /* Elimina padding del wrapper de VIVO para que el mapa sea fullscreen bajo el navbar */
  #wrapper-content,
  #content,
  #content-wrapper,
  #main-content,
  .contentsBrowse,
  #pageContent {
    padding: 0 !important;
    margin: 0 !important;
    max-width: 100% !important;
    width: 100% !important;
  }
  #mapa-coautores-container {
    width: 100%;
    height: calc(100vh - 55px);
    border: none;
    display: block;
    overflow: hidden;
  }
  #mapa-coautores-container iframe {
    width: 100%;
    height: 100%;
    border: none;
  }
</style>

<div id="mapa-coautores-container">
  <iframe
    src="/coauthorNetwork/"
    title="Mapa de Coautorías · Red de Investigadores HUB-UR"
    allowfullscreen
    loading="eager"
    sandbox="allow-scripts allow-same-origin allow-forms allow-popups"
  ></iframe>
</div>
