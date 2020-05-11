$(document).on("keyup",'#search',function(){
	var url="/barload?search="+$(this).val();
	$.get(url, function(d){
		$(".gs-container").replaceWith(d);
	});
});