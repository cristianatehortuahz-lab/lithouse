var dFilter = {
  urlBase: urlBaseForFilterSearch,
  ajaxObj: { hitsPerPage: 25, startIndex: 0 }, // to be kept at ajaxCall, in case next call will be from pagination
              // otherwise, the queryObj will be created each time before ajaxCall
  ajaxObjKeysInitialNo: 2, // has to always match keys number of ajaxObj !!
  firstAjaxSearch: null,

  onLoad: function() {
    this.attachFormListeners()
    this.listenPagesBox()
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
    //aLiFromUlResults: document.querySelector('#wrapper-results li'),

    pagesBoxParent: document.querySelector('.js-results-container'),
    aPageLink: document.querySelector('.js-search-pages a:nth-of-type(2)'), // to take one without class js-active-page

    checkboxContainer: document.querySelector('.js-checkbox-facet') ? document.querySelector('.js-checkbox-facet input[type=checkbox]').parentNode : null,
    checkboxFacetContainer: document.querySelector('.js-checkbox-facet')
  },

  createDataObj: function(form, otherInputs, justSearch) {
    // always get inputs from form, as they can be different from last time
    let dataObj = Object.assign({}, this.ajaxObj)

    // form should have only one textInput (the one used for ajax query)
    dataObj[this.el.queryTextInput.name] = this.el.queryTextInput.value

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
      overlayer.classList.add('js-display')

      let loaders = Array.from(document.getElementsByClassName('js-loader')) // extract this in this.el
      loaders.forEach(x => {
        if (x.parentElement.clientHeight >= 200) x.classList.add('js-display')
      })

    }

    function hideLoader() {
      let loaders = Array.from(document.getElementsByClassName('js-display'))
      loaders.forEach(x => x.classList.remove('js-display'))
    }

    const minLen = 3;

    // listen to entire form
    this.el.form.addEventListener('change', function(e) {

      // keyup event handler will deal with inputs type text
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
      // keyup can be also 'Escape' when select is opened
      if (e.target.type != 'text') return

      if (e.target.value.length < minLen) return

      this.delay(function() {
        let ignoredKeys = [16, 17, 18, 20, // shift, ctrl, alt, caps
                      37, 38, 39, 40] // keyboard arrows

        if (ignoredKeys.includes(e.which)) return;

        displayLoader()

        let ajaxObj = this.createDataObj(this.el.form, this.el.inputsOutOfForm, true)
        this.newSearch(ajaxObj)
        setTimeout(hideLoader, 500)

      }.bind(this), 1000)

    }.bind(this))

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
  },

  delay: function(){
    var timer = 0;
    return function(callback, ms) {
      clearTimeout(timer);
      timer = setTimeout(callback, ms)
    }
  }(),


  prepareFacets: function(xhrResponse) {
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

  refreshResults: function(results) {
    let ulResults = document.querySelector('.js-search-hits')
    let rBox = ulResults.cloneNode(false)

    var element= document.getElementById("wrapper-results");
	  element.innerHTML = '';
    results.forEach((x,index) => {
      let liBox = this.el.aLiFromUlResults.cloneNode(false)

      let xScript = x.replace('<script type="text/javascript">','')
      xScript = xScript.replace('</script>','')
      let test=eval(xScript);
      if(!results[index+1]){
        liBox.innerHTML = test;
        rBox.appendChild(liBox)
      }
    })

    this.el.ulResultsParent.replaceChild(rBox, ulResults)
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

      // reset ajaxObj.startIndex to start from 0 at createObject() called from form
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
    //let ulResults = document.querySelector('#wrapper-results')
    if (ulResults) ulResults.innerHTML = "<li>We are sorry, no results found for this search </li>"

    Array.from(document.querySelectorAll('.js-checkbox-facet')).forEach(x => { if(x) x.remove() } )
    this.el.queryTextInput.value = ''
  },

  newSearch: function(queryObj) {
    let self = this;

    if (!this.firstAjaxSearch) {
      this.firstAjaxSearch = true;
      document.querySelector('.searchResultsHeader').classList.add('js-invisible')
    }

    $.ajax({
      url: `${self.urlBase}?json=1&type=http%3A%2F%2Fvivoweb.org%2Fontology%2Fcore%23presentador`,
      data: queryObj,

      complete: function(xhr, status) {
        let r = jQuery.parseJSON(xhr.responseText);

        if (r.sort) { // make sure template sort value is the same with response sort
          let sort = this.el.inputsOutOfForm.sort
          if (sort.value != r.sort) sort.value = r.sort
        } else sort.value = sort.children[0].value //(r.sort is null))

        if (!r.facets || r.facets.length == 0) {
          this.foundNoResults() // we assume we can't have facets null, but individuals/pagingLinks available in response
          return
        }

        let facets = self.prepareFacets(r)

        // remove any html facet that is not in this response facets
        this.removeNotNeededHtmlFacets(facets.map(x => x.sectionId))

        // refresh or create facets
        facets.forEach(facet => {
          if (document.querySelector(`#${facet.sectionId}`)) this.refreshFacet(facet)
          else this.createFacet(facet)
        })

        // replace page search results with new ones
        if (r.individuals && r.individuals.length) this.refreshResults(r.individuals)

        // clean pagesBox if pagingLinks is empty
        if (!r.pagingLinks || !r.pagingLinks.length) {
          let searchPagesBox = document.querySelector('.js-search-pages')
          if (searchPagesBox) searchPagesBox.innerHTML = "";
          return
        }

        this.createPagination(r.pagingLinks)
        this.listenPagesBox()


      }.bind(this)
    })
  }


}




$(document).ready(function(){
  $.ajaxSettings.traditional = true;
  dFilter.onLoad();
})
