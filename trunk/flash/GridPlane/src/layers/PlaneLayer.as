package layers
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;

	public class PlaneLayer extends UIComponent
	{
		public var flying:Boolean = false;
		public var plane:Bitmap;
		
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
			if ( this.plane )
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
			this.x = this.stage.mouseX - this.plane.width / 2;
			this.y = this.stage.mouseY - this.plane.height / 2;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,
											 unscaledHeight:Number):void
		{
			trace("updateDisplayList");
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			if ( this.plane ){
				this.addChild( this.plane );
			}
		}
		
		public function removePlane() : void
		{
			trace("removePlane");
			if ( this.plane ){
				this.removeChild( this.plane );
				this.plane.bitmapData.dispose();
				this.plane = null;
			} 		
			this.flying = false;
			this.invalidateDisplayList();
			removeListeners();
			
			this.dispatchEvent( new Event( Event.CANCEL ) );
		}
		
		public function setPlane( data:BitmapData ) : void
		{
			trace("setPlane");
			if ( this.plane ){
				this.removeChild( this.plane );
			} 
			
			this.flying = true;
			this.plane = new Bitmap( data.clone() );
			
			this.invalidateDisplayList();
			
			setPos();
			addListeners();
		}
	}
}