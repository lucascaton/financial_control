$(function(){
  show_details();
});

function show_details(){
  $('table.table#entries tr').click(function(){
    alert($(this).attr('id'));
  });
}
