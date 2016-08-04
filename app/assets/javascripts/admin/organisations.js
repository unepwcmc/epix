$(document).on('turbolinks:load',function(){
  if ($.fn.dataTable.isDataTable('#organisations_table')) {
    table = $('#organisations_table').dataTable();
  }
  else {
    $("#organisations_table").dataTable({
      "aoColumnDefs" : [{
        "bSortable": false,
        "aTargets": ["no-sort"]
      }]
    });
  }
});
