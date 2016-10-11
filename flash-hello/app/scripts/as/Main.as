
package {

    import flash.events.*;
    import flash.display.Sprite;
    import flash.text.TextFormat;
    import flash.text.TextField;
    import flash.text.TextFormatAlign;

    [SWF(width="640",height="480",backgroundColor="0x000000")]
    public class Main extends Sprite {

        public function Main() {

            if (this.stage) {
            	this.init();
            } else {
            	this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            }
            
        }

        private function onAddedToStage(): void {
        	this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        	init();
        }

        public function init(): void {

        	var myFormat:TextFormat = new TextFormat();
			myFormat.size = 15;
			myFormat.align = TextFormatAlign.LEFT;
          myFormat.color = 0xeeee00;

        	var myText:TextField = new TextField();
        	myText.defaultTextFormat = myFormat;
			myText.text = "Hello World";
			addChild(myText);

        }
    }
}
