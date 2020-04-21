/**
 * @author Alex Blattner
 */
require("jquery-ui")
$("#user_input").focus();
var inventory_tip='<div id="inv-tip">click on your inventory bag to check your inventory</div>';
var continure_tip='<div id="continue-tip">click anywhere on the screen to continue</div>';
var doors_tip='<div id="doors-tip">click on a door to go to another level</div>';
var won_tip='<div id="doors-tip">click anywhere on the screen to restart the game</div>';
$("#tip").append(inventory_tip+continure_tip);
healthbar(0,"hero");
healthbar(0,"enemy");
expbar(0);
$(document).on("click","#game-screen",function(){
	if (!$(this).hasClass('hold')) {
		$(this).addClass('hold');
		next();
	}
});
$(document).on({
    mouseenter: function(){
        change_description("This is the <b>"+$(this).attr("name")+"</b>. "+$(this).attr("desc")+requirements_tip($(this).attr('requirement')));
    },
    mouseleave: function(){
        change_description("You have cleared this level, now choose your path.");
    },
    click:function(){
    	var id=$(this).attr("id");
    	var url="/doors/open/"+id;
    	$.get(url,function(d){
    		if(JSON.stringify(d)!='[0]'){
    		if(d.length!=0){
    		var r=JSON.parse(d.result);
			var k=Object.keys(r);
			for(var i=0;i<k.length;i++){
				if(k[i]=="hp"){
					if(r.hp<0){
						damaged($("#hero"));
						healthbarchange(r.hp,"hero");
						$("#description").append("<p>You took <b>"+(r.hp*(-1))+" damage</b></p>");
					}else{
						healthbarchange(r.hp,"hero");
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
			}
			setTimeout(function(){
				id=window.location.href.split("/")[4];
				$.get("/gamestates/partial/"+id,function(d){
					$("#game-screen").attr("events",d.events);
					$("#background-image").attr("src",d.level.image);
					$("#game-screen").removeClass('hold');
					$("#doors-holder").empty();
					$("#hero").show();
					change_description(d.level.description);
				});
			},k.length*800);
			}else{
				alert("requirements not met");
			}
    	});
    }
}, "#doors-holder img");
function next(){
	var id=window.location.href.split("/")[4];
	var url="/level-doors/"+id;
	if($("#game-screen").attr("r")!=1){
		if(parseInt($("#hero-info .health-bar span").text())>0){
			var e=events();
			if(e==0){
				$("#hero").hide();
				$.get(url,function(d){
					if(typeof d!='undefined'&&d.length>0){
						change_description("You have cleared this level, now choose your path.");
						for(var i=0;i<d.length;i++){
							$("#doors-holder").append("<img id='"+d[i]['id']+"' requirement='"+d[i]['requirement']+"' name='"+d[i]['name']+"' desc='"+d[i]['description']+"' src='"+d[i]['image']+"'/>");
							$("#tip").empty();
							$("#tip").append(doors_tip);
						}
					}else{
						change_description("You completed this game, congratulations!");
						$("#tip").empty();
						$("#tip").append(won_tip);
						$("#game-screen").attr("r",1);
						$("#game-screen").removeClass('hold');
					}
				});
			}
		}else{
			change_description("You died.");
			$("#tip").empty();
			$("#tip").append(won_tip);
			$("#game-screen").attr("r",1);
			$("#game-screen").removeClass('hold');
		}
	}else{
		url="/gamestates/reset/"+id;
		$.get(url,function(){
			location.reload();
		});
	}
}
function requirements_tip(ob){
	ob=JSON.parse(ob);
	var arr=Object.keys(ob);
	var f='';
	if(arr.length>0){
		f="<br/>You need to ";
		for(var i=0;i<arr.length;i++){
			if(ob[arr[i]].charAt(0)==">"){
				if(arr[i]!="level")
				f+="have more than "+ob[arr[i]].substring(1)+" "+arr[i];
				else
				f+="to be more than "+ob[arr[i]].substring(1)+" "+arr[i];
			}else if(ob[arr[i]].charAt(0)=="="){
				if(arr[i]!="level")
				f+="have "+ob[arr[i]].substring(1)+" "+arr[i];
				else
				f+="to be "+ob[arr[i]].substring(1)+" "+arr[i];
			}else if(ob[arr[i]].charAt(0)=="<"){
				if(arr[i]!="level")
				f+="have less than "+ob[arr[i]].substring(1)+" "+arr[i];
				else
				f+="to be less than "+ob[arr[i]].substring(1)+" "+arr[i];
			}else{
				break;
			}
			if(i<arr.length-1)
			f+=", "
			else
			f+=" to enter";
		}
	}
	return f;
}
function change_description(text){
	$("#description").empty();
	$("#description").append(text);
}
function events(){
var events=JSON.parse($("#game-screen").attr("events"));
if($("#game-screen").attr("boss")=="" || typeof $("#game-screen").attr("boss")=="undefined"){
	if(events.length>0){
	var url="/event_instances/"+events[0]+".json";
	$.get(url,function(d){
		var r=d;
		r['result']=JSON.parse(r['result']);
		if(typeof r.result.attack=="undefined"){
			$("#tip").hide();
			$("#description").empty();
			$("#description").append("<p>You encountered <b>"+r.name+"</b></p>");
			setTimeout(function(){eventBackground(r.image)},800);
			setTimeout(function(){
			$("#description").append("<p>"+r.description+"</p>");
			hero_change(r.result);
			$("#tip").show();
			events.shift();
			$("#game-screen").removeClass('hold');
			$("#game-screen").attr("events",JSON.stringify(events));
			},2600);
		}else{
			var pro=(r.progress==1)?0:r.progress.substring(0, r.progress.length - 2);
			if($("#enemy-info").length<1){
				$("#game-screen").append(`<div id="enemy-info"><div>${r.name}</div>
				<div class="health-bar"><span>${pro}</span>
				<div max="${r.result.hp}" percent="${pro*100/r.result.hp}"></div></div>
				</div>
				<img id="enemy" src="${r.image}"/>`);
			}
			healthbar(0,"enemy");
			if((r.result.hp+"hp")!=r.progress){
				hero_attack();
				var damage=parseInt($("#enemy-info span").text())-pro;
				change_description("You dealt <b>"+damage+" damage</b>");
				healthbarchange((-1)*damage,"enemy");
				damaged($("#enemy"));
				$("#game-screen").attr("boss",JSON.stringify(r.result));
			}
			setTimeout(function(){$("#game-screen").removeClass('hold')},1000);
		}
	});
	return 1
	}else
	return 0;
}else{
	var json=JSON.parse($("#game-screen").attr("boss"));
	if($("#enemy-info span").text()!=0){
		enemy_attack();
		hero_change(json.attack);
	}else{
		hero_change(json.death);
		events.shift();
		$("#game-screen").attr("events",JSON.stringify(events));
		$("#enemy").animate({height:0},500,function(){
			$("#enemy").remove();
			$("#enemy-info").remove();
		});
	}
	$("#game-screen").attr("boss","");
	setTimeout(function(){$("#game-screen").removeClass('hold')},1000);
}
}
function hero_change(r){
	var k=Object.keys(r);
	for(var i=0;i<k.length;i++){
		if(k[i]=="hp"){
			if(r.hp<0){
				damaged($("#hero"));
				healthbarchange(r.hp,"hero");
				$("#description").append("<p>You took <b>"+(r.hp*(-1))+" damage</b></p>");
			}else{
				healthbarchange(r.hp,"hero");
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
}
function healthbar(c,s){
	var h=parseInt($("#"+s+"-info .health-bar span").text())+c;
	var m=parseInt($("#"+s+"-info .health-bar div").attr("max"));
	h=(h<0)?0:(h>m)?m:h;
	var p=Math.floor(h*100/m);
	$("#"+s+"-info .health-bar span").text(h);
	$("#"+s+"-info .health-bar div").attr("percent",p);
	$("#"+s+"-info .health-bar div").width(p+"%");
	var g=255*p/100;
	var r=255-g;
	$("#"+s+"-info .health-bar div").css("background","rgb("+r+","+g+",0)")
}
function expbar(c){
	var h=parseInt($("#exp-bar span").text())+c;
	var m=parseInt($("#exp-bar div").attr("max"));
	h=(h<0)?0:(h>m)?m:h;
	var p=Math.floor(h*100/m);
	$("#exp-bar span").text(h);
	$("#exp-bar span").attr("exp",h)
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
function healthbarchange(hp,s){
	var h=parseInt($("#"+s+"-info .health-bar span").text())+(hp);
	if( h>parseInt($("#"+s+"-info .health-bar div").attr("max")))
	h=parseInt($("#"+s+"-info .health-bar div").attr("max"));
	else if(h<0)
	h=0;
	$("#"+s+"-info .health-bar span").text(h);
	var p=(h/parseInt($("#"+s+"-info .health-bar div").attr("max")))*100;
	$("#"+s+"-info .health-bar div").attr("percent",p);
	var g=parseInt(255*parseInt(p)/100);
	var r=255-g;
	var rgb="rgb("+r+","+g+",0)";
	$("#"+s+"-info .health-bar div").animate({
		backgroundColor: rgb,
		width: p+"%"
	}, 1000 );
}
function expbarchange (exp) {
  var lvl=parseInt($("#lvl").attr("lvl"));
  var texp=0;
  var m=1;
  for(var i=0;i<=lvl;i++){
  	texp+=100*m;
  	m*=2;
  }
  var done=false;
  if(exp>0){
  	while(exp>0 && !done){
  		if(exp+parseInt($("#exp-bar span").attr("exp"))>=parseInt($("#exp-bar div").attr("max"))){
  			if($("#exp-bar div").attr("percent")!=100){
				$("#exp-bar div").width("100%");
  			}
  			var inc=parseInt($("#exp-bar div").attr("max"))-parseInt($("#exp-bar span").text());
  			exp-=inc;
			$("#exp-bar span").text($("#exp-bar div").attr("max"));
			$("#exp-bar span").attr("exp",0);
			$("#exp-bar div").width("100%");
			$("#exp-bar div").attr("percent",100);
  			$("#exp-bar div").attr("max",Math.floor(parseInt($("#exp-bar div").attr("max"))*2));
  			lvl++;
  			$("#exp-bar span").text(0);
  		}else{
	  		done=true;
  		}
  		if(done==true||exp==0){
  			setTimeout(function(){
  				if($("#exp-bar div").attr("percent")==100){
	  				$("#exp-bar div").width(0);
	  				$("#exp-bar span").text(0);
	  			}
	  			var ce=exp+parseInt($("#exp-bar span").attr("exp"));
	  			$("#exp-bar span").attr("exp",ce);
	  			$("#exp-bar span").text(ce);
	  			var p=Math.floor(ce*100/parseInt($("#exp-bar div").attr("max")));
	  			$("#exp-bar div").attr("percent",p);
	  			$("#exp-bar div").animate({width:p+"%"},400,function(){
		  			var linc=lvl-parseInt($("#lvl").attr("lvl"));
		  			$("#lvl").attr("lvl",lvl);
		  			$("#lvl").text("lvl "+lvl);
		  			healthbarchange(linc*10,"hero");
		  		});
	  		},400);
  		}
  	}
  }else{
  	while(exp>0&&texp>0){
  		
  	}
  }
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
function enemy_attack(){
	$("#enemy").animate({right:"+=50"},100,function(){
		$("#enemy").animate({right:"-=50"},100);
	});
}
