
package {

    import flash.events.*;
    import flash.display.Sprite;
    import flash.text.*;
    import flash.ui.*;


    [SWF(width="640",height="480",backgroundColor="0x000000")]
    public class Main extends Sprite {

        var mouseData:TextField;
        var keyData:TextField;

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

            this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
            this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);

        	var myFormat:TextFormat = new TextFormat();
			myFormat.size = 15;
			myFormat.align = TextFormatAlign.CENTER;
            myFormat.color = 0xffff00;

        	this.mouseData = new TextField();
        	this.mouseData.defaultTextFormat = myFormat;
			this.mouseData.text = "";
            this.mouseData.width = 350;
            this.mouseData.x = 10;
            this.mouseData.y = 10;
			addChild(this.mouseData);

            this.keyData = new TextField();
            this.keyData.defaultTextFormat = myFormat;
            this.keyData.text = "";
            this.keyData.width = 250;
            this.keyData.border = true;
            this.keyData.borderColor = 0x000000;
            this.keyData.x = 10;
            this.keyData.y = 40;
            addChild(this.keyData);

        }

        public function onKeyDown(event:KeyboardEvent):void {
            this.keyData.text = "key pressed: " + String.fromCharCode(event.charCode) + " (chr code: " + event.charCode + ")";
            if (event.keyCode == Keyboard.SHIFT) {
                this.keyData.borderColor = 0xff0000; 
            } else {
                this.keyData.borderColor = 0x000000;
            }
        }

        public function onMouseMove(event:MouseEvent):void {

            this.mouseData.text = "mouse [localX:" + event.localX + ", localY:" + event.localY + ", stageX:" + event.stageX + ", stageY:" + event.stageY + "]";

        }

    }


}
