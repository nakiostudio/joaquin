var on_ready = function() {
  $(".row-node").click(function() {
    window.location = "/nodes/" + $(this).data("node-id");
  });
};
$(document).ready(on_ready);
$(document).on('page:load', on_ready);
