import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="application"
export default class extends Controller {
  connect() {
  }

  clickUserButton(event) {
    const userButton = event.target.closest(".user-button"),
      userTurboFrame = document.getElementById("user");
    userTurboFrame.src = userButton.dataset.userSrc;
  }

  toggleLikers(event) {
    event.target.closest(".like-controls").classList.toggle("show-likers");
  }
}
