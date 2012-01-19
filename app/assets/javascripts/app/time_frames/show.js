$(function(){
  showDetails();
  configureFormNewEntry();
});

function showDetails(){
  $('table.table#entries tbody tr').click(function(){
    showLoading(true);
    entryId = $(this).attr('id').replace(/entry_/, '');
    $.get('/entries/' + entryId, {}, function(data){
      $('#entry_details').html(data);
      setupEditInPlaceFields();
      showLoading(false);
    });
  });
}

defaultEditInPlaceOptions = {
  bg_over:                 '#BBB',
  saving_text:             'Salvando...',
  select_text:             'Selecione uma opção',
  default_text:            '(Clique aqui para adicionar um texto)',
  textarea_rows:           3,
  success:                 updateEntries,
  error:                   showErrorMessage,
  show_buttons:            true,
  save_button:             ' <button class="inplace_save">Salvar</button>',
  cancel_button:           '',
  save_if_nothing_changed: true
};

function setupEditInPlaceFields(){
  var entryId          = $('#entry_details #entry_id').html();
  var entryKind        = $('#entry_details .field .value#entry_kind');
  var entryDescription = $('#entry_details .field .value#entry_description');
  var entryValue       = $('#entry_details .field .value#entry_value');
  var entryBillOn      = $('#entry_details .field .value#entry_bill_on');
  var entryAutoDebit   = $('#entry_details .field .value#entry_auto_debit');
  var entryStatus      = $('#entry_details .field .value#entry_status');

  entryKind.editInPlace($.extend(defaultEditInPlaceOptions,{
    field_type:      'select',
    select_options:  [['Débito (-)', 'debit'], ['Crédito (+)', 'credit']],
    url:             '/entries/' + entryId + '/quick_update.js',
    params:          '_method=put&attribute=kind'
  }));

  entryDescription.editInPlace($.extend(defaultEditInPlaceOptions,{
    field_type:      'textarea',
    url:             '/entries/' + entryId + '/quick_update.js',
    params:          '_method=put&attribute=description'
  }));

  entryValue.editInPlace($.extend(defaultEditInPlaceOptions,{
    field_type:      'text',
    url:             '/entries/' + entryId + '/quick_update.js',
    params:          '_method=put&attribute=value',
    delegate:{
      didOpenEditInPlace: function(aDOMNode, aSettingsDict){
        if(aDOMNode.attr('id') == 'entry_value'){
          $(aDOMNode).find('input').addClass('price').html().replace(/R\$ /, '').replace(/,/, '.');
          configureInputs();
        }
        return false;
      }
    }
  }));

  entryBillOn.editInPlace($.extend(defaultEditInPlaceOptions,{
    field_type:      'text',
    url:             '/entries/' + entryId + '/quick_update.js',
    params:          '_method=put&attribute=bill_on',
    delegate:{
      didOpenEditInPlace: function(aDOMNode, aSettingsDict){
        if(aDOMNode.attr('id') == 'entry_bill_on')
          $(aDOMNode).find('input').datepicker().focus();
        return false;
      }
    }
  }));

  entryAutoDebit.editInPlace($.extend(defaultEditInPlaceOptions,{
    field_type:      'select',
    select_options:  [['Sim', 't'], ['Não', 'f']],
    url:             '/entries/' + entryId + '/quick_update.js',
    params:          '_method=put&attribute=auto_debit'
  }));

  entryStatus.editInPlace($.extend(defaultEditInPlaceOptions,{
    field_type:      'select',
    select_options:  [['Pago!', 't'], ['Pendente...', 'f']],
    url:             '/entries/' + entryId + '/quick_update.js',
    params:          '_method=put&attribute=done'
  }));
}

function updateEntries(){
  showLoading(true);
  timeFrameId = $('#time_frame_id').val();
  $.get('/time_frames/' + timeFrameId + '/entries', {}, function(data){
    $('#entries').html(data);
    showDetails();
    showLoading(false);
  });
}

function showErrorMessage(){
  alert('Não foi possível atualizar este item.');
}

function configureFormNewEntry(){
  $(document).bind('reveal.facebox', function(){
    $('#facebox form.form').submit(function(){
      showLoading(true);

      var timeFrameId   = $(this).find('#entry_time_frame_id').val();
      var kind          = $(this).find('#entry_kind').val();
      var title         = $(this).find('#entry_title').val();
      var description   = $(this).find('#entry_description').val();
      var value         = $(this).find('#entry_value').val();
      var billOn        = $(this).find('#entry_bill_on_facebox').val();

      $.post('/entries/quick_create', { time_frame_id: timeFrameId, kind: kind, title: title,
        description: description, value: value, bill_on: billOn }, function(data){
        if(data.successful){
          $('#container').find('.flash').html('<div class="message notice"><p>Registro criado com sucesso.</p></div>');
          closeFacebox();
          updateEntries();
        }else{
          $('#facebox form .flash.invisible').show().html('<div class="message error"><p>' + data.errors + '</p></div>');
        }
        showLoading(false);
      });

      return false;
    });
  });
}
