// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require locations
//= require ./admins/jquery.layout
//= require ./admins/jquery.ui.all

$(document).ready(function(){

  $(document.body).delegate('form.base-form fieldset.actions input.base-form-submit', 'click', function(e){
  	$('form.base-form')
  	.bind("ajax:beforeSend", function(evt, xhr, settings){
        
  	})
  	.bind("ajax:success", function(evt, data, status, xhr){
      $('div#stage').html(data);
  	})
  	.bind('ajax:complete', function(evt, xhr, status){
			
  	});
  });
	
	
	$(document.body).delegate('a.dynamic-link', 'click', function(e){
		var _this = this;
		var dom = $(this).attr('data-element');
		$.ajax({
			url : $(_this).attr("data-url"),
			type: $(_this).attr("data-method"),
			success: function(response){
				$(dom).html(response);
			}
		});
		e.preventDefault();
		return false;
	});
	
	
});