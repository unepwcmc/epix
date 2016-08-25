$(document).on('turbolinks:load',function(){
  $("#user_organisation_id").on('change', function() {
    var org_id = $(this).val();
    $('.selected-org').removeClass('selected-org');
    $('.org-'+org_id).addClass('selected-org');
  });
});
