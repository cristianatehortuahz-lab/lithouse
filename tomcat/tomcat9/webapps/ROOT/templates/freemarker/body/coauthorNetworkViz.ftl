<style>
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
    height: 85vh; /* Se usa un porcentaje alto para llenar el espacio sin causar doble scrollbar */
    min-height: 800px;
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
    src="/mapadeCoauthor/"
    title="Mapa de Coautorías"
    allowfullscreen
    loading="eager"
    sandbox="allow-scripts allow-same-origin allow-forms allow-popups"
  ></iframe>
</div>
