$(document).on('turbolinks:load',function(){
  var tableElementIds = ['#users_table', '#organisations_table'];
  for (var i = 0; i < tableElementIds.length; i++) {
    var tableElementId = tableElementIds[i];
    if ($.isEmptyObject($.find(tableElementId))){
      continue;
    }
    var table;
    if ($(tableElementId).attr('data-table-initialised')) {
      table = $(tableElementId).DataTable();
    } else {
      table = $(tableElementId).DataTable({
        "aoColumnDefs" : [{
          "bSortable": false,
          "aTargets": ["no-sort"]
        }]
      });
      $(tableElementId).attr('data-table-initialised', 1);
    }

    if (table.data().length > 0) {
      table.columns('.searchable').every(function() {
        var column = this;
        $('input', this.footer()).on('keyup change', function () {
          if (column.search() !== this.value) {
            column.search( this.value ).draw();
          }
        });
      });
    }
  }
});
