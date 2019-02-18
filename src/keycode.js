
        var rightpos = 10;
        var toppos = 10
        var currHeight = 0;
         var movement = 50;
    function moveTarget(){
        currHeight += movement;
        
    if (currHeight >= window.innerHeight - 50) {
         movement = -50;
        }
      else if (currHeight <= 0 ){
        movement = 50;
      }
     document.getElementById("target").style.top = currHeight + 'px';
    }
function showKey(e){
  
    if (e.keyCode == 39){
        rightpos += 15
        document.getElementById("keys").style.left = rightpos + 'px';
     }
     
    if (e.keyCode == 40){
        toppos += 15
        document.getElementById("keys").style.top= toppos + 'px';
     }
    
      if (e.keyCode == 37){
        rightpos -= 15
        document.getElementById("keys").style.left= rightpos + 'px';
     }
   
}
  document.addEventListener("click",function (event){
 
           var xcoord = event.clientX;
           var ycoord = event.clientY;
           currtop = 10;
           currleft = 10;
           difftop = ycoord - currtop;
           diffleft = xcoord - currleft;
           currmovetop = difftop/100;
           currmoveleft = diffleft/100;
          //  document.getElementById("keys").style.top = ycoord;
          var myVar =  setInterval(moveDot,10);
          function moveDot() {
            //move to here`
            console.log(currtop + ',' + currleft);
          document.getElementById("keys").style.left = currleft + 'px';
          document.getElementById("keys").style.top = currtop + 'px';

            currtop += currmovetop;
            currleft += currmoveleft
          
       
           if (currleft >  xcoord){
            clearInterval(myVar);
           }

  
         }

 
