$(document).on('turbolinks:load',function(){
  if ($.fn.dataTable.isDataTable('#users_table')) {
    table = $('#users_table').dataTable();
  }
  else {
    $("#users_table").dataTable({
      "bFilter": false,
      "aoColumnDefs" : [{
        "bSortable": false,
        "aTargets": ["no-sort"]
      }]
    }).columnFilter({
      sPlaceHolder: "head:before",
      aoColumns: [
        null,
        {
          type: "text"
        },
        {
          type: "text"
        },
        {
          type: "text"
        },
        {
          type: "text"
        },
        null,
        null,
        null
      ]
    });
  }
});
