import jQuery from 'jquery';
global.$ = global.jQuery = jQuery;


// Use CommonJS require to bypass ES module timing issues
// (ES modules with type="module" have deferred evaluation that breaks window.Turbo assignment)
const Turbo = require("@hotwired/turbo");

Turbo.start();

window.Turbo = Turbo;

// Now sweetalert can access window.Turbo synchronously
require("./sweetalert");

import 'jquery-slimscroll'

import './src/shared/konami_code'
import './src/shared/md_editor'
import './src/shared/select2'
import './src/shared/input_validator'

// Load all the stimulus controllers
import "./controllers"

require("@rails/activestorage").start()

// Requires jQuery. There are vanilla js packages, but not as frequently maintained or downloaded.
require("@nathanvda/cocoon")
