import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="application"
export default class extends Controller {
  connect() {
  }

  submitPost(event) {
    this.#submitPostOrComment(event,
      () => document.querySelectorAll(".post-main"));
  }

  submitComment(event) {
    this.#submitPostOrComment(event,
      (form) => form.closest(".comments-turbo-frame").querySelectorAll(".comment"));
  }

  #submitPostOrComment(event, postOrCommentElementsfromForm) {
    const form = event.target,
      lastCreatedAtElement = [ ... postOrCommentElementsfromForm(form) ].slice(-1)
        .map((element) => element.querySelector(".post-comment-created-at"))[0];

    form.querySelector(".created-at-input").value =
      lastCreatedAtElement?.dataset?.createdAt || document.body.dataset.now;

    form.addEventListener("turbo:submit-end", () => {
      form.querySelector(".content-input").value = "";
    }, { once: true });
  }

  clickUserButton(event) {
    const userButton = event.target.closest(".user-button"),
      userTurboFrame = document.getElementById("user");
    userTurboFrame.src = userButton.dataset.userSrc;
  }

  toggleLikers(event) {
    event.target.closest(".like-controls").classList.toggle("show-likers");
  }

  toggleComments(event) {
    const post = event.target.closest(".post");

    if (post.classList.toggle("show-comments")) {
      post.querySelector(".comments-turbo-frame").addEventListener("turbo:frame-load", () => {
        post.querySelector(".content-input").focus();
        post.querySelector(".comment-form").scrollIntoView({ behavior: "smooth", block: "nearest" });
      }, { once: true });
    } else {
      post.scrollIntoView({ behavior: "instant", block: "nearest" });
    }
  }
}
