
package {

    import flash.events.*;
    import flash.display.Sprite;

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

            // before doing anything else, test our site for locking
            if(!this.sitelock(['erikyuzwa.com'])) {

                // this site is not in our allowed list
                // normally, we'd go one step further and change the alpha
                // value right at our root:
                // eg. this.root.alpha = 0;
                this.stage.color = 0xee0000;
            } else {
                this.stage.color = 0x0000ee;
            }

        }

        private function sitelock(domains:Array, isLocal:Boolean = true):Boolean {

            var isAuthorized:Boolean = false;

            // try to match JavaScript "nomenclature" of window.location
            var locationObj = {
                href: this.root.loaderInfo.url,
                protocol: this.root.loaderInfo.url.split("://")[0],
                pathname: this.root.loaderInfo.url.split("://")[1]
            }

            // append our domain once we have our pathname sorted out
            locationObj.domain = locationObj.pathname.split(":")[0];

            var temp:String = locationObj.pathname.split(":")[1];
            if (temp.split("/")[0].length > 1) {
                locationObj.port = Number(temp.split("/")[0]);
            }

            Bridge.infojs(locationObj);
            
            // some local mode
            if (locationObj.protocol == 'file' || locationObj.domain == 'localhost') {
                Bridge.logjs('local mode -- allowing = ' + isLocal);
                return isLocal;
            }

            for (var i:String in domains) {
                Bridge.logjs('testing domain = ' + domains[i]); 
                if (locationObj.domain == domains[i]) {
                    Bridge.logjs('match found : allowing - ' + locationObj.domain);
                    isAuthorized = true;
                    break;
                }

            }

            return isAuthorized;
        }


    }


}
