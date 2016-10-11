
package {

    import flash.events.*;
    import flash.external.ExternalInterface;

    public class Bridge {
  
        public function Bridge() {
        }

        public static function logjs(...args): void {
        	if (ExternalInterface.available) {
        		try {
        			ExternalInterface.call('console.log', args);
        		} catch (error) {
        			ExternalInterface.call('console.error', 'An exception was thrown by `ExternalInterface`' + error);
        		}
        	}
        }

        public static function infojs(...args): void {
        	if (ExternalInterface.available) {
        		try {
        			ExternalInterface.call('console.info', args);
        		} catch (error) {
        			ExternalInterface.call('console.error', 'An exception was thrown by `ExternalInterface`' + error);
        		}
        	}
        }

        public static function errorjs(...args): void {
        	if (ExternalInterface.available) {
        		try {
        			ExternalInterface.call('console.error', args);
        		} catch (error) {
        			ExternalInterface.call('console.error', 'An exception was thrown by `ExternalInterface`' + error);
        		}
        	}
        }
    }
}
