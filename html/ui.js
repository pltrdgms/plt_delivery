var Now = 200
var Times = {}
$(document).ready(function() {

    window.addEventListener('message', function(event) {
      if (event.data.show === false){
        $("body").css("display",  "none" );
        $("#general").css("display", "none");

      } 
      else {
        $("body").css("display",  "block" );
        $("#general").css("display", "block");
        Now = event.data.time
        const myNode = document.getElementById("tablo");
        while (myNode.firstChild) {myNode.removeChild(myNode.lastChild); }  
        let table = document.querySelector("table");
/* 
        let thead = table.createTHead();
        let ros = thead.insertRow();

        let th = document.createElement("th");
        let text = document.createTextNode("id");
        th.appendChild(text);
        ros.appendChild(th);

        let th2 = document.createElement("th");
        let text2 = document.createTextNode("deneme2");
        th2.appendChild(text2);
        ros.appendChild(th2);

        let th4 = document.createElement("th");
        let text4 = document.createTextNode("deneme3");
        th4.appendChild(text4);
        ros.appendChild(th4);

        let th5 = document.createElement("th");
        let text5 = document.createTextNode("deneme4");
        th5.appendChild(text5);
        ros.appendChild(th5);

        let th6 = document.createElement("th");
        let text6 = document.createTextNode("deneme5");
        th6.appendChild(text6);
        ros.appendChild(th6);

        let th7 = document.createElement("th");
        let text7 = document.createTextNode("deneme6");
        th7.appendChild(text7);
        ros.appendChild(th7);

        let th8 = document.createElement("th");
        let text8 = document.createTextNode("deneme7");
        th8.appendChild(text8);
        ros.appendChild(th8);

        let th9 = document.createElement("th");
        let text9 = document.createTextNode("deneme8");
        th9.appendChild(text9);
        ros.appendChild(th9);

        let th99 = document.createElement("th");
        let text99 = document.createTextNode("deneme9");
        th99.appendChild(text99);
        ros.appendChild(th99); 

 */

        let row = table.insertRow();

        let orderCell = row.insertCell();
        let orderText = document.createTextNode("NO.");
        orderCell.appendChild(orderText);

        let streetCell = row.insertCell();
        let streetText = document.createTextNode("STREET/ADDRESS");
        streetCell.appendChild(streetText);

        let meterCell = row.insertCell();
        let metertText = document.createTextNode("DISTANCE");
        meterCell.appendChild(metertText);

        let amountCell = row.insertCell();
        let amountText = document.createTextNode("QTY");
        amountCell.appendChild(amountText);

        let itemCell = row.insertCell();
        let itemText = document.createTextNode("PRODUCT");
        itemCell.appendChild(itemText);

        let priceCell = row.insertCell();
        let priceText = document.createTextNode("PAYMENT");
        priceCell.appendChild(priceText);

        let timeCell = row.insertCell();
        let timeText = document.createTextNode("TIME LEFT");
        timeCell.appendChild(timeText);


          for (let element of event.data.orders) {         
            if (element.source == null || element.source  == event.data.plysrc ) {
              let row = table.insertRow();

              let orderCell = row.insertCell();
              let orderText = document.createTextNode("#"+element.orderId);
              orderCell.appendChild(orderText);

              let streetCell = row.insertCell();
              let streetText = document.createTextNode(element.adres);
              streetCell.appendChild(streetText);

              let meterCell = row.insertCell();
              let metertText = document.createTextNode(element.distance);
              meterCell.appendChild(metertText);

              let amountCell = row.insertCell();
              let amountText = document.createTextNode(element.amount+"x");
              amountCell.appendChild(amountText);

              let itemCell = row.insertCell();
              let itemText = document.createTextNode(element.label);
              itemCell.appendChild(itemText);

              let priceCell = row.insertCell();
              let priceText = document.createTextNode(element.totalPrice);
              priceCell.appendChild(priceText);

              let timeCell = row.insertCell();
              let timeText = document.createTextNode(secondsToDhms(element.cancelTime-Now));
              timeCell.appendChild(timeText);
              Times[element.orderId]= {satir :timeCell, time : element.cancelTime};
            
              let locationCell = row.insertCell();
              locationCell.innerHTML = '<button class="button-loc"   role="button" onClick=\'DoAction(' + element.orderId + ',"showLocation")\' >Show Location</button>';

              if (element.source == null) {
                let takeCell = row.insertCell();
                takeCell.innerHTML = '<button class="button-take"   role="button" onClick=\'DoAction(' + element.orderId + ',"takeOrder")\' >Take Order</button>';
              } else {
                let cancelCell = row.insertCell();
                cancelCell.innerHTML = '<button class="button-cancel"  role="button" onClick=\'DoAction(' + element.orderId + ',"cancelOrder")\' >Cancel Order</button>';
              }

            }
          }
        }
      }
    )
    $('#switch').click(function (event) {
        $.post('https://plt_delivery/action', JSON.stringify({
          event :"orderNotify",
          value : this.checked
      }));
    });

  


    $("#close-button").click(function()         {
      $.post('https://plt_delivery/action', JSON.stringify({
            event : "close"
        }));
    });

    $(document).on('keydown', function() {
      switch(event.keyCode) {
          case 8: // D
          $.post('https://plt_delivery/action', JSON.stringify({
            event : "close"
        }));
              break;
          case 27: // A
          $.post('https://plt_delivery/action', JSON.stringify({
           event : "close"
        }));
              break;
      }
  });

  // Update the count down every 1 second
    var x = setInterval(function() {
      Now = Now + 1
      for (key in Times){
        Times[key].satir.innerHTML = secondsToDhms(Times[key].time-Now);
      }
    }, 1000);

})


function DoAction(id,action) {
  $.post('https://plt_delivery/action', JSON.stringify({
    event :action,
    orderId : id,
  }));}


function secondsToDhms(seconds) {
  seconds = Number(seconds);
  var d = Math.floor(seconds / (3600*24));
  var h = Math.floor(seconds % (3600*24) / 3600);
  var m = Math.floor(seconds % 3600 / 60);
  var s = Math.floor(seconds % 60);
  var dDisplay = d > 0 ? d + (d == 1 ? " day" : " days") : "";
  var hDisplay = h > 0 ? h + (h == 1 ? " hour" : " hours") : "";
  var mDisplay = m + ":";
  if (m < 10) {
    mDisplay = "0" + mDisplay;
  }

  var sDisplay = s ;

  if (sDisplay < 10) {
    sDisplay = "0"+sDisplay;
  }

  if (d > 0) {
    return dDisplay ;
  } else if (h > 0) {
    return hDisplay ;
  }else if (s < 0) {
    return "00:00" ;
  } else {
    return  mDisplay + sDisplay;
  }
  }

