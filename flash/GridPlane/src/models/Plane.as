package models
{
	import flash.display.BitmapData;

	public class Plane
	{
		public var bitmapData:BitmapData;
		
		public var width:int = 5;
		public var height:int = 4;
		
		public var x:int = 0;
		public var y:int = 0;
		
		private var _degree:int = 0;	//顺时针旋转的角度
		public var values:Array = [ [-1,-1,9,-1,-1],
									[ 1, 1,1, 1, 1],
									[-1,-1,1,-1,-1],
									[-1, 1,1, 1,-1]];
		public function Plane()
		{
		}
		
		//顺时针旋转
		public function calcValue():Array
		{
			var arr:Array = [];
			var i:int, j:int;
			
			switch( _degree )
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
		public function set degree( value:int ) : void
		{
			value %= 360;
			if ( value == 0 || value == 90 || value == 180 || value == 270 ){
				_degree = value;
				//竖放时  重新计算宽高
				if ( value == 90 || value == 270 ){
					width = values.length;
					height = values[0].length;
				}
			}
		}
	}
}