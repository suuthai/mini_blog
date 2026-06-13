import { Controller } from "@hotwired/stimulus"
import { scrollIntoView } from "./scroll_into_view";

const loadingTurboFrame = (turboFrame) => new Promise((resolve) =>
  turboFrame.addEventListener("turbo:frame-load", resolve, { once: true }));

// Connects to data-controller="home"
export default class extends Controller {
  async connect() {
    const urlParams = new URLSearchParams(window.location.search),
      postId = urlParams.get("post"),
      commentId = urlParams.get("comment");
      
    if (!postId || !commentId) {
      return;
    }

    const postsTurboFrame = document.getElementById("posts_turbo_frame");
    await loadingTurboFrame(postsTurboFrame);
    const postElement = document.getElementById("post_" + postId);

    if (postElement && !postElement.classList.contains("show-comments")) {
      postElement.classList.add("show-comments");
      const commentsTurboFrame = postElement.querySelector(".comments-turbo-frame");
      commentsTurboFrame.src = `/posts/${postId}/comments`;
      await loadingTurboFrame(commentsTurboFrame);    
    }

    scrollIntoView(document.getElementById("comment_" + commentId), { block: "end" });
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

    if (!post.classList.toggle("show-comments")) {
      scrollIntoView(post, { behavior: "instant" });
      return;
    }

    post.querySelector(".comments-turbo-frame").addEventListener("turbo:frame-load", () => {
      post.querySelector(".content-input").focus();
      scrollIntoView(post.querySelector(".comment-form"));
    }, { once: true });
  }
}
