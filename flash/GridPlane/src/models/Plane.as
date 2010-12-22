package models
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Plane
	{
		public var bitmapData:BitmapData;
		
		public var width:int = 5;
		public var height:int = 4;
		
		public var x:int = 0;
		public var y:int = 0;
		
		private var _rotation:int = 0;	//顺时针旋转的角度
		public var values:Array = [ [-1,-1,9,-1,-1],
									[ 1, 1,1, 1, 1],
									[-1,-1,1,-1,-1],
									[-1, 1,1, 1,-1]];
		public var cellScale :int = 48;
		
		public function Plane( )
		{
		}
		
		//顺时针旋转
		public function calcValue():Array
		{
			var arr:Array = [];
			var i:int, j:int;
			
			switch( _rotation )
			{
				case 0:
					arr = values;
					break;
				case 90:
					for( j = 0; j< height; j++ ){
						arr[ j ] = [];
						for( i = 0; i< width; i++ ){
							arr[ j ][ i ] = values[ i ][ j ];
						}
					}
					
					//水平翻转
					for( j = 0; j< height; j++ ){
						arr[ j ] = arr[ j ].reverse();
					}
					
					break;
				case 180:
					arr = values.reverse();
					break;
				case 270:
					for( j = 0; j< height; j++ ){
						arr[ j ] = [];
						for( i = 0; i< width; i++ ){
							arr[ j ][ i ] = values[ i ][ j ];
						}
					}
					
					break;
			}
			return arr;
		}
		
		//只接收固定几个值
		public function set rotation( value:int ) : void
		{
			value %= 360;
			if ( value == 0 || value == 90 || value == 180 || value == 270 ){
				_rotation = value;
				//竖放时  重新计算宽高
				if ( value == 90 || value == 270 ){
					width = values.length;
					height = values[0].length;
				}
			}
		}
		
		public function get rotation() : int
		{
			return _rotation;
		}
		
		/**
		 * 每次均返回新的bitmap 
		 * 莫名有白底产生  
		 * @return Bitmap
		 * 
		 */		
		public function get bitmap() :Bitmap
		{
			var max:int = Math.max(this.bitmapData.width, this.bitmapData.height);

			//过滤白底
			var colorTransform:ColorTransform = new ColorTransform();
			//			colorTransform.color = 0x000000;
			colorTransform.alphaOffset = 255;
			
			//获取旋转后的图像
			var data:BitmapData = new BitmapData(max, max, true, 0x000000 );
			
			var matrix:Matrix = new Matrix();
			matrix.translate( -max / 2, -max / 2 );
			matrix.rotate( Math.PI * 2 * (this.rotation / 360) );
			matrix.translate( max / 2, max / 2 );
			
			data.draw( this.bitmapData, matrix, colorTransform );
			
			//裁剪需要的部份
			var w:int = this.bitmapData.width, h:int = this.bitmapData.height;
			var from:Point = new Point();
			
			//Rectangle 只相当于一个遮罩层 并没有移动的能力
			var rect:Rectangle;
			if ( this.rotation == 90 ){
				rect = new Rectangle( 0, 0, h, w );
				from.x = cellScale ;
			}else if ( this.rotation == 180 ){
				rect = new Rectangle( 0, 0, w, h );
				from.y = cellScale;
			}else if ( this.rotation == 270 ){
				rect = new Rectangle( 0, 0, h, w );	
			}else {
				rect = new Rectangle( 0, 0, w, h );	
			}							
			
			var dataClip:BitmapData = new BitmapData( rect.width, rect.height , true, 0x000000 ); 
			dataClip.draw( data, new Matrix(1,0,0,1, -from.x, -from.y), colorTransform, null, rect );
			
//			dataClip.colorTransform( dataClip.rect, colorTransform );
			
			var ret:Bitmap = new Bitmap( dataClip );	
			
			return ret;
		}
	}
}