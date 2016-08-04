$(document).on('turbolinks:load',function(){
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
});