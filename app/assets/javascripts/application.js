// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require json2
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require underscore
//= require bootstrap
//= require bootstrap-datetimepicker.min
//= require bootstrap-rowlink.min
//= require_tree ./application
//- require_self

jQuery.ajaxSetup({
  'beforeSend': function(xhr) {
    xhr.setRequestHeader("Accept", "text/javascript");
  }
});

var searchBox = $("#search_form form input[type=search]");
var searchBoxValue = searchBox.val();

searchBox.keyup(_.debounce(function () {
  var input = $(this)
  var newValue = input.val();
  var url_string = window.location.href;
  var url = new URL(url_string);
  var fullscr = url.searchParams.get("fullscr");
  var perPage = url.searchParams.get("per_page");
  if (searchBoxValue !== newValue) {
    input.submit();
    history.pushState({}, '', '?' + input.serialize() + '&fullscr=' + fullscr + '&per_page=' + perPage);
  }
  searchBoxValue = newValue;
}, 200));
