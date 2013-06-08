$(document).ready(function(){
	$("body").on({
    ajaxStart: function() { 
        $(this).addClass("ajax-loading"); 
    },
    ajaxStop: function() { 
        $(this).removeClass("ajax-loading"); 
    }    
	});
	
	$(document.body).delegate('li.nav', 'click', function(e){
		$('li.nav').removeClass('selected');
		$(this).addClass('selected');
		e.preventDefault();
	});
	
	$(document.body).delegate("#left_banner .menu-left ul.vnav-menu li", 'click', function(e){
		$("ul.vnav-menu li").removeClass('active');
		$(this).addClass('active');
		e.preventDefault();
	});
	
	$(document.body).delegate("div.host-items div.dynamic-link", 'click', function(e){
		var _this = $(this);		
    $("div.ajax-loading").removeClass("hidden"); 	
		$.ajax({
			url : _this.data('url'),
			type: _this.data('method'),
			data: _this.data('action'),
			success: function(response){
				$("div.ajax-loading").addClass("hidden");
			}
		});
		e.preventDefault();
	});
});