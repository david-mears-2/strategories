import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const gameContainer = this.element
    const endpoint = `/games/${gameContainer.dataset.gameId}/poll`
    setInterval(function () {
      // Seems that `this` stops referring to the stimulus controller inside here
      fetch(endpoint)
        .then(response => {
          if (!response.ok) {
            console.log(response)
            return { html: `<p>There was a bally error :-( Try refreshing?</p><p>${response.statusText}</p>` }
          } else {
            return response.json()
          }
        })
        .then(data => {
          gameContainer.innerHTML = data.html;
        })
      }, 5000);
  }

  addRound(event) {
    this.doAction('add_round', event)
  }

  startRound(event) {
    this.doAction('start_round', event)
  }

  doAction(action, event) {
    event.target.disabled = true;
    const gameContainer = this.element

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
