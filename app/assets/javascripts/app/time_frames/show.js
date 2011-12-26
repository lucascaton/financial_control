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
  bg_over:                 '#BBB',
  saving_text:             'Salvando...',
  select_text:             'Selecione uma opção',
  textarea_rows:           3,
  success:                 update_entries,
  error:                   show_error_message,
  show_buttons:            true,
  save_button:             ' <button class="inplace_save">Salvar</button>',
  cancel_button:           '',
  save_if_nothing_changed: true
};

function setup_edit_in_place_fields(){
  var entry_kind = $('#entry_details .field .value#entry_kind');
  var entry_description = $('#entry_details .field .value#entry_description');
  var entry_value = $('#entry_details .field .value#entry_value');
  var entry_id = $('#entry_details #entry_id').html();

  entry_kind.editInPlace($.extend(default_edit_in_place_options,{
    field_type:      'select',
    select_options:  [['Débito (-)', 'debit'], ['Crédito (+)', 'credit']],
    url:             '/entries/' + entry_id + '/quick_update',
    params:          '_method=put&attribute=kind'
  }));

  entry_description.editInPlace($.extend(default_edit_in_place_options,{
    field_type:      'textarea',
    url:             '/entries/' + entry_id + '/quick_update',
    params:          '_method=put&attribute=description'
  }));

  entry_value.editInPlace($.extend(default_edit_in_place_options,{
    field_type:      'text',
    url:             '/entries/' + entry_id + '/quick_update',
    params:          '_method=put&attribute=value',
    preinit:          function(currentDomNode){
      currentDomNode.html(currentDomNode.html().replace(/R\$ /, '').replace(/,/, '.'));
    }
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
