
	<!--
	/////////////////////////////////////// START FUNCTIONS ///////////////////////////////////////////
	function cs_isExternalLink(url){
	  if(!url){ return false; }
	  if(typeof(url) != 'string'){ return true; }
	  url = url.toLowerCase();
	
	  /* what else is missing from the protocol list below? */
	  if(url.indexOf('https://') == 0){ url = url.substring(8); }
	  else if(url.indexOf('http://') == 0){ url = url.substring(7); }
	  else if(url.indexOf('ftp://') == 0){ url = url.substring(6); }
	  else if(url.indexOf('ssl://') == 0){ url = url.substring(6); }
	  else if(url.indexOf('mailto:') == 0){ return true; }
	  else{ return false; }
	
	  if(url.indexOf('www.') == 0){ url = url.substring(4); }
	  var hn = document.location.hostname.toLowerCase();
	  if(hn.indexOf('www.') == 0){ hn = hn.substring(4); }
	
	  if(url.indexOf(hn) != 0){ return true; }
	  return false;
	}
	function cs_getParentClickable(obj, flag){
	  for(var j=0; j<=5; j++){
	    if(flag == 1){ if(obj && obj.nodeName.toUpperCase() == 'A'){ return obj; } } //look for <A> tag
	    if(flag == 2){ if(obj && obj.nodeName.toUpperCase() != 'BODY' && obj.onclick){ return obj; } } //look onclick tag
	    obj = obj.parentNode;
	  }
	  return null;
	}
	function cs_context_click(e){//right click on link
	  var tg = null;
	  if(e){ tg = e.target; }
	  else{ tg = window.event.srcElement; }
	  cs_do_track(tg, false);
	}
	function cs_on_click(e){//left click
	  var tg = null;
	  if(e){ tg = e.target; }
	  else{ tg = window.event.srcElement; }
	  cs_do_track(tg, true);
	}
	function cs_do_track(tg, delay){
	  var url = null;
	  var text = null;
	  try{
	    if(tg){
	      tgP = cs_getParentClickable(tg, 1);
	      if(tgP && tgP.nodeName.toUpperCase() == 'A'){ tg = tgP; }
	
	      if(tg.nodeName.toUpperCase() == 'A'){//A tag - most popular case
	        url = tg.href;
	        if(tg.innerHTML){ text = tg.innerHTML; } //most browsers
	        else if(tg.innerText){ text = tg.innerText; } //ie only
	        else if(tg.text){ text = tg.text; } //mozilla only
	        else{}
	      }else if(tg.nodeName.toUpperCase() == 'INPUT' && tg.type.toUpperCase() == 'SUBMIT'){//form submit button
	        url = tg.form.action;
	        text = tg.value;
	      }else{
	       /* this eliminates all other onclick events */
	
	      }
	      if(url == null || text == null){ return true; } //both url and text must not be NULL 
	
	      if(cs_isExternalLink(url)){
	        if(cs_mbl_isAOL_V8 && (tg.target == '_new' || tg.target == '_blank')){ return true; }
	        url = escape(url);
	        text = escape(text);
	        cs_track_oc(text, url, delay);
	      }
	    }
	  }catch(err){ }
	}
	// THIS FUNCTION TRACKS EXTERNAL URL CLICKS //
	function cs_track_oc(text, url, delay){      
	  try{
	    var now = new Date();
	    var trackURL = cs_url_trker + '?t=2&u=' + url + '&te=' + text + '&i=' + cs_mblID + '&now=' + now.valueOf() + '&d=20060529' + '&db=db2' + '&v=' + mbl_isi; 
	    var x = new Image();
	    x.src = trackURL;
	    if(delay){ cs_pause(900); }
	  }catch(err){ }
	}
	
	// THIS FUNCTION RECORDS APACHE-LIKE LOG INFO ON EVERY PAGE LOAD //
	
	function cs_track_onload(){
	  try{
	
	    var now = new Date();
	    var url = escape(document.location.href);
	    var ext_referrer = document.referrer;
	    if(ext_referrer != '' && cs_isExternalLink(ext_referrer)){
	      var ext_referrer_para = '&eref=' + escape(ext_referrer);
	    }else{
	      var ext_referrer_para = '';
	    }
	    var trackURL = cs_url_trker + '?i=' + cs_mblID + '&t=1&u=' + url + '&a=' + escape(navigator.userAgent) + '&d=20060529' + ext_referrer_para + '&db=db2' + '&now=' + now.valueOf() + '&v=' + mbl_isi;
	
	    var x = new Image();
	    x.src = trackURL;
	
	  }catch(err){ }
	
	  return true;
	}
	function cs_pause(numberMillis) {
	  var now = new Date();
	  var exitTime = now.getTime() + numberMillis;
	  while(true){
	    now = new Date();
	    if(now.getTime() > exitTime){ return; }
	  }
	}
	
	
	/////////////////////////////////////// END FUNCTIONS ///////////////////////////////////////////
	var cs_mbl_isAOL_V8 = false;
	if(navigator.userAgent.indexOf('AOL 8.0') > 0){ cs_mbl_isAOL_V8 = true; }
	
	var cs_mblID = '2006051103121203';
	var cs_url_trker = 'http://track.mybloglog.com/tr/urltrk.php';
	var mbl_isi = 'N2006052906551356';
	if(document.body){//if the script is inside the body tag - which it should be
	  document.body.onclick = cs_on_click;
	  document.body.oncontextmenu = cs_context_click;
	}else if(document){//script is outside the body tag - works in some browsers
	  document.onclick = cs_on_click;
	  document.oncontextmenu = cs_context_click;  
	}else{}
	cs_track_onload();
  if(typeof(mbl_links) == 'undefined'){var mbl_pop_div_node = null;
var mbl_pop_div_active = false;
var mbl_mouse_xcoord = 0;
var mbl_mouse_ycoord = 0;
var mbl_mouse_ycoord_prev = 0;
var mbl_mouse_going_up = false;
var mbl_popup_timeout = null;
var mbl_active_link_obj = null;
var mbl_last_popup_bottomY = 0;
var mbl_link_heights = new Array;
var mbl_body_border_top = 0;
var mbl_clicktagging_ord = '';

var mbl_links = new Array();
mbl_links['http://vrn.org.ru/films/xxx'] = '51';
mbl_links['http://www.goatlist.com'] = '36';
mbl_links['http://obmen-ua.nm.ru/fs.htm'] = '29';
mbl_links['http://xgirls.nxt.ru'] = '28';
mbl_links['http://forum.xakep.ru'] = '18';
mbl_links['http://www.mannetjeopdemaan.org'] = '14';
mbl_links['http://www.video-action.com/hardcore214-movies/movs02.html'] = '10';
mbl_links['http://www.avenes.lv'] = '9';
mbl_links['http://www.askjolene.com'] = '9';
mbl_links['http://projects.tellink.ru/other/setup2-1.exe'] = '7';
mbl_links['http://www.diamondgirls.ru/video.html'] = '7';
mbl_links['http://www.introversion.co.uk'] = '5';
mbl_links['http://www.poornstars.net/pix_sophie_moone_anettalez/gal_20.html'] = '5';
mbl_links['http://www.rwi.pl'] = '5';
mbl_links['http://www.wmasystems.com'] = '5';
mbl_links['http://www.soft4barter.com'] = '5';
mbl_links['http://www.hotzone.ru/?page=satgr'] = '4';
mbl_links['http://www.sinfulcurves.com/link/sp5/dhdevon.html'] = '4';
mbl_links['http://www.sat-key.org'] = '4';
mbl_links['http://www.waycoolsubmit.com'] = '4';
mbl_links['http://keithdevens.com/wiki/programmerfonts'] = '4';
mbl_links['http://www.dvbskystar.com/download/click.php?id=9'] = '3';
mbl_links['http://content.gallerygalore.net/07112005/show'] = '3';
mbl_links['http://keysearch.da.ru'] = '3';
mbl_links['http://vkeys.ubb.cc'] = '3';
mbl_links['http://www.lust-hero.net/freesets/may2006/hh1905h08.html'] = '3';
mbl_links['http://www.picwonder.com/galls/mam/dso/07_29/1_sct.html'] = '3';
mbl_links['http://www.sinfulcurves.com/link/sp5/nsambermichaels5.html'] = '3';
mbl_links['http://etop.ru'] = '3';
mbl_links['http://www.nfr.com/products/bof/overview.shtml'] = '3';
mbl_links['http://cache.fload.ru/?porno'] = '3';
mbl_links['http://wwbm-soft.narod.ru/hacker'] = '3';
mbl_links['http://www.freemedia.ru/list.php?r=video&id_s=6'] = '3';
mbl_links['http://www.praxis-kristall.ch'] = '3';
mbl_links['http://www.sattv.ru'] = '3';
mbl_links['http://www.swissbv.com'] = '3';
mbl_links['http://www4.zpornstars.com/free_zone/topgalle05/feb/0402b00.htm'] = '3';
mbl_links['http://www.google.com/search?q=site:microsoft.com ie6setup.exe'] = '2';
mbl_links['http://www.streethacker.com'] = '2';
mbl_links['http://www.dvbskystar.com/download/click.php?id=13'] = '2';
mbl_links['http://puredawn.org/_/kbe.exe'] = '2';
mbl_links['http://www.gameland.ru/articles/common/anketa.asp'] = '2';
mbl_links['http://www.clubanita.com/free/galleries/star/anitadarkwandacurtis/1'] = '2';
mbl_links['http://www.sinfulcurves.com/link/sp5/nschloejones9.html'] = '2';
mbl_links['http://www.securitylab.ru/tools/_services/download/?id=45056'] = '2';
mbl_links['http://www.sysinternals.com/utilities/accesschk.html'] = '2';
mbl_links['http://beaverbong.com/page_995.htm'] = '2';
mbl_links['http://freeocxxx.com/movies/kpp/01/?nats=mje6mzox'] = '2';
mbl_links['http://nbp-info.ru'] = '2';
mbl_links['http://peace4peace.ru'] = '2';
    var mbl_atag = null;
    function trim(str, ch){
      while (str.substring(0,1) == ch){
        str = str.substring(1, str.length);
      }
      while (str.substring(str.length-1, str.length) == ch){
        str = str.substring(0, str.length-1);
      }
      return str;
    }
    function mbl_number_ordinalize(n){
      if(isNaN(n)){ return n; }
      if(n >= 11 && n <= 19){ return n + 'th'; }
      else if(n % 10 == 1){ return n + 'st'; }
      else if(n % 10 == 2){ return n + 'nd'; }
      else if(n % 10 == 3){ return n + 'rd'; }
      else{ return n + 'th'; }
    }
    function mbl_get_assoc_array_rank(arr, ind){
      var r = 1;
      for(var i in arr){
        if(i == ind){ return r; }
        r++;
      }
      return r;
    }
    function mbl_getElemTop(e){
      var top = e.offsetTop;
      var pe = e.offsetParent;
      while (pe != null) {
        if(pe.offsetTop > 0){ top += pe.offsetTop; }
        pe = pe.offsetParent;
      }
      return top;
    }
    function mbl_getObjectStyle(obj, styleIE, styleMozilla) {
      if(obj.currentStyle){
        return obj.currentStyle[styleIE];
      }else if (window.getComputedStyle) {
        var compStyle = window.getComputedStyle(obj, '');
        return compStyle.getPropertyValue(styleMozilla);
      }
      return '0';
    }
    function mbl_onmousemove(e){
      if(!e){ e = window.event; }
      if(e){ 
        if(e.pageX || e.pageY){
          mbl_mouse_xcoord = e.pageX;
          mbl_mouse_ycoord = e.pageY;
        }else if(e.clientX){
          mbl_mouse_xcoord = e.clientX + document.documentElement .scrollLeft;
          mbl_mouse_ycoord = e.clientY + document.documentElement .scrollTop;
        }
      }
      if(mbl_mouse_ycoord_prev < mbl_mouse_ycoord){
        mbl_mouse_going_up = false;
      }else{
        mbl_mouse_going_up = true;
      }
      mbl_mouse_ycoord_prev = mbl_mouse_ycoord;
      return true;
    }
    function mbl_lstats_getParentClickable(obj){
      for(var j=0; j<=5; j++){
        if(obj && obj.nodeName.toUpperCase() == 'A'){ return obj; } //look for <A> tag
        obj = obj.parentNode;
      }
      return null;
    }
    function mbl_ourlc(href){
      window.open('http://www.mybloglog.com/links/?url=' + href);
    }
    function mbl_recal_ypos(height, top){
      var cnt = mbl_link_heights.length;
      var repos = 0;
      var x = 1;
      var h = height;
      for(var i=0; i<cnt; i++){
        if(height <= mbl_link_heights[i]){ break; }
        if((height % mbl_link_heights[i]) == 0){
          x = height / mbl_link_heights[i];
          h = mbl_link_heights[i];        
          break;
        }
      }
      var line_pos = 0;
      for(var i=0; i<x; i++){
        if(mbl_mouse_ycoord > (top + (i * h) + 2)){
          line_pos = i;
        }
      }
      return h * line_pos;
    }
    function mbl_get_link_stats(atag){
      var href = trim(atag.href.toLowerCase(), '/');
      href = unescape(trim(href, ' '));
      href = href.replace(/'/gi, '');
      var mbl_num_clicks = mbl_links[href];
      if(!mbl_num_clicks){
        var reg = /\+/gi;
        var hrefx = href.replace(reg, ' ');
        mbl_num_clicks = mbl_links[hrefx];
      }
      return mbl_num_clicks;
    }
    function mbl_onmous(e){
      if(typeof(mbl_pop_div_node) == 'undefined' || mbl_pop_div_node == null){ return true; }
    
      var atag = null
      if(e && e.target){ atag = e.target; }
      else{ atag = window.event.srcElement; }
      atag = mbl_lstats_getParentClickable(atag);
      if(!atag || !atag.href){ return true; }
    
      if(atag == mbl_active_link_obj && mbl_pop_div_active){ return true; }  
    
      var href = trim(atag.href.toLowerCase(), '/');
      href = unescape(trim(href, ' '));

      var click_text;
      if(mbl_clicktagging_ord != 'n'){
        click_text = mbl_number_ordinalize(mbl_get_assoc_array_rank(mbl_links, href));
        if(click_text == '1st'){
          click_text = 'Most Popular Outgoing Link';
        }else{
          click_text = click_text + ' Most Popular Outgoing Link';
        }
      }else{
        var mbl_num_clicks = mbl_get_link_stats(atag);     
        if(mbl_num_clicks > 1){ var clickText = ' Clicks '; }
        else{ var clickText = ' Click '; }
        click_text = mbl_num_clicks + clickText + 'Today (updated hourly)';
      }

      mbl_pop_div_node.innerHTML = '<div onclick="mbl_ourlc(\''+escape(href)+'\');" style="width:180px;text-align:center;background-color:#eeeeee;font-size:11px;display:block;border:1px solid #336699;color:#336699;text-decoration:none;font-family:arial,sans-serif;margin:0px;padding:0px;cursor:hand;cursor:pointer;"><div style="border:1px solid #336699;font-weight:bold;background-color:#336699;color:#eeeeee;display:none;text-align:center;width:178px;">MyBlogLog ClickTagging</div><div style="margin:0px;padding:2px 0px;text-decoration:underline;text-align:center;width:178px;">' + click_text + '</div></div>';
      mbl_pop_div_node.style.display = 'block';
    
      var top = parseInt(mbl_getElemTop(atag));
      var height = parseInt(mbl_pop_div_node.offsetHeight);
      var width = parseInt(atag.offsetWidth);
    
      var repos = 0;
      repos = mbl_recal_ypos(parseInt(atag.offsetHeight), top);
    
      mbl_pop_div_node.style.left = mbl_mouse_xcoord + 'px';
      mbl_pop_div_node.style.top = top - height + repos + 3 + mbl_body_border_top + 'px';
    
      mbl_pop_div_active = true;
      if(atag && atag.href){ window.status = atag.href; }
      mbl_active_link_obj = atag;
    
      mbl_last_popup_bottomY = top + repos + 3 + mbl_body_border_top;
    
      return true;
    }
    function mbl_onmousout(e){
      mbl_pop_div_active = false; 
      mbl_popup_timeout = window.setTimeout('mbl_onmousout_sub()', 100);
      return true;
    }
    function mbl_onmousout_sub(){
      if(mbl_pop_div_node && !mbl_pop_div_active){
        mbl_pop_div_node.style.display = 'none';
        window.status = '';
      }
      return true;
    }
    function mbl_onmous2(e){
      mbl_pop_div_active = true;
      mbl_pop_div_node.firstChild.firstChild.style.display = 'block';
      mbl_pop_div_node.style.top = mbl_last_popup_bottomY - parseInt(mbl_pop_div_node.offsetHeight) + 'px';
    
      return true;
    }
    function mbl_sort_insert(val){
      if(val < 5){ return true; }
      var cnt = mbl_link_heights.length;
      var mbl_temp_idx = -1;
      if(cnt == 0){ mbl_link_heights[0] = val; return true; }
      
      for(var i=0; i<cnt; i++){
        if(mbl_link_heights[i] == val || (val % mbl_link_heights[i]) == 0){ return true; }
        if(val < mbl_link_heights[i]){
          mbl_temp_idx = i;
          break;
        }
      }
      if(mbl_temp_idx == -1){ mbl_link_heights[cnt] = val; return true; }
      for(var i=cnt; i>mbl_temp_idx; i--){
        mbl_link_heights[i] = mbl_link_heights[i-1];
      }
      mbl_link_heights[mbl_temp_idx] = val;
    }
    function mbl_processlinknodes(){
      try{
        if(typeof(mbl_links) == 'undefined'){ return true; }
        var eventFlag = 0;
        var body = document.getElementsByTagName('body')[0];
        if(!body){ return true; }
      
        var div = document.createElement('DIV');
        div.style.display = 'none';
        div.style.zIndex = '99';
      
        div.style.position = 'absolute';
        div.setAttribute('id', 'mbl_div_id_2s29et301');
        mbl_pop_div_node = div;
      
        if(body.addEventListener){
          eventFlag = 1;
          mbl_pop_div_node.addEventListener('mouseover', mbl_onmous2, false);
          mbl_pop_div_node.addEventListener('mouseout', mbl_onmousout, false);
        }else if(body.attachEvent){
          eventFlag = 2;
          mbl_pop_div_node.attachEvent('onmouseover', mbl_onmous2);
          mbl_pop_div_node.attachEvent('onmouseout', mbl_onmousout);
        }else{}
      
        body.appendChild(div);
        var numTest = parseInt(mbl_getObjectStyle(body, 'borderTopWidth', 'border-top-width'));
        if(!isNaN(numTest)){ mbl_body_border_top = numTest; }
    
        var nodes = document.getElementsByTagName('A');
        for(var i=0; i<nodes.length; i++){
          if(nodes[i].href && nodes[i].parentNode && mbl_get_link_stats(nodes[i])){
            if(eventFlag == 1){
              nodes[i].addEventListener('mouseover', mbl_onmous, false);
              nodes[i].addEventListener('mouseout', mbl_onmousout, false);
            }else if(eventFlag == 2){
              nodes[i].attachEvent('onmouseover', mbl_onmous);
              nodes[i].attachEvent('onmouseout', mbl_onmousout);
            }else{}
            mbl_sort_insert(parseInt(nodes[i].offsetHeight));      
          }
        }
      }catch(err){ return true; }
    
      return true;
    }
    if(window.addEventListener){
      window.addEventListener('load', mbl_processlinknodes, false);
      document.addEventListener('mousemove', mbl_onmousemove, false);
    }else if(window.attachEvent){
      window.attachEvent('onload', mbl_processlinknodes);
      document.attachEvent('onmousemove', mbl_onmousemove);
    }else{}
  }// -->