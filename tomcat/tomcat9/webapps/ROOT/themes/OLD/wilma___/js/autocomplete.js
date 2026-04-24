let autocomplete = {
  autocompleteSrc: `${baseUrl}/autocompleteUr`,

  init: function() {
    this.getObjects()
    this.attachListeners()
  },

  getObjects: function() {
    this.textInputs = Array.from(document.querySelectorAll('.js-autocomplete-input'))
    this.hintContainers = document.querySelectorAll('.js-autocomplete-hints')
    this.submitBtns = document.querySelectorAll('.js-submit') // not used / remove?
  },


  attachListeners: function() {
    let allowMouseOverToSetHovered = true
    let timeUntilMouseOverSetsHovered = 500

    const navThroughHints = (e, hintContainer, textInput) => {

      let hintBox = hintContainer
      let currentHover = hintBox.querySelector('.hovered');

      if (!currentHover) {
        hintBox.firstElementChild.classList.add('hovered');
        textInput.value = hintBox.firstElementChild.textContent
        return
      }

      let switchHover = (current, switchTo) => {
        current.classList.remove('hovered')
        switchTo.classList.add('hovered')
        textInput.value = switchTo.textContent
      }

      let currentRect = currentHover.getBoundingClientRect();
      let hintBoxRect = hintBox.getBoundingClientRect();

      let resetAllowMouseOverToSetHovered = () => { allowMouseOverToSetHovered = true }
      let scrollUp = (hoveredEl, parent) => {
        parent.scrollTop -= parent.clientHeight - hoveredEl.clientHeight;
        hintBoxScrolledFromArrowKeys = true
        if (allowMouseOverToSetHovered) {
          allowMouseOverToSetHovered = false
          setTimeout(resetAllowMouseOverToSetHovered, timeUntilMouseOverSetsHovered - 200)
        }
      }
      let scrollDown = (hoveredEl, parent) => {
        parent.scrollTop += parent.clientHeight - hoveredEl.clientHeight;
        if (allowMouseOverToSetHovered) {
          allowMouseOverToSetHovered = false
          setTimeout(resetAllowMouseOverToSetHovered, timeUntilMouseOverSetsHovered - 200)
        }
      }

      if (e.key == "ArrowUp" && currentHover.previousElementSibling) {
        switchHover(currentHover, currentHover.previousElementSibling)
        if (currentRect.top - currentRect.height < hintBoxRect.top) scrollUp(currentHover, hintBox)
        return
      }

      // only e.key possibility left == "ArrowDown"
      if (currentHover.nextElementSibling) {
        switchHover(currentHover, currentHover.nextElementSibling)
        if (currentRect.bottom + currentRect.height > hintBoxRect.bottom) scrollDown(currentHover, hintBox)
      }

    }

    const enableInput = (input) => {
      input.disabled = false
      return input
    }

    const disableInput = (input) => {
      input.disabled = true
      return input
    }

    const hideOnClickOutside = (element, input) => {
      const outsideClickListener = e => {

        if (element.contains(e.target)) {
          e.preventDefault()
          input.value = e.target.innerHTML
        }

        destroyHintBox(element, input)
        removeClickListener()

      }

      const removeClickListener = () => {
        document.removeEventListener('click', outsideClickListener)
      }

      document.addEventListener('click', outsideClickListener)
    }

    const erectHintBox = (hintContainer, input) => {
      let hintBox = hintContainer;
      let timeoutIdForSettingHoveredClassAtMouseStop = null

      hintBox.classList.add('visible')
      // reset scrollTop to 0
      hintBox.scrollTop = 0

      hintBox.addEventListener('mouseover', e => {

        const isLinkTarget = (e.target.tagName == "A" && e.target.parentNode == hintBox)
        const counterVisualHoverClass = 'js-counter-visual-hover'

        if (!allowMouseOverToSetHovered && isLinkTarget) {
          e.target.classList.add(counterVisualHoverClass)
          return;
        }

        let counteredVisualHoverElement = hintBox.querySelector('.' + counterVisualHoverClass)
        if (counteredVisualHoverElement) counteredVisualHoverElement.classList.remove(counterVisualHoverClass)

        // remove hovered class if any element has it
        let hoveredEl = hintBox.querySelector('.hovered')
        if (hoveredEl) hoveredEl.classList.remove('hovered')

        // set again hovered class if mouse stops moving
        // not just updating input.value because if user continues with up/down arrow keys script needs to know current .hovered
        clearTimeout(timeoutIdForSettingHoveredClassAtMouseStop)
        const setHoveredAtMouseStop = () => {
          if (isLinkTarget) {
            e.target.classList.add('hovered')
          }
        }
        timeoutIdForSettingHoveredClassAtMouseStop = setTimeout(setHoveredAtMouseStop, timeUntilMouseOverSetsHovered)

      })

    }

    const destroyHintBox = (hintContainer, input) => {
      hintContainer.classList.remove('visible')

      if (input) enableInput(input).focus()
    }

    const getHints = (textInput, searchBy) => {
      disableInput(textInput)
      let isKeywordFilter = searchBy.value == 'keyword'
      let filterInUrl = isKeywordFilter ? `&field=${searchBy.value}` : ''
      let url = `${this.autocompleteSrc}?term=${textInput.value}${filterInUrl}&type=http%3A%2F%2Fxmlns.com%2Ffoaf%2F0.1%2FPerson`
      const request = new Request(url)

      return fetch(request)
        .then(response => response.json())
        .then(jsonR => jsonR.map(x => x.label))
        .catch(err => {
          enableInput(textInput);
          console.error(err)
        })
    }

    const minTextLen = 3

    this.textInputs.forEach((input, idx) => {
      let hintBox = this.hintContainers[idx]
      let shouldCloseHintBox = false
      let form = input.closest('.js-form')
      let submitBtn = form.querySelector('.js-submit')
      if (submitBtn.classList.contains('js-disabled')) submitBtn.disabled = true;

      input.addEventListener('keydown', e => { // for tab && enter needed keydown listener

        if (!["Enter", "Tab", "Escape"].includes(e.key)) return
        e.preventDefault();
        destroyHintBox(hintBox, input);

        submitBtn.focus()
        return;
      })

      input.addEventListener('keyup', function(e) { //maybe should listen to 'change' event if need to cover cases with ctrl+c/ctrl+v value in input
        if (e.key == "Backspace" && input.value.length < minTextLen) {
          destroyHintBox(hintBox, input)
          submitBtn.classList.add('js-disabled')
          submitBtn.disabled = true
        }
        if (input.value.length >= minTextLen) {
          submitBtn.classList.remove('js-disabled')
          submitBtn.disabled = false;
        }

        if (["ArrowLeft", "ArrowRight"].includes(e.key)) return

        let isVisibleHintBox = hintBox.classList.contains('visible')

        if (isVisibleHintBox) {

          // at up/down arrow give impression of navigation through hints, due to hover effect
          let isNavKey = ["ArrowDown", "ArrowUp"].includes(e.key)
          if (isNavKey) { navThroughHints(e, hintBox, input); return }
        }


        if (input.value.length < minTextLen) return

        let searchFilter = form.querySelector('input[name=querytype]:checked')


        let hints = []
        const hidrateHint = (hintText) => {
          hints.push(`<a href>${hintText}</a>`)
        }
        const hidrateHints = hintTextArr => hintTextArr.forEach(hidrateHint)

        getHints(input, searchFilter)
          .then(hidrateHints)
          .then(() => {
            enableInput(input).focus();

            // don't display container if no hints available
            let hasHints = hints.length > 0;

            if (!hasHints && isVisibleHintBox) { destroyHintBox(hintBox, input); return }
            if (!hasHints) return;

            // add hints into container
            hintBox.innerHTML = hints.join("")


            if (isVisibleHintBox) return;

            // if container is not already visible, make it
            erectHintBox(hintBox, input)
            // remove at click on document, but not on hintBox
            hideOnClickOutside(document.querySelector('.js-autocomplete-hints.visible'), input)
          })


      }.bind(this))

    })

  },


}

 document.addEventListener("DOMContentLoaded", function(){
  autocomplete.init()
})
