package com.slide.as3.sliso.display {
	import com.slide.as3.sliso.data.RenderData;
	import com.slide.as3.sliso.events.IsoEvent;
	import com.slide.as3.sliso.geom.IsoTransformation;
	import com.slide.as3.sliso.geom.Point3D;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author ashi
	 */
	public class IsoSprite extends IsoDisplayObject {

		protected var cachedRenderData : RenderData;

		protected var cachedAsBitmap : Boolean = false;
		
		protected var _x : Number = 0;
		protected var ox : Number = 0;
		
		protected var _y : Number = 0;
		protected var oy : Number = 0;
		
		protected var _z : Number = 0;
		protected var oz : Number = 0;
		
		protected var _width : Number = 0;
		protected var oWidth : Number = 0;
		
		protected var _length : Number = 0;
		protected var oLength : Number = 0;
		
		protected var _height : Number = 0;
		protected var oHeight : Number = 0;
		
		protected var bInvalidateEventDispatched:Boolean = false;
		
		protected var bPositionInvalidated:Boolean = false;
		
		protected var bSizeInvalidated:Boolean = false;
		
		protected var _autoUpdate : Boolean = false;
		
		protected var _renderAsOrphan : Boolean = false;

		public function getRenderData() : RenderData {
			if (isInvalidated || !cachedRenderData) {
				var flag:Boolean = _renderAsOrphan;
				_renderAsOrphan = true;
				if(cachedRenderData && cachedRenderData.bitmapData) cachedRenderData.bitmapData.dispose(); 
				render();
				
				var r : Rectangle = _container.getBounds(_container);
				
				var bd : BitmapData = new BitmapData(r.width + 1, r.height + 1, true, 0x000000);
				bd.draw(_container, new Matrix(1, 0, 0, 1, -r.left, -r.top));
				
				var renderData : RenderData = new RenderData();
				renderData.x = _container.x + r.left;
				renderData.y = _container.y + r.top;
				renderData.bitmapData = bd;
				
				cachedRenderData = renderData;
				_renderAsOrphan = flag;
			} else {
				cachedRenderData.x = _container.x + r.left;
				cachedRenderData.y = _container.y + r.top;
			}
			
			return cachedRenderData;
		}

		public function get _cachedAsBitmap() : Boolean {
			return cachedAsBitmap;
		}
		
		public function set _cachedAsBitmap(cachedAsBitmap : Boolean) : void {
			this.cachedAsBitmap = cachedAsBitmap;
		}
		
		public function get screenBounds ():Rectangle
		{
			var screenBounds:Rectangle = _container.getBounds(_container);				
			screenBounds.x += _container.x;
			screenBounds.y += _container.y;
			return screenBounds;
		}
		
		public function getBounds (targetCoordinateSpace:DisplayObject):Rectangle
		{
			var rect:Rectangle = screenBounds;
			
			var pt:Point = new Point(rect.x, rect.y);
			pt = IIsoDisplayObject(parent).container.localToGlobal(pt);
			pt = targetCoordinateSpace.globalToLocal(pt);
			
			rect.x = pt.x;
			rect.y = pt.y;
			
			return rect;
		}
		
		public function setPosition (x:Number, y:Number, z:Number):void
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		//X
		public function get x ():Number
		{
			return _x;
		}
		
		public function set x (value:Number):void
		{
			if (_x != value)
			{
				ox = _x;
				_x = value;
				
				invalidatePosition();
				if (autoUpdate)
					render();
			}
		}
		
		public function get screenX ():Number
		{
			return IsoTransformation.spaceToScreen(new Point3D(x, y, z)).x;
		}
		
		//Y
		public function get y ():Number
		{
			return _y;
		}
		
		public function set y (value:Number):void
		{
			if (_y != value)
			{
				oy = _y;
				_y = value;
				
				invalidatePosition();
				
				if (autoUpdate)
					render();
			}
		}
		
		public function get screenY ():Number
		{
			return IsoTransformation.spaceToScreen(new Point3D(x, y, z)).y;
		}
		//Z
		public function get z ():Number
		{
			return _z;
		}
		
		public function set z (value:Number):void
		{
			if (_z != value)
			{
				oz = _z;
				_z = value;
				
				invalidatePosition();
				
				if (autoUpdate)
					render();
			}
		}
		
		public function setSize (width:Number, length:Number, height:Number):void
		{
			this.width = width;
			this.length = length;
			this.height = height;
		}
		
		//W
		public function get width() : Number
		{
			return _width;
		}
		
		public function set width(value : Number) : void
		{
			value = Math.abs(value);
			
			if (_width != value)
			{
				oWidth = _width;
				_width = value;
				
				invalidateSize();
				
				if (autoUpdate)
					render();
			}
		}
		
		//L
		public function get length() : Number
		{
			return _length;
		}
		
		public function set length(value : Number) : void
		{
			value = Math.abs(value);
			
			if (_length != value)
			{
				oLength = _length;
				_length = value;
				
				invalidateSize();
				
				if (autoUpdate)
					render();
			}
		}
		
		//H
		public function get height() : Number
		{
			return _height;
		}
		
		public function set height(value : Number) : void
		{
			value = Math.abs(value);
			
			if (_height != value)
			{
				oHeight = _height;
				_height = value;
				
				invalidateSize();
				
				if (autoUpdate)
					render();
			}
		}
		
		public function invalidatePosition ():void
		{
			bPositionInvalidated = true;
			
			if (!bInvalidateEventDispatched)
			{
				dispatchEvent(new IsoEvent(IsoEvent.INVALIDATE));
				bInvalidateEventDispatched = true;
			}
		}
		
		public function invalidateSize ():void
		{
			bSizeInvalidated = true;
			
			if (!bInvalidateEventDispatched)
			{
				dispatchEvent(new IsoEvent(IsoEvent.INVALIDATE));
				bInvalidateEventDispatched = true;
			}
		}
		
		public override function get isInvalidated ():Boolean
		{
			return (bPositionInvalidated || bSizeInvalidated);
		}
		
		protected function validatePosition ():void
		{
			var pt:Point = IsoTransformation.spaceToScreen(new Point3D(x, y, z));
			
			_container.x = pt.x;
			_container.y = pt.y;
			
			var evt:IsoEvent = new IsoEvent(IsoEvent.MOVE, true);
			evt.propName = "position";
			evt.oldValue = {x:ox, y:oy, z:oz};
			evt.newValue = {x:_x, y:_y, z:_z};
			
			dispatchEvent(evt);
		}
		
		protected function validateSize ():void
		{			
			var evt:IsoEvent = new IsoEvent(IsoEvent.RESIZE, true);
			evt.propName = "size";
			evt.oldValue = {width:oWidth, length:oLength, height:oHeight};
			evt.newValue = {width:_width, length:_length, height:_height};
			
			dispatchEvent(evt);
		}
		
		public function get autoUpdate() : Boolean {
			return _autoUpdate;
		}
		
		public function set autoUpdate(autoUpdate : Boolean) : void {
			_autoUpdate = autoUpdate;
		}
		
		public function get renderAsOrphan() : Boolean {
			return _renderAsOrphan;
		}
		
		public function set renderAsOrphan(renderAsOrphan : Boolean) : void {
			_renderAsOrphan = renderAsOrphan;
		}
		
		public function IsoSprite ()
		{
			super();
		}
		
		public override function createContainer() : void {
			super.createContainer();
			container.cacheAsBitmap = cachedAsBitmap;
		}
		
		override protected function renderNow ():void
		{
			if (!hasParent && !renderAsOrphan)
				return;
			
			if (bPositionInvalidated)
			{
				validatePosition();
				bPositionInvalidated = false;
			}
			
			if (bSizeInvalidated)
			{
				validateSize();
				bSizeInvalidated = false;
			}
			
			bInvalidateEventDispatched = false;
			super.renderNow();
		}
		
		public function get top() : Number {
			return _y - height;
		}
		
		public function get bottom() : Number {
			return _y;
		}
		
		public function get left() : Number {
			return _x;
		}
		
		public function get right() : Number {
			return _x + width;
		}
		
		public function get front() : Number {
			return _z + length;
		}
		
		public function get back() : Number {
			return _z;
		}
		
		public function get centerPt() : Point3D {
			return new Point3D(x + width*0.5, y - height*0.5, z + length*0.5);
		}
	}
}
