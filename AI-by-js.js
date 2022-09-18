function magic(){
 var rCanvas = document.getElementsByClassName("runner-canvas")[0];
 var runnerCanvasContext = rCanvas.getContext('2d');
 var imgd = runnerCanvasContext.getImageData(rCanvas.width/8, 
rCanvas.height - rCanvas.height/2.5, rCanvas.width/7, rCanvas.height/5);
 var jumpFlag = false;
 var pix = imgd.data;
 for (var i = 0, n = pix.length; i < n; i += 4) {
  if(pix[i]>0||pix[i+1]>0||pix[i+2]>0){
   jumpFlag = true;
   break;
  }
 }
 if(jumpFlag){
  simulateJump();
  return setTimeout(function(){magic();},100);
 } else {
  setTimeout(function(){magic();},50);
 }
};

function simulateJump() {
 var keyEvent = document.createEvent('KeyboardEvent');
 Object.defineProperty(keyEvent, 'keyCode', {
  get : function() {
   return this.keyCodeVal;
  }
 });
 keyEvent.initKeyboardEvent
('keydown', true, false, null, 0, false, 0, false, 38, 0);
 keyEvent.keyCodeVal = 38;
 document.dispatchEvent(keyEvent);
}
magic();
