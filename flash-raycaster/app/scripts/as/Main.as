
package {

    import flash.events.*;
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.utils.getTimer;
    import flash.display.StageScaleMode;
    import flash.display.StageQuality;
    import flash.utils.Timer;

    [SWF(width="640",height="480",backgroundColor="0x000000")]
    public class Main extends Sprite {

        private const w: int = 640;
        private const h: int = 480;
        
        private const bounds: Rectangle = new Rectangle( 0, 0, w, h );;
        private const origin: Point = new Point();
        
        private var engine: Raycaster;
        private var buffer: BitmapData;
        
        private var bmp: Bitmap;
        
        private var mouseDown: Boolean;

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

            this.stage.scaleMode = StageScaleMode.NO_SCALE;
            this.stage.quality = StageQuality.LOW;

        
            this.engine = new Raycaster( w, h );
            this.buffer = new BitmapData( w, h );
            
            this.bmp = new Bitmap( buffer );
            
            this.bmp.x = ( this.stage.stageWidth - this.bmp.width ) / 2;
            this.bmp.y = ( this.stage.stageHeight - this.bmp.height ) / 2;
            
            this.addChild( this.bmp );
            
            this.engine.render();
            
            this.stage.addEventListener( MouseEvent.MOUSE_DOWN, this.onMouseDown );
            this.stage.addEventListener( MouseEvent.MOUSE_UP, this.onMouseUp );
            this.stage.addEventListener( Event.ENTER_FRAME, this.onEnterFrame );

            var timer: Timer = new Timer( 20 );
            timer.addEventListener( TimerEvent.TIMER, this.onEnterFrame );
            timer.start();

        }

        private function onMouseDown( event: Event ): void
        {
            this.mouseDown = true;
        }
        
        private function onMouseUp( event: Event ): void
        {
            this.mouseDown = false;
        }
        
        private function onEnterFrame( event: Event ): void
        {
            engine.angle += ( mouseX - stage.stageWidth / 2 ) / 4000;
            
            //engine.roll += ( mouseY - stage.stageHeight / 2 ) / 32;
            //engine.roll = engine.roll > 80 ? 80 : engine.roll < -80 ? -80 : engine.roll;
            
            if( mouseDown )
            {
                engine.x += Math.cos( engine.angle ) * 6;
                engine.y += Math.sin( engine.angle ) * 6;
                
                engine.z -= engine.roll / 50;
                engine.z = engine.z > 60 ? 60 : engine.z < 4 ? 4 : engine.z;
            }
            
            engine.z += ( 32 - engine.z ) / 128;

            engine.render();
            
            buffer.copyPixels( engine, bounds, origin );
        }
    }
}

