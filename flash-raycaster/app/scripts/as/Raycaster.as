package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.Bitmap;
	
	public class Raycaster extends BitmapData
	{
		private var map: BitmapData;
		
		//-- WORLD COORDINATES --//
		public var x: Number;
		public var y: Number;
		public var z: Number;
		public var angle: Number;
		public var roll: Number;
		
		private var iceil: BitmapData;
		private var ifloor: BitmapData;
		private var iwall: BitmapData;

		//-- PRE COMPUTE --//
		public var fov: Number;
		private var eyeDistance: Number;
		private var subRayAngle: Number;
		private var p_center: Number;
		
		private var sin: Array;
		private var cos: Array;
		private var tan: Array;
		
		[Embed(source='assets/super_erika.png')] public var TBmp:Class;
		
		public function Raycaster( width: int, height: int )
		{
			super( width, height, false, 0 );
			
			var tbmp: Bitmap = new TBmp();
			var textures: BitmapData = new BitmapData( 192, 64, false, 0 );
			textures.draw( tbmp );
			
			ifloor = new BitmapData( 64, 64, false, 0xffcc00 );
			iceil  = new BitmapData( 64, 64, false, 0xff0000 );
			iwall  = new BitmapData( 64, 64, false, 0xcccccc );
			
			ifloor.copyPixels( textures, new Rectangle( 0, 0, 64, 64 ), new Point( 0, 0 ) );
			iceil.copyPixels( textures, new Rectangle( 64, 0, 64, 64 ), new Point( 0, 0 ) );
			iwall.copyPixels( textures, new Rectangle( 128, 0, 64, 64 ), new Point( 0, 0 ) );

			x = 64 * 64 + 32;
			y = 64 * 64 + 32;
			z = 32;
			
			map = new BitmapData( 128, 128, false, 0 );
			
			for( var iy: int = 0 ; iy < 128 ; iy++ )
			{
				for( var ix: int = 0 ; ix < 128 ; ix++ )
				{
					map.setPixel( ix, iy, Math.random() < .1 ? 1 : 0 );
				}
			}
			
			angle = 0;
			roll = 0;
	
			fov = 60 * Math.PI / 180;
			
			//-- fill lookup table
			sin = new Array();
			cos = new Array();
			tan = new Array();
			
			for( var i: int = 0 ; i < 7200 ; i++ )
			{
				sin[i] = Math.sin( i / 3600 * Math.PI );
				cos[i] = Math.cos( i / 3600 * Math.PI );
				tan[i] = Math.tan( i / 3600 * Math.PI );
			}
	
			init();
		}
	
		public function init(): void
		{
			eyeDistance = ( width / 2 ) / Math.tan( fov / 2 );
			subRayAngle = fov / width;
		}
	
		public function render(): void
		{
			//-- LOCAL VARIABLES --//
			var rx: int = x >> 6;
			var ry: int = y >> 6;
			
			var tx: int = rx;
			var ty: int = ry;
	
			var ax: Number;
			var ay: Number;
			var dx: Number;
			var dy: Number;
			var distance: Number;
	
			var offset: Number = 0;
			var nearest: Number;
			var beta: Number;
			var ht: Number;
			var tn: Number;
			var cs: Number;
			var sn: Number;
			
			var distort: Number;
			var cf: Number;
			var ff: Number;
			var c0: int;
			var c1: int;
			var dg: int;
			
			var color: int;
			
			//-- clamp angle for lookup tables
			if( angle < 0 ) angle += Math.PI * 2;
			if( angle > Math.PI * 2 ) angle -= Math.PI * 2;
	
			var a: Number = angle + fov * .5;
			if( a > Math.PI * 2 ) a -= Math.PI * 2;
			
			var sx: int = width - 1;
			var sy: int;
	
			//-- PRECOMPUTE --//
			p_center = height / 2 - roll;
			var oz: Number = 64 - z;
			
			var ang: int = ( angle * ( 3600 / Math.PI ) ) | 0;

			while( --sx > -1 )
			{
				nearest = Number.POSITIVE_INFINITY;
				
				dg = ( a * ( 3600 / Math.PI ) ) >> 0;
				
				tn = tan[ dg ];
				sn = sin[ dg ];
				cs = cos[ dg ];

				rx = tx;
				ry = ty;
				
				if ( sn < 0 )
				{
					while( ry > -1 && rx > -1 && rx < 128 )
					{
						ay = ry << 6;
						ax = x + ( ay - y ) / tn;
						rx = ax >> 6;
						
						ry--;
						
						if ( map.getPixel( rx, ry ) )
						{
							dx = ax - x;
							dy = ay - y;
							
							nearest = dx * dx + dy * dy;
							offset = ax & 63;
							break;
						}
					}
				}
				else
				{
					while( ry < 128 && rx > -1 && rx < 128 )
					{
						++ry;
						
						ay = ry << 6;
						ax = x + ( ay - y ) / tn;
						rx = ax >> 6;
						
						if ( map.getPixel( rx, ry ) )
						{
							dx = ax - x;
							dy = ay - y;
							
							nearest = dx * dx + dy * dy;
							offset = 64 - ax & 63;
							break;
						}
					}
				}
				rx = tx;
				ry = ty;
				if ( cs < 0 )
				{
					while( rx > -1 && ry > -1 && ry < 128 )
					{
						ax = rx << 6;
						ay = y + ( ax - x ) * tn;
						ry = ay >> 6;
						
						rx--;
						
						if ( map.getPixel( rx, ry ) )
						{
							dx = ax - x;
							dy = ay - y;
							
							distance = dx * dx + dy * dy;
							
							if ( distance < nearest )
							{
								nearest = distance;
								offset = 64 - ay & 63;
							}
							break;
						}
					}
				}
				else
				{
					while( rx < 128 && ry > -1 && ry < 128 )
					{
						++rx;
						ax = rx << 6;
						ay = y + ( ax - x ) * tn;
						ry = ay >> 6;
						
						if ( map.getPixel( rx, ry ) )
						{
							dx = ax - x;
							dy = ay - y;
							
							distance = dx * dx + dy * dy;
							
							if ( distance < nearest )
							{
								nearest = distance;
								offset = ay & 63;
							}
							break;
						}
					}
				}
				
				if( dg < ang )
				{
					distort = eyeDistance / cos[ 7200 + dg - ang ];
				}
				else
				{
					distort = eyeDistance / cos[ dg - ang ];
					
				}
				
				ht = distort / Math.sqrt( nearest );
				
				cf = oz * distort;
				ff =  z * distort;

				c0 = int( p_center - ht * oz );
				c1 = int( p_center + ht * z + .5 );
				
				sy = height;
				
				while( --sy > c1 )
				{
					if( sy < 0 ) break;
					
					//-- FLOOR TILES --//
					distance = ff / ( sy - p_center );
					
					color = ifloor.getPixel( ( x + cs * distance ) & 63, ( y + sn * distance ) & 63 );
					
					setPixel( sx, sy, color );
				}

				while( --sy > c0 )
				{
					if( sy < 0 ) break;
					
					//-- BLOCKS --//
					color = iwall.getPixel( offset, ( sy - c0 ) / ht );
					
					setPixel( sx, sy, color );
				}
				
				while( --sy > -1 )
				{
					if( sy < 0 ) break;
					
					//-- CEILING --//
					distance = cf / ( p_center - sy );
					
					color = iceil.getPixel( ( x + cs * distance ) & 63, ( y + sn * distance ) & 63 );
					
					setPixel( sx, sy, color );
				}
				
				a -= subRayAngle;
				
				if( a < 0 ) a += Math.PI * 2;
			}
		}
	}
}























