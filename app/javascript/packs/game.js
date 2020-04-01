/**
 * @author Alex Blattner
 */
require("jquery-ui")
$("#user_input").focus();
var p=$("#health-bar div").attr("percent");
healthbar(p);
$(document).on("click",function(){
	next();
});
function next(){
	if(!$("body").hasClass("action")){
	var e=events();
	
	if(e==0){
		
	}
	}
}
function events(){
var events=JSON.parse($("#game-screen").attr("events"));
if(events.length>0){
var url="/events/"+events[0];
$.get(url,function(d){
	console.log(d);
	$("body").addClass("action");
	$("#tip").hide();
	$("#description").empty();
		$("#description").append("<p>You encountered <b>"+d.name+"</b></p>");
		setTimeout(function(){eventBackground(d.image)},800);
		setTimeout(function(){
		$("#description").append("<p>"+d.description+"</p>");
		var r=JSON.parse(d.result);
		var k=Object.keys(r);
		for(var i=0;i<k.length;i++){
			if(k[i]=="hp"){
				if(r.hp<0){
					damaged($("#hero"));
					healthbarchange(r.hp);
					$("#description").append("<p>You took <b>"+(r.hp*(-1))+" damage</b></p>");
				}else{
					healthbarchange(r.hp);
					$("#description").append("<p>You healed for <b>"+r.hp+" HP</b></p>");
				}
			}
		}
		$("body").removeClass("action");
		$("#tip").show();
		},2600);
	events.shift();
	$("#game-screen").attr("events",JSON.stringify(events));
});
return 1
}else
return 0;
}
function healthbar(p){
	$("#health-bar div").attr("percent",p);
	$("#health-bar div").width(p+"%");
	var g=255*p/100;
	var r=255-g;
	$("#health-bar div").css("background","rgb("+r+","+g+",0)")
}
function eventBackground(img){
	$("#game-screen").append("<img src='"+img+"' id='event'/>");
	$("#event").animate({
		opacity:1
	},500,function(){
		setTimeout(function(){
			$("#event").animate({
				opacity:0
			},200,function(){
				$("#event").remove();
			});
		},500);
	});
}
//function instantEvent()
function healthbarchange(hp){
	var h=parseInt($("#health-bar span").text())+(hp);
	if( h>parseInt($("#health-bar div").attr("max")))
	h=parseInt($("#health-bar div").attr("max"));
	else if(h<0)
	h=0;
	$("#health-bar span").text(h);
	var p=(h/parseInt($("#health-bar div").attr("max")))*100;
	$("#health-bar div").attr("percent",p);
	var g=parseInt(255*parseInt(p)/100);
	var r=255-g;
	var rgb="rgb("+r+","+g+",0)";
	$("#health-bar span").text(p);
	$("#health-bar div").animate({
		backgroundColor: rgb,
		width: p+"%"
	}, 1000 );
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
