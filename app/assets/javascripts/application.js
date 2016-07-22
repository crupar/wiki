// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require showdown
//= require bootstrap
//= require_tree .



$(document).ready(function() {
  var converter = new showdown.Converter();
    $('#wikipage_title').on('keyup', function () {
      var mdowntitle = $('#wikipage_title').val();
      var html = converter.makeHtml(mdowntitle);
      $('#wiki-preview-title').html(html);
    });

    $('#wikipage_body').on('keyup', function() {
      var mdown = $('#wikipage_body').val();
      var html = converter.makeHtml(mdown);
      $('#wiki-preview-body').html(html);
    });
});
