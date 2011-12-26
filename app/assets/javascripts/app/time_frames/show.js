$(function(){
  show_details();
});

function show_details(){
  $('table.table#entries tr').click(function(){
    show_loading(true);
    entry_id = $(this).attr('id').replace(/entry_/, '');
    $.get('/entries/' + entry_id, {}, function(data){
      $('#entry_details').html(data);
      setup_edit_in_place_fields();
      show_loading(false);
    });
  });
}

default_edit_in_place_options = {
  bg_over:         '#BBB',
  saving_text:     'Salvando...',
  select_text:     'Selecione uma opção',
  success:         update_entries,
  error:           show_error_message,
  show_buttons:    true,
  save_button:     ' <button class="inplace_save">Salvar</button>',
  cancel_button:   ''
};

function setup_edit_in_place_fields(){
  var entry_kind = $('#entry_details .field .value#entry_kind');
  var entry_id = $('#entry_details #entry_id').html();

  entry_kind.editInPlace($.extend(default_edit_in_place_options,{
    field_type:      'select',
    select_options:  [['Débito (-)', 'debit'], ['Crédito (+)', 'credit']],
    url:             '/entries/' + entry_id + '/quick_update',
    params:          '_method=put&attribute=kind'
  }));
}

function update_entries(){
  show_loading(true);
  time_frame_id = $('#time_frame_id').val();
  $.get('/time_frames/' + time_frame_id + '/entries', {}, function(data){
    $('#entries').html(data);
    show_details();
    show_loading(false);
  });
}

function show_error_message(){
  alert('Não foi possível atualizar este item.');
}
