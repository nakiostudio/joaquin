var onReady = function() {
  // Dropdowns ugly fix
  $(".dropdown-toggle").dropdown();
};
$(document).ready(onReady);
$(document).on('page:load', onReady);
