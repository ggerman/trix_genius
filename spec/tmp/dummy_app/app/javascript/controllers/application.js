import { Application } from "@hotwired/stimulus"
import TrixController from "controllers/trix-controller"

const application = Application.start()

// Configure Stimulus development experience

application.debug = false
window.Stimulus   = application

application.register("trix", TrixController)

export { application }
