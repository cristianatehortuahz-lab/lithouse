/* $This file is distributed under the terms of the license in LICENSE$ */
/* v5.9: Relative DOM traversal to fix qTip ID duplication bugs */

$(document).ready(function(){

    $('head').append('<style id="downloadCSS">'
        +'.qtip { font-size: 14px; max-width: none !important; z-index: 9999 !important; }'
        +'.downloadTip { background: #ffffff; border-radius: 12px; border: 1px solid #e5e7eb; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.15); }'
        +'.downloadTip .qtip-content { padding: 0 !important; }'
        +'</style>');

    window._dlUpdate = function(inputElem) {
        var val = inputElem.value;
        val = Math.max(10, Math.min(1000, parseInt(val) || 500));
        
        var container = $(inputElem).closest('.qtip-content');
        var csvLink = container.find('a[href*="csv=1"]');
        var xmlLink = container.find('a[href*="xml=1"]');
        
        if (csvLink.length && csvLink.attr('href')) {
            csvLink.attr('href', csvLink.attr('href').replace(/documentsNumber=\d+/, 'documentsNumber=' + val));
        }
        if (xmlLink.length && xmlLink.attr('href')) {
            xmlLink.attr('href', xmlLink.attr('href').replace(/documentsNumber=\d+/, 'documentsNumber=' + val));
        }
    };

	try {
        $('img#downloadIcon').qtip(
            {
                prerender: true,
                content: {
                    text:  '<div class="download-popup-container">'
                        +    '<div class="download-options-side">'
                        +        '<div class="download-header">Descargar resultados de b&uacute;squeda</div>'
                        +        '<div class="download-url"><a id="xmlDownload" href="'+urlsBase+'/search?'+queryText+'&xml=1&documentsNumber=500"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg> Descargar en XML</a></div>'
                        +        '<div class="download-url"><a id="csvDownload" href="'+urlsBase+'/search?'+queryText+'&csv=1&documentsNumber=500"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg> Descargar en CSV</a></div>'
                        +    '</div>'
                        +    '<div class="download-settings-side">'
                        +        '<label>M&aacute;ximo de registros</label>'
                        +        '<input type="number" id="download-amount" min="10" max="1000" step="10" value="500" oninput="window._dlUpdate(this)" onchange="window._dlUpdate(this)" />'
                        +        '<a class="close" href="#">CERRAR</a>'
                        +    '</div>'
                        + '</div>'
                },
                position: {
                    my: 'top right',
                    at: 'bottom right',
                    adjust: { x: 10, y: 5 }
                },
                show: {
                    event: 'click'
                },
                hide: {
                    event: 'click'
                },
                style: {
                    classes: 'downloadTip',
                    width: 460
                }
            });
    } catch(e) { console.warn("qTip no disponible"); }

    // Prevent close link for URI qTip from requesting bogus '#' href
    $(document).on('click', 'a.close', function() {
        $('#downloadIcon').qtip("hide");
        return false;
    });

});
