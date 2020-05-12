$(document).on("keyup",'#search',function(){
	var url="/barload?search="+$(this).val();
	$.get(url, function(d){
		$(".tab-content").empty();
		$(".tab-content").append(d);
	});
});