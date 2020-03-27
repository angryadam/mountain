// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/webpacker and only use these pack files to reference
// that code so it'll be compiled.
import ApexCharts from 'apexcharts'
window.ApexCharts = ApexCharts

import "@fortawesome/fontawesome-free/js/all"
import "cocoon";

require("@rails/ujs").start()
require("turbolinks").start()

// App defined scripts
require("src/javascripts/providers")
require("src/javascripts/global")
// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
