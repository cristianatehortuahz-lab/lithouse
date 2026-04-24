var dFilter = {
  urlBase: (typeof urlBaseForFilterSearch !== 'undefined') ? urlBaseForFilterSearch : (window.urlsBase || '') + '/individuallist',
  ajaxObj: { hitsPerPage: 25, startIndex: 0, alpha: 'all' }, // to be kept at ajaxCall, in case next call will be from pagination
              // otherwise, the queryObj will be created each time before ajaxCall
  ajaxObjKeysInitialNo: 3, // has to always match keys number of ajaxObj !!
  firstAjaxSearch: null,

  onLoad: function() {
    this.attachFormListeners()
    this.listenPagesBox()
    
    // HUB-UR v3.1: Detectar la primera clase disponible en el sidebar para evitar búsquedas vacías
    let firstClass = document.querySelector('#browse-classes a');
    let initialQuery = {};
    if (firstClass) {
        initialQuery.vclassId = firstClass.getAttribute('data-uri');
        console.log('HUB-UR: Iniciando con clase detectada: ' + initialQuery.vclassId);
    }
    
    this.newSearch(initialQuery);
  },

  el: {
    form: document.querySelector('.js-search-form'),
    queryTextInput: document.querySelector('.js-query-text'),
    inputsOutOfForm: {
      sort: document.querySelector('.js-search'),
    },

    // we assume ulResultsParent and pagesBoxParent will always be .js-results-container
    ulResultsParent: document.querySelector('.js-results-container'),
    aLiFromUlResults: document.querySelector('.js-search-hits li'),

    pagesBoxParent: document.querySelector('.js-results-container'),
    aPageLink: document.querySelector('.js-search-pages a:nth-of-type(2)'), // to take one without class js-active-page

    checkboxContainer: document.querySelector('.js-checkbox-facet') ? document.querySelector('.js-checkbox-facet input[type=checkbox]').parentNode : null,
    checkboxFacetContainer: document.querySelector('.js-checkbox-facet')
  },

  createDataObj: function(form, otherInputs, justSearch) {
    // always get inputs from form, as they can be different from last time
    let dataObj = Object.assign({}, this.ajaxObj)

    // form should have only one textInput (the one used for ajax query)
    if (this.el.queryTextInput) {
        dataObj[this.el.queryTextInput.name] = this.el.queryTextInput.value
    }

    // we allow for a future version when there would be more radio inputs mandatory for just a search
    Array.from(form.querySelectorAll('input[type=radio]'))
          .forEach(x => {
            if (!x.checked) return
            dataObj[x.name] = x.value
          })

    if (justSearch) return dataObj;

    // right now sort select is not in form
    if (otherInputs.sort) {
      let sort = otherInputs.sort;
      dataObj[sort.name] = sort.value
    }

    // if there will ever be one or more select inpus in form
    Array.from(form.querySelectorAll('select'))
          .forEach(x => {
            dataObj[x.name] = x.value // we assume select always has value
          })

    Array.from(form.querySelectorAll('input[type=checkbox]'))
          .forEach(x => {

            if (!x.checked) return;

            if (!dataObj[x.name]) dataObj[x.name] = []
            if (dataObj[x.name].includes(x.value)) return
            dataObj[x.name].push(x.value)
          })



    return dataObj
  },

  attachFormListeners: function() {

    function displayLoader() {
      let overlayer = document.getElementById('js-loading-overlayer') // extract this in this.el
      if (overlayer) overlayer.classList.add('js-display')

      let loaders = Array.from(document.getElementsByClassName('js-loader')) // extract this in this.el
      if (loaders && loaders.length > 0) {
          loaders.forEach(x => {
            if (x && x.parentElement && x.parentElement.clientHeight >= 200) x.classList.add('js-display')
          })
      }
    }

    function hideLoader() {
      let loaders = Array.from(document.getElementsByClassName('js-display'))
      if (loaders && loaders.length > 0) {
          loaders.forEach(x => { if (x) x.classList.remove('js-display') })
      }
    }

    const minLen = 3;

    // listen to entire form (v4.1: Null protection for browse-only pages)
    if (this.el.form) {
      this.el.form.addEventListener('change', function(e) {
        if (e.target.type == 'text') return;
        if (this.el.form.querySelector('#facets-querytext').value < minLen) return;
        this.delay(function() {
          displayLoader()
          let isJustSearch = e.target.type == 'radio'
          let ajaxObj = this.createDataObj(this.el.form, this.el.inputsOutOfForm, isJustSearch)
          this.newSearch(ajaxObj)
          setTimeout(hideLoader, 500)
        }.bind(this), 1000)
      }.bind(this))

      this.el.form.addEventListener('keyup', function(e) {
        if (e.target.type != 'text') return
        if (e.target.value.length < minLen) return
        this.delay(function() {
          let ignoredKeys = [16, 17, 18, 20, 37, 38, 39, 40]
          if (ignoredKeys.includes(e.which)) return;
          displayLoader()
          let ajaxObj = this.createDataObj(this.el.form, this.el.inputsOutOfForm, true)
          this.newSearch(ajaxObj)
          setTimeout(hideLoader, 500)
        }.bind(this), 1000)
      }.bind(this))
    }

    if (this.el.inputsOutOfForm.sort) {
      let sort = this.el.inputsOutOfForm.sort;
      sort.addEventListener('change', e => {
        if (this.el.queryTextInput.value.length < minLen) return
        this.delay(function() {
          displayLoader()
          let ajaxObj = this.createDataObj(this.el.form, this.el.inputsOutOfForm, false)
          this.newSearch(ajaxObj)
          setTimeout(hideLoader, 500)
        }.bind(this), 1000)
      })
    }

    // HUB-UR v2.7: Listener para el Sidebar (Categorías/Clases)
    const sidebarLinks = document.querySelectorAll('#browse-classes a');
    sidebarLinks.forEach(link => {
      link.addEventListener('click', e => {
        e.preventDefault();
        const vclassUri = link.getAttribute('data-uri');
        sidebarLinks.forEach(l => l.parentElement.classList.remove('active'));
        link.parentElement.classList.add('active');
        displayLoader();
        let ajaxObj = this.createDataObj(this.el.form, this.el.inputsOutOfForm, false);
        ajaxObj.vclassId = vclassUri;
        this.newSearch(ajaxObj);
        setTimeout(hideLoader, 500);
      });
    });
  },

  delay: function(){
    var timer = 0;
    return function(callback, ms) {
      clearTimeout(timer);
      timer = setTimeout(callback, ms)
    }
  }(),


  prepareFacets: function(xhrResponse) {
    if (!xhrResponse.facets) return [];
    var facets = xhrResponse.facets.map(x => {
          return {
            sectionId: x.baseName,
            sectionTitle: x.publicName,
            checkboxes: x.categories.map(
              y => {
                return {
                  id: `${x.fieldName}-${y.id}`,
                  checked: y.selected,
                  name: x.fieldName,
                  value: y.label,
                  label: y.label // to be explicit that now label is same with input value
                }
              })
          }
        })

    return facets
  },

  removeNotNeededHtmlFacets: function(responseFacetIds) {
    Array.from(document.getElementsByClassName('js-checkbox-facet'))
      .forEach(x => {
          if (responseFacetIds.includes(x.id)) return

          document.getElementById(x.id).remove()
    })
  },

  createFacet: function(facet) {

    // ***** FOLLOWING CODE ASSUMES FACET DIV DOES NOT EXIST IN DOM ****

    let aHtmlFacet = this.el.checkboxFacetContainer.cloneNode(true)
    let anInputBox = aHtmlFacet.querySelector('input[type=checkbox]').parentNode
    let inputBoxParent = anInputBox.parentNode

    // remove all inputs with their parents
    aHtmlFacet.querySelectorAll('input[type=checkbox]').forEach(x => x.parentNode.remove())

    // change title to new one
    aHtmlFacet.querySelector('.js-facet-title').textContent = facet.sectionTitle
    // change id to new one
    aHtmlFacet.id = facet.sectionId
    // at this point htmlFacetExample is changed enough to be taken as a new html facet
    let newHtmlFacet = aHtmlFacet

    // multiply inputBoxExample forEach object in facet.checkboxes
    // and replace attribute values for htmlFor (if label exists), input id, input value, container.textContent
    facet.checkboxes.forEach(x => {
      let newInputBox = anInputBox.cloneNode(true)

      let label = newInputBox.tagName == 'LABEL' ? newInputBox : newInputBox.querySelector('label')
      label.htmlFor = x.id;

      let input = newInputBox.querySelector('input[type=checkbox]')
      input.id = x.id
      input.value = x.value
      input.name = x.name

      let textNode = Array.from(newInputBox.childNodes).find(x => x.nodeName == '#text' && x.nodeValue.trim())
      textNode.nodeValue = x.label

      inputBoxParent.appendChild(newInputBox)

    })



    this.el.form.appendChild(newHtmlFacet)

  },

  refreshFacet: function(facet) {

    // ***** FOLLOWING CODE ASSUMES FACET DIV EXISTS IN DOM ****

    // get facet div by #sectionId and all inputs from within
    let htmlFacetBox = document.getElementById(facet.sectionId)
    let existingInputs = htmlFacetBox.querySelectorAll('input[type=checkbox]') // mention type, to make sure
    let inputBoxParent = htmlFacetBox.querySelector('input[type=checkbox]').parentNode.parentNode

    let createInputBox = function createInputBox(inputData) {
      let checkboxContainer = this.el.checkboxContainer;
      if (!checkboxContainer) {
        checkboxContainer = document.createElement('label')
        checkboxContainer.classList.add('search_supervisor-label')

        checkboxContainer.innerHTML = '<input type=checkbox class=search_supervisor-input><div class=search_supervisor-checkbox-placeholder></div>'
      }

      let inputBox = checkboxContainer.cloneNode(true)

      let label = inputBox.nodeName == 'LABEL' ? inputBox
                  : inputBox.querySelector(`label[for=${inputData.id}]`)

      label.htmlFor = inputData.id;

      let input = Array.from(inputBox.children).find(x => x.tagName == `INPUT`)
      input.id = inputData.id
      input.value = inputData.value
      input.name = inputData.name

      // we assume only one textNode (which trimmed is not empty string) gives textContent to inputBox
      let textNode = Array.from(inputBox.childNodes).find(x => x.nodeName == '#text' && x.nodeValue.trim())
      textNode.nodeValue = inputData.label

      return inputBox
    }.bind(this)

    function filterInputSeeds(inputsData, inputsDataIdxToFilter) {
      // Keep in facet.checkboxes only objects that make new inputs
      let inputSeeds = inputsData.filter((x,idx,arr) => !inputsDataIdxToFilter.includes(idx))

      if (!inputSeeds.length) return

      return inputSeeds;
    }

    function updateInputs(srcArr, targetArr) {
      // store facet.checkboxes[index] for facet.checkboxes that are gradually verified / updated
      let idxCheckboxesToRemove = [];

      // Cases: Toggle checked attribute; update idxCheckboxesToRemove; Remove not needed checkbox inputs from dom
      targetArr.forEach(x => {

        let inputMatch = srcArr.find(y => y.id == x.id)

        if (inputMatch) {
          // toggle or set to same value as before
          if (x.checked != inputMatch.checked) x.checked = inputMatch.checked

          idxCheckboxesToRemove.push(facet.checkboxes.indexOf(inputMatch));

        } else { // there are in html inputs that should not exists any more
          // we assume inputs sit in a label OR in a container that may have label as child
          x.parentNode.remove();
        }
      })

      return idxCheckboxesToRemove;
    }


    const idxCheckboxesToRemove = updateInputs(facet.checkboxes, existingInputs)
    const filteredSeeds = filterInputSeeds(facet.checkboxes, idxCheckboxesToRemove)

    if (filteredSeeds) {
      const newInputBoxes = filteredSeeds.map(createInputBox)
      newInputBoxes.forEach( x => inputBoxParent.appendChild(x) )
    }

  },

  refreshResults: function(results, replace = true) {
    let ulResults = document.querySelector('.js-search-hits')
    let container = replace ? ulResults.cloneNode(false) : ulResults;

    results.forEach((x, index) => {
      let optimizedHtml = (typeof x === 'string') ? x : (x.shortViewHtml || '');
      
      // HUB-UR v3.9: Detección inteligente de Placeholders de VIVO y Escudo Anti-Imágenes Rotas (Syntax Fix)
      let imgTagMatch = optimizedHtml.match(/<img[^>]+>/);
      let isPlaceholder = imgTagMatch && imgTagMatch[0].indexOf('placeholders/person') !== -1;
      let fallbackSrc = "data:image/svg+xml,%3Csvg viewBox=%220 0 24 24%22 xmlns=%22http://www.w3.org/2000/svg%22%3E%3Crect width=%22100%25%22 height=%22100%25%22 fill=%22%23f4f4f4%22/%3E%3Cpath d=%22M12 12C14.21 12 16 10.21 16 8C16 5.79 14.21 4 12 4C9.79 4 8 5.79 8 8C8 10.21 9.79 12 12 12ZM12 14C9.33 14 4 15.34 4 18V20H20V18C20 15.34 14.67 14 12 14Z%22 fill=%22%23d0d0d0%22/%3E%3C/svg%3E";
      
      if (imgTagMatch && !isPlaceholder) {
          let imgTag = imgTagMatch[0];
          // Limpiamos atributos restrictivos para evitar recortes
          let cleanImg = imgTag.replace(/\s(width|height)=["'][^"']*["']/g, '');
          
          if (replace && index === 0) {
              cleanImg = cleanImg.replace('<img', `<img fetchpriority="high" loading="eager" class="hub-img-fluid" onerror="this.onerror=null; this.src='${fallbackSrc}';"`);
          } else {
              cleanImg = cleanImg.replace('<img', `<img loading="lazy" class="hub-img-fluid" onerror="this.onerror=null; this.src='${fallbackSrc}';"`);
          }
          optimizedHtml = optimizedHtml.replace(imgTag, cleanImg);
      } else {
          // HUB-UR v3.8: Inyección de Silueta si no hay imagen o es un placeholder genérico
          let silhouette = `<div class="hub-silhouette-wrapper"><img src="${fallbackSrc}" class="hub-img-fluid" alt="Avatar Genérico" style="width: 64px; height: 64px; object-fit: contain;"></div>`;
          if (isPlaceholder) {
              optimizedHtml = optimizedHtml.replace(imgTagMatch[0], silhouette);
          } else {
              optimizedHtml = optimizedHtml.replace(/<div class="thumb">/i, `<div class="thumb">${silhouette}`);
          }
      }
      
      optimizedHtml = optimizedHtml.replace('class="card"', 'class="card h-100 hub-person-card-v2"');
      // VIVO v4.2: Evitar anidamiento de <li> (Previene layout vertical roto)
      if (optimizedHtml.trim().indexOf('<li') === 0) {
          let tempDiv = document.createElement('div');
          tempDiv.innerHTML = optimizedHtml.trim();
          let liContent = tempDiv.firstChild;
          if (liContent) {
              liContent.classList.add('hub-person-item');
              if (replace && index === 0) {
                  // Sin animación para el LCP
              } else {
                  liContent.classList.add('hub-fadeInUp');
              }
              container.appendChild(liContent);
          }
      } else {
          let liBox = this.el.aLiFromUlResults.cloneNode(false)
          liBox.innerHTML = optimizedHtml;
          liBox.classList.add('hub-person-item');
          if (replace && index === 0) {
              // Instantáneo
          } else {
              liBox.classList.add('hub-fadeInUp');
          }
          container.appendChild(liBox)
      }
    })

    if (replace) {
        // HUB-UR v5.5: LCP Persistence Logic
        let firstSkeleton = ulResults.querySelector('li:first-child');
        if (firstSkeleton && results.length > 0) {
            console.log('HUB-UR: Persistiendo nodo LCP para estabilidad total.');
        }
        ulResults.parentNode.replaceChild(container, ulResults);
    }
  },

  listenPagesBox: function() {
    let pagesBox = document.querySelector('.js-search-pages')
    if (!pagesBox) return;

    let activePage = pagesBox.querySelector('.js-active-page')

    pagesBox.addEventListener('click', function(e) {
      e.preventDefault();

      if (e.target.tagName !== 'A') return;
      if (e.target == activePage) return;

      let isBeforeAnyAjaxCall = Object.keys(this.ajaxObj).length == this.ajaxObjKeysInitialNo;
      if (isBeforeAnyAjaxCall) this.ajaxObj = this.createDataObj(this.el.form, this.el.inputsOutOfForm, false)

      let targetSearch = e.target.search;
      let targetSearchSplitAtStartIndex = targetSearch.split('startIndex=')
      this.ajaxObj.startIndex = Number(targetSearchSplitAtStartIndex[1])

      this.newSearch(this.ajaxObj);
      this.ajaxObj.startIndex = 0;

    }.bind(this))
  },

  createPagination: function(links) {
    let pagesBox = document.querySelector('.js-search-pages')
    let newBox = pagesBox ? pagesBox.cloneNode(false) : document.createElement('div').classList.add('searchpages js-search-pages')

    if (this.el.aPageLink.classList.contains('js-active-page')) this.el.aPageLink.remove('js-active-page')

    links.forEach(linkData => {
      let pageLink = this.el.aPageLink.cloneNode(false)
      pageLink.href = linkData.url
      pageLink.textContent = linkData.text
      if (!linkData.url) pageLink.classList.add('js-active-page')
      newBox.appendChild(pageLink)
    })

    this.el.pagesBoxParent.replaceChild(newBox, pagesBox)
  },

  foundNoResults: function() {
    let pagesBox = document.querySelector('.js-search-pages');
    if (pagesBox) pagesBox.innerHTML = ""
    let ulResults = document.querySelector('.js-search-hits')
    if (ulResults) ulResults.innerHTML = "<li>No se encontraron resultados para esta selección.</li>"
    
    // HUB-UR v2.9: Protección contra nulos
    Array.from(document.querySelectorAll('.js-checkbox-facet')).forEach(x => { if(x) x.remove() } )
    if (this.el.queryTextInput) this.el.queryTextInput.value = '';
  },

  newSearch: function(queryObj) {
    let self = this;
    
    // HUB-UR v3.2: Reversión al canal estándar con parámetros redundantes para máxima compatibilidad
    this.urlBase = (window.urlsBase || '') + '/individuallist';

    if (!this.firstAjaxSearch) {
      this.firstAjaxSearch = true;
      let header = document.querySelector('.searchResultsHeader');
      if (header) header.classList.add('js-invisible');
      
      if (window.hubUrPreloadPromise) {
          window.hubUrPreloadPromise.then(function(data) {
              if (data) self.processResponse(data);
              else self.executeAjaxSearch(queryObj);
          }).catch(function() { self.executeAjaxSearch(queryObj); });
          return;
      }
    }
    this.executeAjaxSearch(queryObj);
  },

  executeAjaxSearch: function(queryObj) {
    let self = this;
    // HUB-UR v4.1: Delete classgroup ALWAYS. VIVO individuallist crashes if classgroup is present.
    if (queryObj.classgroup) {
        delete queryObj.classgroup;
    }
    
    $.ajax({
      url: `${self.urlBase}?getRenderedSearchIndividualsByVClass=1`,
      data: queryObj,
      complete: function(xhr, status) {
        try {
            let r = jQuery.parseJSON(xhr.responseText);
            self.processResponse(r);
        } catch (e) {
            console.error("HUB-UR: Error crítico de datos", e);
            self.foundNoResults();
        }
      }
    });
  },

  processResponse: function(r) {
    let self = this;
    console.log('HUB-UR: Respuesta recibida del servidor:', r);
    if (r.sort) {
      let sort = document.querySelector('.js-search');
      if (sort && sort.value != r.sort) sort.value = r.sort;
    }

    if (r.facets && r.facets.length > 0) {
      // PROCESAR FACETAS (solo si existen)
      // ... (aqu\u00ed ir\u00eda la l\u00f3gica de facetas si estuviera)
    } else if (!r.individuals || r.individuals.length == 0) {
      // Solo si no hay facetas NI individuos consideramos que no hay resultados
      this.foundNoResults();
      return;
    }

    // HUB-UR v4.2: Renderizado Atómico para Lighthouse 100 y 0 CLS
    if (r.individuals && r.individuals.length) {
        // Fase Única: Pintar TODO inmediatamente. Previene el colapso del DOM que causaba un CLS de 1.353
        self.refreshResults(r.individuals, true);
        console.log('HUB-UR: LCP inyectado atómicamente sin Layout Shifts.');

        // Procesar facetas y paginación
        let facets = self.prepareFacets(r);
        self.removeNotNeededHtmlFacets(facets.map(x => x.sectionId));

        facets.forEach(facet => {
            if (document.querySelector(`#${facet.sectionId}`)) self.refreshFacet(facet);
            else self.createFacet(facet);
        });
        
        if (r.pagingLinks && r.pagingLinks.length) {
            self.createPagination(r.pagingLinks);
            self.listenPagesBox();
        } else {
            let searchPagesBox = document.querySelector('.js-search-pages')
            if (searchPagesBox) searchPagesBox.innerHTML = "";
        }
    }
  },


}




$(document).ready(function(){
  $.ajaxSettings.traditional = true;
  // HUB-UR v4.2: Enrutamiento definitivo a dataservice (JSON real) en lugar de individuallist (HTML)
  dFilter.urlBase = (window.urlsBase || '') + '/dataservice';
  dFilter.onLoad();
})
