$(document).on('turbolinks:load',function(){
  var tables = [
    $('#users_table').DataTable(),
    $('#organisations_table').DataTable()
  ];

  for(var i = 0; i < tables.length; i++) {
    if(tables[i].data().length > 0) {
      tables[i].columns('.searchable').every(function() {
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
