
package {

    import flash.display.Sprite;
    import flash.events.*;
    import flash.ui.Keyboard;
    import flash.utils.Timer;


    [SWF(width="430",height="430",backgroundColor="0x000000")]
    public class Main extends Sprite {

        private const SPEED         :uint = 100;//lower = faster
        private const DIM           :int = 15; //keep this number uneven to have the snake starting in the middle
        private const INITIAL_SIZE  :int = 3; //keep this lower then DIM/2
        
        private var stopped         :Boolean;
        private var left            :Boolean;
        private var right           :Boolean;
        private var up              :Boolean;
        private var down            :Boolean;
        private var size            :Number;
        private var food            :Sprite;
        private var tmr             :Timer;
        private var curI            :Number;
        private var curJ            :Number;
        private var snake           :Array;
        private var grid            :Array;

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

            size = this.stage.stageWidth / DIM;
            curI = curJ = Math.floor(DIM * 0.5);

            initSnake();
            fillGrid();
            placeFood();
            
            this.tmr = new Timer(SPEED);
            this.tmr.addEventListener(TimerEvent.TIMER, move);
            this.tmr.start();
            
            this.stage.addEventListener(KeyboardEvent.KEY_DOWN, changeDir);

        }

        private function fillGrid():void {
            grid = Make2DArray();
            
            for (var i:uint = 0; i < DIM; i++) {
                for (var j:uint = 0; j < DIM; j++) {
                    var sp:Sprite = new Sprite();
                    sp.graphics.beginFill(0xF0F0F0);
                    sp.graphics.lineStyle(1,0xF5F5F5);
                    sp.graphics.drawRect(0, 0, size  - 1, size - 1);
                    sp.x = i * size;
                    sp.y = j * size;
                    addChild(sp);
                    grid[i][j] = sp;
                }
            }    
        }
        
        private function Make2DArray():Array {
            var a:Array = new Array(DIM);
            for(var i:uint = 0; i < a.length; i++) {
                a[i] = new Array(DIM);
            }    
            return a;
        }
        
        private function initSnake():void {
            var center:Number = Math.floor(DIM * 0.5) * size;
            
            snake = new Array(INITIAL_SIZE);
            
            for (var i:uint = 0; i < INITIAL_SIZE; i++) {
                var sp:Sprite = makeItem();
                sp.x = center;
                sp.y = center + i * size;
                addChild(sp);
                snake[i] = sp;
            }
            
            snake.reverse();
        }
        
        private function makeItem(c:uint = 0):Sprite {
            var s:Sprite = new Sprite();
            s.graphics.beginFill(c);
            s.graphics.lineStyle(2,0x333333);
            s.graphics.drawRect(0, 0, size, size);
            return s;
        }
        
        private function placeFood():void {
            var rndI:uint = Math.floor(Math.random() * DIM);
            var rndJ:uint = Math.floor(Math.random() * DIM);
            
            var rndX:Number = grid[rndI][rndJ].x;
            var rndY:Number = grid[rndI][rndJ].y;
            
            if (food != null) removeChild(food);
            
            food = makeItem(Math.random() * 0xFFFFFF);// random color
            food.x = rndX;
            food.y = rndY;
            
            addChild(food);
            
            //redo if the food is on the snake itself
            for (var i:uint = 0; i < snake.length; i++) {
                if (rndY == snake[i].y && rndX == snake[i].x) { 
                    placeFood();
                }
            } 
        }
        
        private function move(e:TimerEvent):void {
            if (left) {
                curI -= 1;
            } else if (right) {
                curI += 1;
            }

            if (up) {
                curJ -= 1;
            } else if (down) {
                curJ += 1;
            }
            
            if (left || right || up || down) {
                var s:Sprite = makeItem();
                
                if (curI > DIM - 1) curI = 0;
                if (curJ > DIM - 1) curJ = 0;
                
                if (curI < 0) curI = DIM - 1;
                if (curJ < 0) curJ = DIM - 1;
                
                s.x = grid[curI][curJ].x;
                s.y = grid[curI][curJ].y;
                
                this.addChild(s);
                snake.push(s);
                
                if (Math.floor(s.x) == Math.floor(food.x) && Math.floor(s.y) == Math.floor(food.y)) {
                    placeFood();
                } else {
                    removeChild(snake[0]);
                    snake.shift();
                }
            }
        }
        
        private function changeDir(e:KeyboardEvent):void {
            if (e.keyCode == Keyboard.LEFT) {
                if (!right) {
                    left = true;  
                    up = false; 
                    down = false; 
                    right = false;
                }
            }

            if (e.keyCode == Keyboard.UP) {
                if (!down) {
                    left = false; 
                    up = true;  
                    down = false; 
                    right = false;
                }
            }

            if (e.keyCode == Keyboard.RIGHT) {
                if (!left) {
                    left = false; 
                    up = false; 
                    down = false; 
                    right = true;
                }
            }

            if (e.keyCode == Keyboard.DOWN) {
                if (!up) {
                    left = false; 
                    up = false; 
                    down = true;  
                    right = false;
                }
            }
        }
    }
}
