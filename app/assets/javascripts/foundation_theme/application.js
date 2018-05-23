//= require ./vendor/vendor

// Foundation.global.namespace = '';
$(document).ready(function() {
  $.datepicker.setDefaults( $.datepicker.regional[ "fr" ] );
  console.log($('.datepicker'));
  $('.datepicker').datepicker({ dateFormat: 'dd/mm/yy', changeMonth: true, changeYear: true });
  if($('.select2').length > 0)
    $('.select2').select2({allowClear: true});
  // $(document).foundation();

});
