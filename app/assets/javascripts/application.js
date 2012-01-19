// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require_tree ./vendor

$(function(){
  configureExternalLinks();
  configureJqueryUIDefaults();
  configureFacebox();
  configureInputs();
});

function configureExternalLinks(){
  $('.external').click(function(){
    window.open($(this).attr('href'));
    return false;
  });
}

function showLoading(active){
  if(active){
    $('#loading').fadeIn(200);
  }else{
    $('#loading').fadeOut(100);
  }
}

function configureJqueryUIDefaults(){
  $.datepicker.setDefaults({
    dateFormat:   'dd/mm/yy',
    prevText:     'Anterior',
    nextText:     'Próximo',
    stepMonths:   0,
    dayNamesMin:  ['Se', 'Te', 'Qu', 'Qu', 'Se', 'Sá', 'Do'],
    monthNames:   ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Augosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro']
  });

  $(document).bind('reveal.facebox', function(){
    $('#facebox .datepicker').each(function(intIndex){
      $(this).attr('id', $(this).attr('id') + '_facebox');
      $(this).datepicker();
      configureInputs();
    });
  });
}

function closeFacebox(){
  $(document).trigger('close.facebox');
}

function configureFacebox(){
  $('a[rel*=facebox]').facebox({
    loadingImage:  '../assets/vendor/facebox/loading.gif',
    closeImage:    '../assets/vendor/facebox/closelabel.png',
    opacity:       0.3
  });
}

function configureInputs(){
  configureMasks();
}

function configureMasks(){
  $('input.price').setMask({ mask: '99.99999999', type : 'reverse', defaultValue: '000' });
  $('input.cep').setMask({ mask: '99999-999' });
  $('input.phone').setMask({ mask: '(99) 9999-9999' });
  $('input.cpf').setMask({ mask: '99999999999' });
  $('input.cnpj').setMask({ mask: '99999999999999' });
}
