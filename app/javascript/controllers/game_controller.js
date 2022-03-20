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
            return { html: `<p>There was a bally error :-(</p><p>${response.statusText}</p>` }
          } else {
            return response.json()
          }
        })
        .then(data => {
          gameContainer.innerHTML = data.html;
        })
      }, 1000);
  }
}
