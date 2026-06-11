import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="application"
export default class extends Controller {
  connect() {
  }

  clickPostUserButton(event) {
    const userButton = event.target.closest(".post-user-button"),
      userTurboFrame = document.getElementById("user");
    userTurboFrame.src = userButton.dataset.userSrc;
  }
}
