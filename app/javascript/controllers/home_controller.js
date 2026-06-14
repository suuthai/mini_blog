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

  postsTurboFrameLoaded(event) {
    const lastPostElement = [ ...document.querySelectorAll(".post") ].slice(-1)[0];

    if (!lastPostElement) {
      return;
    }

    const {
      loading: loadingImages,
      stop: stopScrollingToLastPost
    } = [ ...document.querySelectorAll(".thumbnail-image") ]
      .reduce((previous, imageElement) => {
        if (imageElement.complete) {
          return previous;
        }

        let stopThis = () => {};

        return {
          loading: new Promise((resolve) => {
            const listener = () => (scrollIntoView(lastPostElement), previous.loading.then(resolve));
            imageElement.addEventListener("load", listener, { once: true });
            stopThis = () => imageElement.removeEventListener("load", listener);
          }),

          stop: () => (previous.stop(), stopThis())
        };
      }, { loading: Promise.resolve(), stop: () => {} });

    let stopWatchingScrollBack = () => {};

    const watchScrollBack = (lastScrollY) => {
      const listener = () =>
        window.requestAnimationFrame(() =>
          window.scrollY >= lastScrollY ? watchScrollBack(window.scrollY) : stopScrollingToLastPost());

      window.addEventListener("scroll", listener, { once: true });
      stopWatchingScrollBack = () => window.removeEventListener("scroll", listener);
    };

    watchScrollBack(0);
    loadingImages.then(() => stopWatchingScrollBack());
  }

  async submitPost(event) {
    await this.#submitPostOrComment(event,
      () => document.querySelectorAll(".post-main"));
    this.unchooseImageFile();
  }

  submitComment(event) {
    this.#submitPostOrComment(event,
      (form) => form.closest(".comments-turbo-frame").querySelectorAll(".comment"));
  }

  async #submitPostOrComment(event, postOrCommentElementsfromForm) {
    const form = event.target,
      lastCreatedAtElement = [ ... postOrCommentElementsfromForm(form) ].slice(-1)
        .map((element) => element.querySelector(".post-comment-created-at"))[0];

    form.querySelector(".created-at-input").value =
      lastCreatedAtElement?.dataset?.createdAt || document.body.dataset.now;
    await new Promise((resolve) => form.addEventListener("turbo:submit-end", resolve, { once: true}));
    form.querySelector(".content-input").value = "";
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
  
  #updateImageFileChooser(fileInput) {
    const files = fileInput.files;
    document.getElementById("image_file_chooser").classList.toggle("file-chosen", files.length > 0);
    document.getElementById("chosen_image_file_name").textContent = files[0]?.name;
  }

  changeImageFile(event) {
    this.#updateImageFileChooser(event.target.closest(".image-file-input"));
  }

  unchooseImageFile() {
    const fileInput = document.querySelector(".image-file-input");
    fileInput.value = "";
    this.#updateImageFileChooser(fileInput);
  }

  clickThumbnail(event) {
    const dataset = event.target.closest(".thumbnail-anchor").dataset;
    document.getElementById("original-image").src = dataset.imagePath;
    document.getElementById("download-image-anchor").href = dataset.imageBlobPath;
  }
}
