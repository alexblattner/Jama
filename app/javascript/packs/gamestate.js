/**
 * @author Alex Blattner
 */
require("jquery-ui")
$("#user_input").focus();
var continue_tip='click anywhere on the screen to continue';
var doors_tip='click on a door to go to another level';
var won_tip='click anywhere on the screen to restart the game';
var fight_tip='click anywhere on the screen to attack';
var choice_tip='click on one of your possible decisions'
tip(continue_tip);
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
    	var x=($("#game-screen").attr("choice")=="" || typeof $("#game-screen").attr("choice")=="undefined")?"<p>This is the <b>"+$(this).attr("name")+"</b>. ":"";
        change_description(x+$(this).attr("desc")+requirements_tip($(this).attr('requirement'))+"</p>");
    },
    mouseleave: function(){
    	if($("#game-screen").attr("choice")=="" || typeof $("#game-screen").attr("choice")=="undefined")
        change_description("<p>You have cleared this level, now choose your path.</p>");
        else{
        	var j=JSON.parse($("#game-screen").attr("choice"));
        	change_description('You encountered <b>'+j['name']+'</b>. '+j['description']);
        }
    },
    click:function(){
    	if($("#game-screen").attr("choice")=="" || typeof $("#game-screen").attr("choice")=="undefined"){
    	var id=$(this).attr("id");
    	var url="/doors/open/"+id+".json";
    	$.get(url,function(d){
    		if(JSON.stringify(d)!='[0]'){
    		if(d.length!=0){
    		$("#doors-holder").empty();
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
					$("#background-image").attr("src",d.level.level_image);
					$("#game-screen").removeClass('hold');
					$("#doors-holder").empty();
					$("#hero").show();
					change_description(d.level.description);
					tip(continue_tip);
					$("#background-image").attr("src",d.level.image);
					$("#game-screen").waitForImages(function() {
					    $("#game-screen").attr("events",d.events);
						$("#game-screen").removeClass('hold');
						$("#hero").show();
						change_description(d.level.description);
						tip(continue_tip);
					});
				});
			},k.length*800);
			}else{
				alert("requirements not met");
			}
    	});
    }else{
    	var events=JSON.parse($("#game-screen").attr("events"));
    	var url="/event_instances/"+events[0]+"/"+$(this).attr('id')+".json";
    	$.get(url,function(d){
    		if(JSON.stringify(d)!='[0]'){
    		events.shift();
    		for(var i=d.length-1;i>=0;i--)
    			events.unshift(d[i]);
			$("#game-screen").attr("events",JSON.stringify(events));
			$("#game-screen").attr("choice","");
			$("#doors-holder").empty();
			$("#doors-holder").removeClass('choice');
			$("#game-screen").removeClass('hold');
			}else{
				alert("requirements not met");
			}
    	});
    }
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
						change_description("<p>You have cleared this level, now choose your path.</p>");
						for(var i=0;i<d.length;i++){
							d[i]['requirement']=(typeof d[i]['requirement']=="undefined")?"":d[i]['requirement'];
							$("#doors-holder").append("<img id='"+d[i]['id']+"' requirement='"+d[i]['requirement']+"' name='"+d[i]['name']+"' desc='"+d[i]['description']+"' src='"+d[i]['door_image']+"'/>");
							tip(doors_tip);
							$("#doors-holder").css("display","none");
							$("#doors-holder").append("<img id='"+d[i]['id']+"' requirement='"+d[i]['requirement']+"' name='"+d[i]['name']+"' desc='"+d[i]['description']+"' src='"+d[i]['image']+"'/>");
							$("#game-screen").waitForImages(function() {
								$("#doors-holder").css("display","block");
								tip(doors_tip);
							});
						}
					}else{
						change_description("<p>You completed this game, congratulations!</p>");
						tip(won_tip)
						$("#game-screen").attr("r",1);
						$("#game-screen").removeClass('hold');
					}
				});
			}
		}else{
			change_description("<p>You died.</p>");
			tip(won_tip);
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
function tip(s){
	$("#tip").replaceWith("<span id='tip'>"+s+"</span>");
}
function requirements_tip(ob){
	ob=JSON.parse(ob);
	var arr=Object.keys(ob);
	var f='';
	if(arr.length>0){
		f="<br/><p class='warning'>You need to ";
		for(var i=0;i<arr.length;i++){
			if(ob[arr[i]].charAt(0)==">"){
				if(arr[i]!="rank")
				f+="have more than "+ob[arr[i]].substring(1)+" "+arr[i];
				else
				f+="to be rank "+ob[arr[i]].substring(1)+" or higher";
			}else if(ob[arr[i]].charAt(0)=="="){
				if(arr[i]!="rank")
				f+="have "+ob[arr[i]].substring(1)+" "+arr[i];
				else
				f+="to be rank "+ob[arr[i]].substring(1);
			}else if(ob[arr[i]].charAt(0)=="<"){
				if(arr[i]!="rank")
				f+="have less than "+ob[arr[i]].substring(1)+" "+arr[i];
				else
				f+="to be rank "+ob[arr[i]].substring(1)+" or lower";
			}else{
				break;
			}
			if(i<arr.length-1)
			f+=", "
			else
			f+=" to enter</p>";
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
if(($("#game-screen").attr("boss")=="" || typeof $("#game-screen").attr("boss")=="undefined")&&($("#game-screen").attr("choice")=="" || typeof $("#game-screen").attr("choice")=="undefined")){
	if(events.length>0){
	var url="/event_instances/"+events[0]+".json";
	$.get(url,function(d){
		var r=d;
		if(JSON.stringify(d)!="[0,0]"){
			r['result']=JSON.parse(r['result']);
			if(r['event_type']=="choice"){
				change_description('You encountered <b>'+r['name']+'</b>. '+r['description']);
				tip(choice_tip);
				d=r.result;
				for(var i=0;i<d.length;i++){
					d[i]['requirement']=(typeof d[i]['requirement']=='undefined')?"{}":d[i]['requirement'];
					$("#doors-holder").css("display","none");
					$("#doors-holder").append("<img id='"+i+"' requirement='"+d[i]['requirement']+"' desc='"+d[i]['description']+"' src='"+d[i]['image']+"'/>");
					$("#game-screen").waitForImages(function() {
						$("#doors-holder").css("display","block");
						tip(doors_tip);
					});
				}
				$("#doors-holder").addClass("choice");
				$("#game-screen").attr("choice",JSON.stringify(r));
			}else if(r['event_type']=="direct"){
				$("#tip").hide();
				$("#description").empty();
				$("#description").append("<p>You encountered <b>"+r.name+"</b></p>");
				eventBackground(r.image);
				setTimeout(function(){
				$("#description").append("<p>"+r.description+"</p>");
				hero_change(r.result);
				$("#tip").show();
				events.shift();
				$("#game-screen").removeClass('hold');
				$("#game-screen").attr("events",JSON.stringify(events));
				},2600);
			}else{
				$("#tip").hide();
				$("#description").empty();
				$("#description").append("<p>You encountered <b>"+r.name+"</b>."+r.description+"</p>");
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
					change_description("<p>You dealt <b>"+damage+" damage</b></p>");
					healthbarchange((-1)*damage,"enemy");
					damaged($("#enemy"));
					$("#game-screen").attr("boss",JSON.stringify(r.result));
				}
				setTimeout(function(){$("#game-screen").removeClass('hold')},500);
				$("#tip").show();
			}
		}else{
			events.shift();
			$("#game-screen").removeClass('hold');
			$("#game-screen").attr("events",JSON.stringify(events));
			$("#game-screen").trigger("click");
		}
	});
	return 1
	}else
	return 0;
}else if($("#game-screen").attr("boss")!="" && typeof $("#game-screen").attr("boss")!="undefined"){
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
	$("#game-screen").waitForImages(function() {
		setTimeout(function(){
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
		},800);
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
  			$("#hero-info .health-bar div").attr("max",100+(lvl-1)*10);
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
		  			$("#lvl").text("Rank "+lvl);
		  			healthbarchange(linc*10,"hero");
		  		});
	  		},400);
  		}
  	}
  }else{
  	while(exp<0&&texp>0&&!done){
  		var c=parseInt($("#exp-bar span").attr("exp"))+exp;
  		if(c<0){
  			if(lvl==1){
  				$("#exp-bar div").attr("percent",0);
  				$("#exp-bar span").text(0);
  				$("#exp-bar span").attr("exp",0);
  				exp=0;
  			}else{
	  			exp+=parseInt($("#exp-bar span").attr("exp"));
	  			$("#exp-bar div").attr("max",Math.floor(parseInt($("#exp-bar div").attr("max"))/2));
				$("#exp-bar span").text($("#exp-bar div").attr("max"));
				$("#exp-bar span").attr("exp",$("#exp-bar div").attr("max"));
				$("#exp-bar div").width("100%");
				$("#exp-bar div").attr("percent",0);
				lvl--;
	  			if(lvl==0){
	  				exp=0;
	  				lvl++;
	  			}
	  			$("#exp-bar span").text($("#exp-bar div").attr("max"));
	  			$("#hero-info .health-bar div").attr("max",100+(lvl-1)*10);
  			}
  		}else{
	  		done=true;
	  		$("#exp-bar span").text(c);
			$("#exp-bar span").attr("exp",c);
  		}
  		if(done==true||exp==0){
  			setTimeout(function(){
	  			var p=Math.floor(parseInt($("#exp-bar span").attr("exp"))*100/parseInt($("#exp-bar div").attr("max")));
	  			$("#exp-bar div").attr("percent",p);
	  			if(parseInt($("#hero-info .health-bar div").attr("max"))<parseInt($("#hero-info .health-bar span").text()))
	  			$("#hero-info .health-bar span").text($("#hero-info .health-bar div").attr("max"))
	  			var hpp=(parseInt($("#hero-info .health-bar span").text())/parseInt($("#hero-info .health-bar div").attr("max")))*100;
				$("#hero-info .health-bar div").attr("percent",hpp);
	  			$("#exp-bar div").animate({width:p+"%"},400,function(){
		  			$("#lvl").attr("lvl",lvl);
		  			$("#lvl").text("Rank "+lvl);
		  			healthbarchange(0,"hero");
		  		});
	  		},400);
  		}
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
(function (factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['jquery'], factory);
    } else if (typeof exports === 'object') {
        // CommonJS / nodejs module
        module.exports = factory(require('jquery'));
    } else {
        // Browser globals
        factory(jQuery);
    }
}(function ($) {
    // Namespace all events.
    var eventNamespace = 'waitForImages';

    // Is srcset supported by this browser?
    var hasSrcset = (function(img) {
        return img.srcset && img.sizes;
    })(new Image());

    // CSS properties which contain references to images.
    $.waitForImages = {
        hasImageProperties: [
            'backgroundImage',
            'listStyleImage',
            'borderImage',
            'borderCornerImage',
            'cursor'
        ],
        hasImageAttributes: ['srcset']
    };

    // Custom selector to find all `img` elements with a valid `src` attribute.
    $.expr.pseudos['has-src'] = function (obj) {
        // Ensure we are dealing with an `img` element with a valid
        // `src` attribute.
        return $(obj).is('img[src][src!=""]');
    };

    // Custom selector to find images which are not already cached by the
    // browser.
    $.expr.pseudos.uncached = function (obj) {
        // Ensure we are dealing with an `img` element with a valid
        // `src` attribute.
        if (!$(obj).is(':has-src')) {
            return false;
        }

        return !obj.complete;
    };

    $.fn.waitForImages = function () {

        var allImgsLength = 0;
        var allImgsLoaded = 0;
        var deferred = $.Deferred();
        var originalCollection = this;
        var allImgs = [];

        // CSS properties which may contain an image.
        var hasImgProperties = $.waitForImages.hasImageProperties || [];
        // Element attributes which may contain an image.
        var hasImageAttributes = $.waitForImages.hasImageAttributes || [];
        // To match `url()` references.
        // Spec: http://www.w3.org/TR/CSS2/syndata.html#value-def-uri
        var matchUrl = /url\(\s*(['"]?)(.*?)\1\s*\)/g;

        var finishedCallback;
        var eachCallback;
        var waitForAll;

        // Handle options object (if passed).
        if ($.isPlainObject(arguments[0])) {

            waitForAll = arguments[0].waitForAll;
            eachCallback = arguments[0].each;
            finishedCallback = arguments[0].finished;

        } else {

            // Handle if using deferred object and only one param was passed in.
            if (arguments.length === 1 && $.type(arguments[0]) === 'boolean') {
                waitForAll = arguments[0];
            } else {
                finishedCallback = arguments[0];
                eachCallback = arguments[1];
                waitForAll = arguments[2];
            }

        }

        // Handle missing callbacks.
        finishedCallback = finishedCallback || $.noop;
        eachCallback = eachCallback || $.noop;

        // Convert waitForAll to Boolean.
        waitForAll = !! waitForAll;

        // Ensure callbacks are functions.
        if (!$.isFunction(finishedCallback) || !$.isFunction(eachCallback)) {
            throw new TypeError('An invalid callback was supplied.');
        }

        this.each(function () {
            // Build a list of all imgs, dependent on what images will
            // be considered.
            var obj = $(this);

            if (waitForAll) {

                // Get all elements (including the original), as any one of
                // them could have a background image.
                obj.find('*').addBack().each(function () {
                    var element = $(this);

                    // If an `img` element, add it. But keep iterating in
                    // case it has a background image too.
                    if (element.is('img:has-src') &&
                        !element.is('[srcset]')) {
                        allImgs.push({
                            src: element.attr('src'),
                            element: element[0]
                        });
                    }

                    $.each(hasImgProperties, function (i, property) {
                        var propertyValue = element.css(property);
                        var match;

                        // If it doesn't contain this property, skip.
                        if (!propertyValue) {
                            return true;
                        }

                        // Get all url() of this element.
                        while (match = matchUrl.exec(propertyValue)) {
                            allImgs.push({
                                src: match[2],
                                element: element[0]
                            });
                        }
                    });

                    $.each(hasImageAttributes, function (i, attribute) {
                        var attributeValue = element.attr(attribute);
                        var attributeValues;

                        // If it doesn't contain this property, skip.
                        if (!attributeValue) {
                            return true;
                        }

                        allImgs.push({
                            src: element.attr('src'),
                            srcset: element.attr('srcset'),
                            element: element[0]
                        });
                    });
                });
            } else {
                // For images only, the task is simpler.
                obj.find('img:has-src')
                    .each(function () {
                    allImgs.push({
                        src: this.src,
                        element: this
                    });
                });
            }
        });

        allImgsLength = allImgs.length;
        allImgsLoaded = 0;

        // If no images found, don't bother.
        if (allImgsLength === 0) {
            finishedCallback.call(originalCollection);
            deferred.resolveWith(originalCollection);
        }

        // Now that we've found all imgs in all elements in this,
        // load them and attach callbacks.
        $.each(allImgs, function (i, img) {

            var image = new Image();
            var events =
              'load.' + eventNamespace + ' error.' + eventNamespace;

            // Handle the image loading and error with the same callback.
            $(image).one(events, function me (event) {
                // If an error occurred with loading the image, set the
                // third argument accordingly.
                var eachArguments = [
                    allImgsLoaded,
                    allImgsLength,
                    event.type == 'load'
                ];
                allImgsLoaded++;

                eachCallback.apply(img.element, eachArguments);
                deferred.notifyWith(img.element, eachArguments);

                // Unbind the event listeners. I use this in addition to
                // `one` as one of those events won't be called (either
                // 'load' or 'error' will be called).
                $(this).off(events, me);

                if (allImgsLoaded == allImgsLength) {
                    finishedCallback.call(originalCollection[0]);
                    deferred.resolveWith(originalCollection[0]);
                    return false;
                }

            });

            if (hasSrcset && img.srcset) {
                image.srcset = img.srcset;
                image.sizes = img.sizes;
            }
            image.src = img.src;
        });

        return deferred.promise();

    };
}));