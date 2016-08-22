$(document).on('turbolinks:load',function(){
  if ($.fn.dataTable.isDataTable('#users_table')) {
    table = $('#users_table').dataTable();
  }
  else {
    $("#users_table").dataTable({
      "aoColumnDefs" : [{
        "bSortable": false,
        "aTargets": ["no-sort"]
      }]
    });
  }

  $("#user_organisation_id").on('change', function() {
    var org_id = $(this).val();
    $('.selected-org').removeClass('selected-org');
    $('.org-'+org_id).addClass('selected-org');
  });

});
