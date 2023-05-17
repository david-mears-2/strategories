import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const gameContainer = this.element
    const inputs = Array.from(document.getElementById('inputs').getElementsByTagName('input'))
    const csrfToken = this.getMetaValue("csrf-token")
    this.stopUpdatingPage = false

    setInterval(() => {
      this.loadView(csrfToken, gameContainer, inputs)
    }, 500);
  }

  loadView(csrfToken, gameContainer, inputs) {
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

          let entries = inputs.map((el) => el.value).filter((el) => (el != ''))

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
              this.updateHTML(gameContainer, inputs, data.html, data.list_length)
            })
        } else {
          console.log(false)
        }

        this.updateHTML(gameContainer, inputs, data.html, data.list_length)
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
        this.updateHTML(gameContainer, inputs, data.html, data.list_length)
      })
  }

  getMetaValue(name) {
    const element = document.head.querySelector(`meta[name="${name}"]`)
    return element.getAttribute("content")
  }

  updateHTML(gameContainer, inputs, html, listLength) {
    gameContainer.innerHTML = html;

    inputs.slice(0, listLength).forEach((input) => {
      input.type = 'text'
    })
    inputs.slice(listLength).forEach((input) => {
      input.type = 'hidden'
    })
  }
}
