package layers
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
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
		
		public function route() :void 
		{
			this.plane.degree = this.plane.degree + 90;
			var angle_in_radians : Number = Math.PI * 2 * ( this.plane.degree / 360 );
			
			this.planeBitmap.transform.matrix.rotate( angle_in_radians );
			
			this.dispatchEvent( new Event( Event.CHANGE ) );
		}
	}
}