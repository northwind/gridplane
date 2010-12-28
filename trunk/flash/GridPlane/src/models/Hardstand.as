package models
{
	import events.ResultEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import services.ServerService;
	
	[Event(name="", type="")]
	
	public class Hardstand extends EventDispatcher
	{
		private var _rows : int = 10; 
		private var _columns : int = 10; 
		private var _defaultValue :int = -1;
		
		[Bindable]
		public var cellWidth : int = 48;
		[Bindable]
		public var cellHeight : int = 48;		
		
		public var width : int = 480;
		public var height : int = 480;
		
		public var values:Array = [];	//每个坐标对应的值
		public var planes :Array = [];	//停放的飞机

		public var MAX_PLANES:int = 3;
		
		[Inject]
		public var ss:ServerService;
		
		public function Hardstand()
		{
		}
		
		private function generateValues():void
		{
			values= [];
			
			for( var i:int = 0; i< _rows; i++ ){
				var tmp:Array = [];
				for( var j:int = 0; j< _columns; j++ ){
					//默认值为0
					tmp.push( _defaultValue );
				}
				
				values.push( tmp );
			}
		}
		
		[Init]
		public function init():void
		{
			ss.addEventListener( ResultEvent.GetPlaneOK, onGetPlaneOK);
			
			generateValues();
		}
		
		public function setPlane( x:int, y:int, p:Plane ):void
		{
			//最多只能停放MAX_PLANES架飞机
			if ( planes.length < MAX_PLANES ){
				p.x = x;
				p.y = y;
				
				planes.push( p );
				
				setValue( x, y, p.calcValue() );
				
				this.dispatchEvent( new Event( Event.CHANGE ) );
			}
		}

		public function isValid( x:int, y:int, p:Plane ):Boolean
		{
			//最多只能停放MAX_PLANES架飞机
			if ( planes.length >= MAX_PLANES ){
				return false;
			}
			
			var arr:Array = p.calcValue();
			for( var i:int = 0; i< arr.length; i++ ){
				
				var tmp:Array = arr[i] as Array;
				for( var j:int = 0; j< tmp.length; j++ ){
					//两个都有值则证明有叠加
					if ( tmp[ j ] != -1 && values[ y + i ][ x + j ] != -1  )
						return false;
				}
			}	
			
			return true;
		}
		
		//设置战场的值
		private function setValue( x:int, y:int, v :Array ):void
		{
			for( var i:int = 0; i< v.length; i++ ){
				var tmp:Array = v[i] as Array;
				for( var j:int = 0; j< tmp.length; j++ ){
					//-1时 直接跳过 相当于透明
					if ( tmp[ j ] != -1 )
						this.values[ y + i ][ x + j ] = tmp[ j ];
				}
			}
		}
		
		public function canSave() : Boolean
		{
			return planes.length == MAX_PLANES;
		}

		public function hasPlane() : Boolean
		{
			return planes.length > 0 ;
		}
		
		public function save():void
		{
			ss.setPlane( values.toString() );
		}
		
		public function clear() : void
		{
			generateValues();
			planes = [];
			
			this.dispatchEvent( new Event( Event.CHANGE ) );
		}
		
		public function load():void
		{
			ss.getPlane();
		}
		
		//getPlane 正确返回
		private function onGetPlaneOK( event:ResultEvent ):void
		{
			
		}
		
		[Bindable]
		public function get rows() : int
		{
			return _rows;
		}
		
		//TODO values对应更改
		public function set rows( value:int ) : void
		{
			_rows = value;
			
			height = _rows * this.cellHeight;
		}
		
		[Bindable]
		public function get columns() : int
		{
			return _columns;
		}
		
		//TODO values对应更改
		public function set columns( value:int ) : void
		{
			_columns = value;
			
			width = _columns * this.cellWidth;
		}		
	}
}