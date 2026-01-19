import { application } from "./application"
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

// Load all controllers from the controllers directory
const context = require.context(".", true, /_controller\.js$/)
application.load(definitionsFromContext(context))
