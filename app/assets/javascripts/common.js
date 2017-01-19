$(function() {
  $(".alert" ).fadeOut(3000);
  $('.datepicker').datetimepicker({ format: 'DD/MM/YYYY' });
});

$(document).on('change', '.brand-dropdown,.category-dropdown', function() {
  $(this).parent().submit();
});

$(document).on('change', '.change-parent, #item_parent_id', function() {
    $.ajax({
      type: "GET",
      url: '/items/'+ $("#item_parent_id").val() +'/item_render/',
      success: function(data) {
        console.log(data)
      }
    });
  $(this).parent().submit();
});

$(document).on('change', "#checkout_item_id", function() {
  var selected = $(this).find('option:selected');
  $('#checkout_checkout').data('DateTimePicker').minDate(moment(selected.data('purchase-on'), 'YYYY MM DD'));
});

$(document).on('change', "#issue_item_id", function() {
  var selected = $(this).find('option:selected');
  $('#issue_closed_at').data('DateTimePicker').minDate(moment(selected.data('purchase-on'), 'YYYY MM DD'));
});

$(document).on('change', "#issue_system_id", function() {
  var selected = $(this).find('option:selected');
  $('#issue_closed_at').data('DateTimePicker').minDate(moment(selected.data('assembled_on'), 'YYYY MM DD'));
});
