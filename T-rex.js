/*
الكود
Runner.prototype.gameOver = function (){}

بهذا الكود تتحكم في قفزة الديناصور
Runner.instance_.tRex.setJumpVelocity(100)

بهذا الكود تتحكم في سرعة الديناصور
Runner.instance_.setSpeed(1000)

*/
function followMeForMore(){
 var rCanvas = document.getElementsByClassName("runner-canvas")[0];
 var runnerCanvasContext = rCanvas.getContext('2d');
 var objXYZ = runnerCanvasContext.getImageData(rCanvas.width/8.002, 
rCanvas.height - rCanvas.height/2.51, rCanvas.width/7, rCanvas.height/5.01);
 var jumpFlag = false;
 var MovingInstance = objXYZ.data;
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
