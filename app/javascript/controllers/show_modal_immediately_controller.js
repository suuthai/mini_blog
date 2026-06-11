import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

// Connects to data-controller="show-modal-immediately"
export default class extends Controller {
  connect() {
    new Modal(this.element).show();
  }
}
