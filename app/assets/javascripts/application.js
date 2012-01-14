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
  configure_external_links();
  configure_jquery_ui_defaults();
});

function configure_external_links(){
  $('.external').click(function(){
    window.open($(this).attr('href'));
    return false;
  });
}

function show_loading(active){
  if(active){
    $('#loading').fadeIn(200);
  }else{
    $('#loading').fadeOut(100);
  }
}

function configure_jquery_ui_defaults(){
  $.datepicker.setDefaults({
    dateFormat: 'dd/mm/yy',
    prevText: 'Anterior',
    nextText: 'Próximo',
    dayNamesMin: ['Se', 'Te', 'Qu', 'Qu', 'Se', 'Sá', 'Do'],
    monthNames: ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Augosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro']
  });
}
