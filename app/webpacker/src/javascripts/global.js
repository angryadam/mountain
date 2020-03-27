$(document).on('turbolinks:load', function() {
  $('.navbar-burger').click(function(e) {
    $('.navbar-menu').slideToggle(200);
  });
});
