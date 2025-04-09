import { Application } from "@hotwired/stimulus"
const application = Application.start()
// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

// Trix Genius block
import TrixController from "controllers/trix-controller"
application.register("trix", TrixController)

export { application }
