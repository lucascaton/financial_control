$(function(){
  show_details();
  configure_form_new_entry();
});

function show_details(){
  $('table.table#entries tbody tr').click(function(){
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
  default_text:            '(Clique aqui para adicionar um texto)',
  textarea_rows:           3,
  success:                 update_entries,
  error:                   show_error_message,
  show_buttons:            true,
  save_button:             ' <button class="inplace_save">Salvar</button>',
  cancel_button:           '',
  save_if_nothing_changed: true
};

function setup_edit_in_place_fields(){
  var entry_id          = $('#entry_details #entry_id').html();
  var entry_kind        = $('#entry_details .field .value#entry_kind');
  var entry_description = $('#entry_details .field .value#entry_description');
  var entry_value       = $('#entry_details .field .value#entry_value');
  var entry_bill_on     = $('#entry_details .field .value#entry_bill_on');
  var entry_auto_debit  = $('#entry_details .field .value#entry_auto_debit');
  var entry_status      = $('#entry_details .field .value#entry_status');

  entry_kind.editInPlace($.extend(default_edit_in_place_options,{
    field_type:      'select',
    select_options:  [['Débito (-)', 'debit'], ['Crédito (+)', 'credit']],
    url:             '/entries/' + entry_id + '/quick_update.js',
    params:          '_method=put&attribute=kind'
  }));

  entry_description.editInPlace($.extend(default_edit_in_place_options,{
    field_type:      'textarea',
    url:             '/entries/' + entry_id + '/quick_update.js',
    params:          '_method=put&attribute=description'
  }));

  entry_value.editInPlace($.extend(default_edit_in_place_options,{
    field_type:      'text',
    url:             '/entries/' + entry_id + '/quick_update.js',
    params:          '_method=put&attribute=value',
    preinit:          function(currentDomNode){
      currentDomNode.html(currentDomNode.html().replace(/R\$ /, '').replace(/,/, '.'));
    }
  }));

  entry_bill_on.editInPlace($.extend(default_edit_in_place_options,{
    field_type:      'text',
    url:             '/entries/' + entry_id + '/quick_update.js',
    params:          '_method=put&attribute=bill_on',
    delegate:{
      didOpenEditInPlace: function(aDOMNode, aSettingsDict){
        $(aDOMNode).find('input').datepicker().focus();
        return false;
      }
    }
  }));

  entry_auto_debit.editInPlace($.extend(default_edit_in_place_options,{
    field_type:      'select',
    select_options:  [['Sim', 't'], ['Não', 'f']],
    url:             '/entries/' + entry_id + '/quick_update.js',
    params:          '_method=put&attribute=auto_debit'
  }));

  entry_status.editInPlace($.extend(default_edit_in_place_options,{
    field_type:      'select',
    select_options:  [['Pago!', 't'], ['Pendente...', 'f']],
    url:             '/entries/' + entry_id + '/quick_update.js',
    params:          '_method=put&attribute=done'
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

function configure_form_new_entry(){
  $(document).bind('reveal.facebox', function(){
    $('#facebox form.form').submit(function(){
      var time_frame_id = $(this).find('#entry_time_frame_id').val();
      var kind          = $(this).find('#entry_kind').val();
      var title         = $(this).find('#entry_title').val();
      var description   = $(this).find('#entry_description').val();
      var value         = $(this).find('#entry_value').val();
      var bill_on       = $(this).find('#entry_bill_on_facebox').val();

      $.post('/entries/quick_create', { time_frame_id: time_frame_id, kind: kind, title: title,
        description: description, value: value, bill_on: bill_on }, function(data){
        if(data.successful){
          $('#container').find('.flash').html('<div class="message notice"><p>Registro criado com sucesso.</p></div>');
          close_facebox();
          update_entries();
        }else{
          $('#facebox form .flash.invisible').show().html('<div class="message error"><p>' + data.errors + '</p></div>');
        }
      });

      return false;
    });
  });
}
