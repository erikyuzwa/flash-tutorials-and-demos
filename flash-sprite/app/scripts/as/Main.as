
package {

    import flash.events.*;
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.display.BitmapData;

    [SWF(width="640",height="480",backgroundColor="0x000000")]
    public class Main extends Sprite {

        [Embed(source="assets/wall.png")]
        private var WallTileClass : Class;

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

        	var wallTile:Bitmap = new WallTileClass() as Bitmap;
            wallTile.x = 100;
            wallTile.y = 100;

            this.addChild(wallTile);

        }
    }
}
