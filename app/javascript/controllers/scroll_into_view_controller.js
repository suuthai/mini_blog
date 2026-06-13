import { Controller } from "@hotwired/stimulus"
import { scrollIntoView } from "./scroll_into_view";

// Connects to data-controller="scroll-into-view"
export default class extends Controller {
  connect() {
    scrollIntoView(this.element);
  }
}
