$(document).on('turbolinks:load',function(){
  var tableElementIds = ['#users_table', '#organisations_table'];
  for (var i = 0; i < tableElementIds.length; i++) {
    var tableElementId = tableElementIds[i];
    if ($.isEmptyObject($.find(tableElementId))){
      continue;
    }
    var table;
    if ($.fn.DataTable.isDataTable(tableElementId)) {
      table = $(tableElementId).DataTable();
    } else {
      table = $(tableElementId).DataTable({
        "sDom": "tip",
        "pageLength": 50,
        "aoColumnDefs" : [{
          "bSortable": false,
          "aTargets": ["no-sort"]
        }]
      });
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

    // to fix back button
    document.addEventListener("turbolinks:before-cache", function() {
      table.destroy();
    });

  }
});
