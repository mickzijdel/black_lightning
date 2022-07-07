/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

require("@popperjs/core")

// BOOTSTRAP: Does this need?
//import 'jquery'
// const jQuery = $

import "bootstrap"

// Import the specific modules you may need (Modal, Alert, etc)
// import { Tooltip, Popover, Modal } from "bootstrap"

import 'core-js/stable'
import 'regenerator-runtime/runtime'

//import "@fortawesome/fontawesome-free/js/all"

import '../src/jquery.switch'
import 'jquery-slimscroll'
import '../src/alerts'


import '../src/konami_code'

import "controllers"

// BOOTSTRAP: Does it need the below?
//require.context('./../../../node_modules/jquery-ui/ui')
require("@rails/ujs").start()
require("@rails/activestorage").start()

// https://github.com/ifad/data-confirm-modal
//require('data-confirm-modal')

import "sweetalert"

