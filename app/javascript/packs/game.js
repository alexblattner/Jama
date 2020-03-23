/**
 * @author Alex Blattner
 */
$("#user_input").focus();
var p=$("#health-bar div").attr("percent");
healthbar(p);
setTimeout(function(){healthbarchange(20);},5000);

function healthbar(p){
	$("#health-bar div").attr("percent",p);
	$("#health-bar div").width(p+"%");
	var g=255*p/100;
	var r=255-g;
	$("#health-bar div").css("background","rgb("+r+","+g+",0)")
}
function healthbarchange(p){
	$("#health-bar div").attr("percent",p);
	$("#health-bar div").width(p+"%");
	var g=255*p/100;
	var r=255-g;
	$("#health-bar div").animate({
		backgroundColor: "rgb("+r+","+g+",0)",
		width: p+"%"
	}, 2000 );
}
function damaged(d){
	d.animate({opacity:0},100,function(){
		d.animate({opacity:1},100,function(){
			d.animate({opacity:0},100,function(){
				d.animate({opacity:1},100);
			});
		});
	});
}
function hero_attack(){
	$("#hero").animate({left:"+=50"},100,function(){
		$("#hero").animate({left:"-=50"},100);
	});
}
