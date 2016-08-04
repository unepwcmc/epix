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
});
