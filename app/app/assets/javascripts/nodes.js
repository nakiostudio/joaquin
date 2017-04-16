var onReady = function() {
  $(".row-node").click(function() {
    window.location = "/nodes/" + $(this).data("node-id");
  });
};
$(document).ready(onReady);
$(document).on('page:load', onReady);
