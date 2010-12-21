package layers
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import models.Plane;
	
	import mx.core.UIComponent;

	public class PlaneLayer extends UIComponent
	{
		public var flying:Boolean = false;
		public var planeBitmap:Bitmap;
		public var plane:Plane;
		
		public function PlaneLayer()
		{
			super();
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			this.focusEnabled = false;
		}
		
		[Init]
		public function init():void
		{

		}
		
		private function addListeners():void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true, 100, false);
//			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown );
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown );			
		}

		private function removeListeners():void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//			this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown );
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown );			
		}
		
		private function onMouseMove( event:MouseEvent ):void
		{
			if ( this.planeBitmap )
				setPos();
		}

		private function onMouseDown( event:MouseEvent ):void
		{
			removePlane();
		}
		
		private function onKeyDown( event:KeyboardEvent ):void
		{
			//ESC
			if ( event.keyCode == 27 ){
				removePlane();
			}else 
			//R
			if ( event.keyCode == 82 && this.flying ){
				//顺时针旋转90度
				this.rotate();
			}			
		}
		
		private function setPos():void
		{
			this.x = this.stage.mouseX - this.planeBitmap.width / 2;
			this.y = this.stage.mouseY - this.planeBitmap.height / 2;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,
											 unscaledHeight:Number):void
		{
			trace("updateDisplayList");
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			if ( this.planeBitmap ){
				this.addChild( this.planeBitmap );
			}
		}
		
		public function removePlane() : void
		{
			trace("removePlane");
			if ( this.planeBitmap ){
				this.removeChild( this.planeBitmap );
				this.planeBitmap.bitmapData.dispose();
				this.planeBitmap = null;
				this.plane = null;
			} 		
			this.flying = false;
			this.invalidateDisplayList();
			removeListeners();
			
			this.dispatchEvent( new Event( Event.CANCEL ) );
		}
		
		public function setPlane( plane:Plane ) : void
		{
			trace("setPlane");
			if ( this.planeBitmap ){
				this.removeChild( this.planeBitmap );
			} 
			
			this.flying = true;
			this.plane = plane;
			this.planeBitmap = new Bitmap( plane.bitmapData.clone() );
			
			this.invalidateDisplayList();
			
			setPos();
			addListeners();
		}
		
		public function rotate() :void 
		{
			trace("route");
			this.plane.degree = this.plane.degree + 90;
			var angle_in_radians : Number = Math.PI * 2 * ( this.plane.degree / 360 );
			
			var matrix:Matrix = new Matrix();
//			var matrix:Matrix = this.planeBitmap.transform.matrix;
			//原地旋转
			matrix.translate( - this.planeBitmap.width / 2 ,  - this.planeBitmap.height / 2 );
			matrix.rotate( angle_in_radians );
			//再更改坐标系
			matrix.translate( this.planeBitmap.width / 2 ,  this.planeBitmap.height / 2 );	
		
//			this.planeBitmap.rotation = this.plane.degree;
			this.planeBitmap.transform.matrix = matrix;
			
			this.dispatchEvent( new Event( Event.CHANGE ) );
		}
		
		public function getPlaneBitmapData():BitmapData
		{
//			var data:BitmapData = new BitmapData( this.planeBitmap.width, this.planeBitmap.height, true, 0x000000 );
			var max:int = Math.max( this.planeBitmap.width, this.planeBitmap.height );
			var data:BitmapData = new BitmapData( max, max, true );
			
			var matrix:Matrix = new Matrix();
			matrix.translate( -max / 2 ,  -max / 2 );
			matrix.rotate( Math.PI * 2 * ( this.plane.degree / 360 ) );
			matrix.translate( max / 2 ,  max / 2 );
			if ( this.plane.degree == 90 )
				matrix.translate( -48,  0 );
				
			data.draw( this.planeBitmap.bitmapData, matrix );
//			data.draw( this.plane.bitmapData );
//			return this.planeBitmap.bitmapData.clone();
//			new Bitmap( plane.bitmapData.clone() );
			
			var ret:BitmapData = new BitmapData( this.planeBitmap.width, this.planeBitmap.height );
			ret.draw( data );
			
			return data;
		}
	}
}