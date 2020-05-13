$(document).on("keyup",'#search',function(){
	var url="/barload?search="+$(this).val();
	$.get(url, function(d){
		$(".tab-content").empty();
		$(".tab-content").append(d);
		if($("ul.nav.nav-tabs").children("li").eq(1).hasClass("active")){
			$(".tab-content").find("#1").removeClass("active");
			$(".tab-content").find("#2").addClass("active");
		}
	});
});