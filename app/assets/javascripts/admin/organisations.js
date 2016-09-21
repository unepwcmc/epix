$(document).on('turbolinks:load',function(){
  var $countries_input = $('#countries_with_access')
  $countries_input.select2({
    placeholder: "Select tag",
    minimumInputLength: 1
  });
  $($countries_input.data('tags')).each(function (index, country) {
    var option = new Option(country.text, country.id, true, true);
    $countries_input.append(option)
  });
});
