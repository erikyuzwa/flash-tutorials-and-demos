
package {

    import flash.events.*;
    import flash.display3D.*;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageQuality;
    import flash.display.StageScaleMode;
    import flash.geom.Rectangle;
    import flash.utils.getTimer;
    import flash.utils.Timer;
    import flash.text.TextFormat;
    import flash.text.TextField;
    import flash.text.TextFormatAlign;

    [SWF(width="640",height="480",frameRate="60")]
    public class Main extends Sprite {

        public var context3D : Context3D;

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

            this.stage.quality = StageQuality.LOW;
            this.stage.align = StageAlign.TOP_LEFT;
            this.stage.scaleMode = StageScaleMode.NO_SCALE;

            this.stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreate);
            this.stage.stage3Ds[0].addEventListener(ErrorEvent.ERROR, errorHandler);
            this.stage.stage3Ds[0].requestContext3D(Context3DRenderMode.AUTO);

        }

        // this is called when the hardware has been identified and 
        // acknowledged by the Flash player
        private function onContext3DCreate(e:Event):void {
            this.context3D = this.stage.stage3Ds[0].context3D;
            this.context3D.configureBackBuffer(this.stage.stageWidth, this.stage.stageHeight, 4, true);
            
            // handle any gpu entity initialization
            this.initEngine();
        }
        
        // this can be called when using an old version of Flash
        // or if the html does not include wmode=direct
        private function errorHandler(e:ErrorEvent):void {
          // TODO add error reporting here
        }

        private function initEngine():void {
            
            // start the render loop
            this.stage.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);

            var myFormat:TextFormat = new TextFormat();
            myFormat.size = 15;
            myFormat.align = TextFormatAlign.LEFT;
            myFormat.color = 0xeeee00;

            var myText:TextField = new TextField();
            myText.defaultTextFormat = myFormat;
            myText.text = "Hello Stage3D World";
            this.addChild(myText);

            // kick off our rendering loop with a timer that fires in 20 ms
            var timer: Timer = new Timer( 20 );
            timer.addEventListener( TimerEvent.TIMER, this.onEnterFrame );
            timer.start();
        }

        // this function draws the scene every frame
        private function onEnterFrame(e:Event):void {

            try {
                // clear the backbuffer of the previous frame
                this.context3D.clear(0, 0, 1, 1);
                
                // swap our backbuffer to the front
                this.context3D.present();

            } catch (e:Error) {
                // this can happen if the computer goes to sleep and
                // then re-awakens, requiring reinitialization of stage3D
                // (the onContext3DCreate will fire again)
            }
        }
    }
}
