document.domain = 'xakep.ru'


// Установка переменных
window.onerror = null;
 var bName = navigator.appName;
 var bVer = parseInt(navigator.appVersion);
 var NS4 = (bName == "Netscape" && bVer == 4);
// var NS4 = (bName == "Netscape" && bVer >= 4);
// var IE4 = (bName == "Microsoft Internet Explorer" && bVer >= 4);
 var IE4 = ((bName == "Microsoft Internet Explorer" && bVer >= 4) ||(bName == "Netscape" && bVer == 5));
 var NS3 = (bName == "Netscape" && bVer < 4);
 var IE3 = (bName == "Microsoft Internet Explorer" && bVer < 4);
 var menuActive = 0
 var menuOn = 0
 var onLayer
 var timeOn = null
 var loaded = 0
 var onLayerSize = 0

// Устанавливаем цвет меню
var menuColor = "#294F88"
var menuBorderColor = "#FFFFFF"

// Разные слои для разных броузеров
if (NS4 || IE4) {
 if (navigator.appName == "Netscape") {
  layerStyleRef="layer.";
  layerRef="document.layers";
  styleSwitch="";
  }else{
  layerStyleRef="layer.style.";
  layerRef="document.all";
  styleSwitch=".style";
 }
}

// Показываем слои
function showLayer(layerName){
if (NS4 || IE4) {
 if (timeOn != null) {
  clearTimeout(timeOn)
  hideLayer(onLayer)
 }
 if (NS4 || IE4) {
	 if (document.layers) {
		eval(layerRef+'["'+layerName+'"]'+styleSwitch+'.visibility="visible"');
		eval(layerRef+'["'+layerName+'"]'+styleSwitch+'.display="list-item"');
	 } else {
 		//for FF & NN
		document.getElementById(layerName).style.visibility = "visible";
		document.getElementById(layerName).style.display = "list-item";
	 }
 }
 onLayer = layerName;
 }
}

// Прячем слои
function hideLayer(layerName){
 if (menuActive == 0) {
  if (NS4 || IE4) {
	 if (document.layers) {
		eval(layerRef+'["'+layerName+'"]'+styleSwitch+'.visibility="hidden"');
		eval(layerRef+'["'+layerName+'"]'+styleSwitch+'.display="none"');
	 } else {
		//for FF & NN
		document.getElementById(layerName).style.visibility = "hidden";
		document.getElementById(layerName).style.display = "none";
	 }
  }
 }
}

// Счетчик для пряталки слоев
function btnTimer(opt) {
 timeOn = setTimeout("btnOut()",250)
}

// Если время вышло
function btnOut(layerName) {
 if (menuActive == 0) {
  hideLayer(onLayer)
  }
}

// Бедная мышка:)
// Мышка на слое
function menuOver(itemName) {
 clearTimeout(timeOn)
 menuActive = 1
}

// мышка вне слоя
function menuOut(itemName) {
 menuActive = 0
 timeOn = setTimeout("hideLayer(onLayer)", 400)
}


// Создаем меню
function menuLink(title, url) {
 this.title = title
 this.url = url
}

// Создание меню
function menuMaker(menuArray, LayerSize) {
 onLayerSize = LayerSize;
 n = ""
 j = eval(menuArray + ".length") - 1;
 topTable = "<div ID='" + eval(menuArray + ".id") + "' style='list-style: none;'><table border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' width='131' bgcolor='" + menuColor +"' bordercolor='" + menuBorderColor +"'>"
 topTable += "<tr><td width='100%' onmouseover=\"showLayer('" + eval(menuArray + ".id") + "',"+onLayerSize+");\" onmouseout=\"btnTimer();\" class='menu' style='padding-top: 10px; padding-right: 10px; padding-bottom: 10px; padding-left: 10px'>"
 btmTable = "</td></tr></table></div>"

 n += topTable
 for( var i = 1; i <=j; i++) {
   n += "<a href='" + eval(menuArray + "[" + i + "].url") + "' target='_top'>/" + eval(menuArray + "[" + i + "].title") + "/</a><br>"
 }
 n += btmTable
 return n
}


function adjustFrame (frame) {
  if (document.all) {
    var w = frame.document.body.scrollWidth;
    var h = frame.document.body.scrollHeight;
    document.all[frame.name].width = w;
    document.all[frame.name].height = h;
  }
  else if (document.getElementById) {
    var w = frame.document.width;
    var h = frame.document.height;
    document.getElementById(frame.name).width = w;
    document.getElementById(frame.name).height = h;
  }
}

// Функция отключения кнопки "Отправить" после её нажатия.
// Сделано для уничтожения возможности двойного нажатия на кнопку.
// Автор: Шарук Константин (stratege@gameland.ru)
function WhichClicked(ww) {
  window.document.postmodify.waction.value = ww;
}
function submitonce(theform) {
  // если IE 4+ или NS 6+
  if (document.all || document.getElementById) {
    // зажимам кнопки "submit" и "reset"
    for (i=0;i<theform.length;i++) {
      var tempobj=theform.elements[i];
      if(tempobj.type.toLowerCase()=="submit"||tempobj.type.toLowerCase()=="reset") {
        // выключаем их
        tempobj.disabled=true;
      }
    }
  }
}
// Функция вставляющаяя меню
// Автор: Шарук Константин (stratege@gameland.ru)
function CallThisMenu() {
                document.write(menuMaker("maMenu",31))
                document.write(menuMaker("coMenu",31))
                document.write(menuMaker("haMenu",31))
                document.write(menuMaker("soMenu",31))
                document.write(menuMaker("mpMenu",31))
                document.write(menuMaker("xsMenu",31))
}