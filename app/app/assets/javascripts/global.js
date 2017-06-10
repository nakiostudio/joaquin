var onReady = function() {
  // Dropdowns ugly fix
  $(".dropdown-toggle").dropdown();
  // Node selection (TODO: move)
  $(".row-node").click(function() {
    window.location = "/nodes/" + $(this).data("node-id");
  });
};

$(document).ready(onReady);
$(document).on('page:load', onReady);
