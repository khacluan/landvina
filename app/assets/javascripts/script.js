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
	
	$(document.body).delegate(".dynamic-link", 'click', function(e){	
		var dom = $(this).attr('data-load-element');
		var url = $(this).attr('data-url');
		var data = $(this).attr('data-type');
		var method = $(this).attr('data-method');
    $("div.ajax-loading").removeClass("hidden"); 	
		$.ajax({
			url : url,
			type: method,
			data: {"type" : data},
			cache: true,
			success: function (result, textStatus, jqXHR) {
        // if 304, re-request the data
        if (result === undefined && textStatus == 'notmodified') {
            $.ajax({
                type: method,
                url: url,
                data: data,
                cache: true,
                ifModified: false, // don't check with server
                success: function (cachedResult, textStatus, jqXHR) {
                		$("div.ajax-loading").addClass("hidden");
                    $("#stage").html(cachedResult);
                }
            });
        }
        else{
            $("div.ajax-loading").addClass("hidden");
            $("#stage").html(result);
    		}
    	}
		});
		e.preventDefault();
		return false;
	});
});