
package {

    import flash.events.*;
    import flash.display.Sprite;
    import flash.media.Sound;
    import flash.media.SoundChannel;

    [SWF(width="640",height="480",backgroundColor="0x000000")]
    public class Main extends Sprite {

        [Embed(source="assets/u7-fellowship-theme.mp3")]
        private var AudioClass : Class;

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

            var themeSound:Sound = new AudioClass() as Sound; 
            themeSound.play(); 
        	

        }

        

    }


}
