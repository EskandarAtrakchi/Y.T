
function followMeForMore(){
 var xCanvas = document.getElementsByClassName("runner-canvas")[0];
 var runnexCanvasContext = xCanvas.getContext('2d');
 var objXY = runnexCanvasContext.getImageData(xCanvas.width/8.002, 
    xCanvas.height - xCanvas.height/2.51, xCanvas.width/7, xCanvas.height/5.01);
 var jumpFlag = false;
 var MovingInstance = objXY.data;
 for (var i = 0, n = MovingInstance.length; i < n; i += 4) {
  if(MovingInstance[i]>0||MovingInstance[i+1]>0||MovingInstance[i+2]>0){
   jumpFlag = true;
   break;
  }
 }
 if(jumpFlag){
  simulateJump();
  return setTimeout(function(){followMeForMore();},100);
 } else {
  setTimeout(function(){followMeForMore();},51);
 }
};

function simulateJump() {
 var Initi = document.createEvent('KeyboardEvent');
 Object.defineProperty(Initi, 'keyCode', {
  get : function() {
   return this.keyCodeVal;
  }
 });
 Initi.initKeyboardEvent
('keydown', true, false, null, 0, false, 0, false, 38, 0);
 Initi.keyCodeVal = 38;
 document.dispatchEvent(Initi);
}
followMeForMore();
