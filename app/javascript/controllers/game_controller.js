import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const gameContainer = this.element
    const csrfToken = this.getMetaValue("csrf-token")
    this.stopUpdatingPage = false

    setInterval(() => {
      this.loadView(csrfToken, gameContainer)
    }, 5000);
  }

  loadView(csrfToken, gameContainer) {
    if ( this.stopUpdatingPage === true ) { // the purpose of this is so that error messages persist rather than being overwritten by the next poll
      return
    }
    this.stopUpdatingPage = true;
    fetch(`/games/${gameContainer.dataset.gameId}/poll`)
      .then(response => {
        if (!response.ok) {
          console.log(response)
          return { html: `<p>There was a bally error :-( Try refreshing?</p><p>${response.statusText}</p>` }
        } else {
          this.stopUpdatingPage = false;
          return response.json()
        }
      })
      .then(data => {
        if (data.needs_to_collect_current_players_entries === true) {
          console.log(true)
          console.log('sending list')

          let entries = ['asdf', 'asdf', 'sdfg', 'dfgh']

          fetch(`/games/${gameContainer.dataset.gameId}/add_list.json?entries=${JSON.stringify(entries)}`,
            {
              method: 'PUT',
              credentials: "same-origin",
              headers: {
                "X-CSRF-Token": csrfToken
              },
            })
            .then(response => {
              if (!response.ok) {
                console.log(response)
                return { html: `<p>There was a bally error :-( Try refreshing?</p><p>${response.statusText}</p>` }
              } else {
                this.stopUpdatingPage = false;
                return response.json()
              }
            })
            .then(data => {
              gameContainer.innerHTML = data.html;
            })
        } else {
          console.log(false)
        }

        let listElementOriginal = document.getElementById('list')
        let values
        let originallyActive
        if (listElementOriginal) {
          values = Array.from(listElementOriginal.children).map((entry, index) => {
            if (entry === document.activeElement) {
              originallyActive = index
            }
            return entry.value
          })
        };

        gameContainer.innerHTML = data.html;

        let listElementNew = document.getElementById('list')
        if (listElementOriginal) {
          values.map((val, index) => {
            listElementNew.children[index].value = val
            if (index === originallyActive) {
              listElementNew.children[index].focus()
            }
          })
        };
      })
    }

  addRound(event) {
    this.doAction('add_round', event)
  }

  changeRound(event) {
    this.doAction('change_round', event)
  }

  startRound(event) {
    console.log('trying to start')

    this.doAction('start_round', event)
  }

  doAction(action, event) {
    this.stopUpdatingPage = true

    console.log(action)

    event.target.disabled = true;
    const gameContainer = this.element

    console.log(action)

    fetch(`/games/${gameContainer.dataset.gameId}/${action}.json`,
      {
        method: 'PUT',
        credentials: "same-origin",
        headers: {
          "X-CSRF-Token": this.getMetaValue("csrf-token")
        },
      })
      .then(response => {
        if (!response.ok) {
          console.log(response)
          return { html: `<p>There was a bally error :-( Try refreshing?</p><p>${response.statusText}</p>` }
        } else {
          this.stopUpdatingPage = false;
          return response.json()
        }
      })
      .then(data => {
        gameContainer.innerHTML = data.html;
      })
  }

  getMetaValue(name) {
    const element = document.head.querySelector(`meta[name="${name}"]`)
    return element.getAttribute("content")
  }
}
