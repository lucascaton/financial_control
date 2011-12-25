$(function(){
  show_details();
});

function show_details(){
  $('table.table#entries tr').click(function(){
    show_loading(true);
    entry_id = $(this).attr('id').replace(/entry_/, '');
    $.get('/entries/' + entry_id, {}, function(data){
      $('#entry_details').html(data);
      show_loading(false);
    });
  });
}
