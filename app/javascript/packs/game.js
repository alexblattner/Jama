/**
 * @author Alex Blattner
 */
require("jquery-ui")
$("#user_input").focus();
var p=$("#health-bar div").attr("percent");
var inventory_tip='<div id="inv-tip">click on your inventory bag to check your inventory</div>';
var continure_tip='<div id="continue-tip">click anywhere on the screen to continue</div>';
var doors_tip='<div id="doors-tip">click on a door to go to another level</div>';
$("#tip").append(inventory_tip+continure_tip);
healthbar(p);
p=$("#exp-bar div").attr("percent");
expbar(p);
$(document).on("click","#game-screen",function(){
	next();
});
$(document).on({
    mouseenter: function(){
        change_description("This is the <b>"+$(this).attr("name")+" door</b>. "+$(this).attr("desc"));
    },
    mouseleave: function(){
        change_description("You have cleared this level, now choose your path.");
    },
    click:function(){
    	var id=$(this).attr("id");
    	$.get("/doors/open/"+id,function(){
    		
    	});
    }
}, "#doors-holder img");
function next(){
	if(!$("body").hasClass("action")){
	var e=events();
	
		if(e==0){
			$("#hero").hide();
			change_description("You have cleared this level, now choose your path.");
			var id=window.location.href.split("/")[4];
			var url="/level-doors/"+id;
			$.get(url,function(d){
				for(var i=0;i<d.length;i++){
					$("#doors-holder").append("<img id='"+d[i]['id']+"' name='"+d[i]['name']+"' desc='"+d[i]['description']+"' src='"+d[i]['image']+"'/>");
					$("#tip").empty();
					$("#tip").append(doors_tip);
				}
			});
		}
	}
}
function change_description(text){
	$("#description").empty();
	$("#description").append(text);
}
function events(){
var events=JSON.parse($("#game-screen").attr("events"));
if(events.length>0){
var url="/event_instances/"+events[0]+".json";
$.get(url,function(d){
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
			}else if(k[i]=="exp"){
				if(r.exp<0){
					damaged($("#hero"));
					expbarchange(r.exp);
					$("#description").append("<p>You lost <b>"+(r.exp*(-1))+" exp</b></p>");
				}else{
					expbarchange(r.exp);
					$("#description").append("<p>You gained <b>"+r.exp+" exp</b></p>");
				}
			}else if(k[i]=="gold"){
				$("#gold").attr("gold",parseInt($("#gold").attr("gold"))+r.gold);
				$("#gold").text("Gold: "+$("#gold").attr("gold"));
				$("#gold").animate({color:"yellow"},300,function(){
					$("#gold").animate({color:"black"},300);
				});
				if(r.gold<0){
					damaged($("#hero"));
					$("#description").append("<p>You lost <b>"+(r.gold*(-1))+" gold</b></p>");
				}else{
					$("#description").append("<p>You gained <b>"+r.gold+" gold</b></p>");
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
function expbar(p){
	$("#exp-bar div").attr("percent",p);
	$("#exp-bar div").width(p+"%");
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
function expbarchange (exp) {
  var time=0;
  var lvl=parseInt($("#exp").attr("lvl"));
  var texp=0;
  var m=1;
  for(var i=0;i<=lvl;i++){
  	texp+=100*m;
  	m*=1.5;
  }
  var p=[];
  var e=[];
  if(exp>0){
  	while(exp>0){
  		if(exp+parseInt($("#exp-bar span").attr("exp"))>=Math.floor(parseInt($("#exp-bar div").attr("max")))){
  			exp-=parseInt($("#exp-bar div").attr("max"))-parseInt($("#exp-bar span").text());
  			$("#exp-bar span").attr("exp",$("#exp-bar div").attr("max"));
  			$("#exp-bar div").attr("max",Math.floor(parseInt($("#exp-bar div").attr("max"))*1.5));
  			p.push("100%");
  		}else{
  		p.push(((parseInt($("#exp-bar span").attr("exp")))/parseInt($("#exp-bar div").attr("max")))+"%");
  		$("#exp-bar span").text((exp+parseInt($("#exp-bar span").text())));
  		exp=0;
  		}
  		e.push($("#exp-bar span").attr("exp"));
  		setTimeout(function(){
  			var w=p.shift();
  			var ex=e.shift();
  			$("#exp-bar span").text(ex);
  			if(w=="100%"){
  			$("#lvl").attr("lvl",parseInt($("#lvl").attr("lvl"))+1);
  			$("#lvl").text("lvl "+$("#lvl").attr("lvl"));
  			var chp=parseInt($("#health-bar span").text())+10;
  			var max=parseInt($("#health-bar div").attr("max"))+10;
  			$("#health-bar span").text(chp);
  			$("#health-bar div").attr("max",max);
  			healthbar(100*chp/max);
  			}
  			$("#exp-bar div").animate({width:w},75,function(){
  			if(w=="100%"){
  				$("#exp-bar span").text(0);
  				$("#exp-bar div").width(0);
  			}
  		});
  		},time);
  		if(p=="100%")
  		$("#exp-bar span").attr("exp",0);
  		time+=125;
  	}
  }else{
  	while(exp>0&&texp>0){
  		
  	}
  }
  setTimeout(function(){
  		var q=((parseInt($("#exp-bar span").attr("exp"))));
  		var j=(parseInt($("#exp-bar div").attr("max")));
		var w=((q/j)*100)+"%";
		var ex=$("#exp-bar span").attr("exp");
		$("#exp-bar span").text(ex);
		$("#exp-bar div").animate({width:w},100,function(){
		if(w=="100%"){
			$("#exp-bar span").text(0);
			$("#exp-bar div").width(0);
		}
	});
	},time);
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
