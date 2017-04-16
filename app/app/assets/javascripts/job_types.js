var onReady = function() {
  // Bindings
  $(".row-category").click(function() {
    getCategory($(this).data("path"));
  });
};
$(document).ready(onReady);
$(document).on('page:load', onReady);

// Ajax
var getCategory = function(path) {
  $.getJSON('/functions.php', { get_param: 'value' }, function(data) {
    $.each(data, function(index, element) {
      $('body').append($('<div>', {
        text: element.name
      }));
    });
  });
};
