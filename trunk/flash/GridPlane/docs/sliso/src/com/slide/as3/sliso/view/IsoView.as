
package com.slide.as3.sliso.view {
	import com.slide.as3.sliso.display.IsoSprite;
	import com.slide.as3.sliso.events.IsoEvent;
	import com.slide.as3.sliso.display.IsoScene;
	import com.slide.as3.sliso.geom.IsoTransformation;
	import com.slide.as3.sliso.geom.Point3D;

	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IFactory;
	
	
	[Event(name="as3isolib_move", type="as3isolib.events.IsoEvent")]
	
	public class IsoView extends Sprite
	{
		
		protected var targetScreenPt: Point = new Point();
		protected var currentScreenPt:Point = new Point();
		
		public function get currentPoint ():Point
		{
			return currentScreenPt.clone() as Point;
		}
		
		public function get currentX ():Number
		{
			return currentScreenPt.x;
		}
		
		public function set currentX (value:Number):void
		{			
			if (currentScreenPt.x != value)
			{
				if (!targetScreenPt)
					targetScreenPt = currentScreenPt.clone() as Point;
				
				targetScreenPt.x = value;
				
				bPositionInvalidated = true;
				if (autoUpdate)
					render();
			}
		}
		
		public function get currentY ():Number
		{
			return currentScreenPt.y;
		}
		
		public function set currentY (value:Number):void
		{
			if (currentScreenPt.y != value);
			{
				if (!targetScreenPt)
					targetScreenPt = currentScreenPt.clone() as Point;
				
				targetScreenPt.y = value;
				
				bPositionInvalidated = true;
				if (autoUpdate)
					render();
			}
		}
		
		public function localToIso (localPt:Point):Point3D
		{
			localPt = localToGlobal(localPt);
			localPt = mainContainer.globalToLocal(localPt);
			
			return IsoTransformation.screenToSpace(localPt);
		}
		
		public function isoToLocal (isoPt:Point3D):Point
		{
			var temp:Point =  IsoTransformation.spaceToScreen(isoPt);
			temp = mainContainer.localToGlobal(temp);
			return globalToLocal(temp);
		}
		
		private var bPositionInvalidated:Boolean = false;
		
		public function get isInvalidated ():Boolean
		{
			return bPositionInvalidated;
		}
		
		public function invalidatePosition ():void
		{
			bPositionInvalidated = true;
		}
		
		public function getInvalidatedScenes ():Array
		{
			var a:Array = [];
			var scene:IsoScene;
			for each (scene in scenesArray)
			{
				if (scene.isInvalidated)
					a.push(scene);
			}
			
			return a;
		}
		
		public function render ():void
		{
			preRenderLogic();
			renderNow();
			postRenderLogic();
		}
		
		protected function preRenderLogic ():void
		{
			dispatchEvent(new IsoEvent(IsoEvent.RENDER));
		}
		
		protected function renderNow ():void {
			if (bPositionInvalidated) {
				validatePosition();
				bPositionInvalidated = false;
			}
			
			
			var scene : IsoScene;
			for each (scene in scenesArray)
					scene.render();
			
			renderView();
		}

		protected function postRenderLogic ():void
		{
			dispatchEvent(new IsoEvent(IsoEvent.RENDER_COMPLETE));
		}
		
		protected function validatePosition ():void
		{
			var dx:Number = currentScreenPt.x - targetScreenPt.x;
			var dy:Number = currentScreenPt.y - targetScreenPt.y;
			
			if (limitRangeOfMotion && romTarget)
			{
				var ndx:Number;
				var ndy:Number;
				
				var rect:Rectangle = romTarget.getBounds(this);
				var isROMBigger:Boolean = !romBoundsRect.containsRect(rect);
				if (isROMBigger)
				{
					if (dx > 0)
						ndx = Math.min(dx, Math.abs(rect.left));
					
					else
						ndx = -1 * Math.min(Math.abs(dx), Math.abs(rect.right - romBoundsRect.right));
						
					if (dy > 0)
						ndy = Math.min(dy, Math.abs(rect.top));
					
					else
						ndy = -1 * Math.min(Math.abs(dy), Math.abs(rect.bottom - romBoundsRect.bottom));
				}
				
				targetScreenPt.x = targetScreenPt.x + dx - ndx;
				targetScreenPt.y = targetScreenPt.y + dy - ndy;
				
				dx = ndx;
				dy = ndy;
			}
			
			mContainer.x += dx;
			mContainer.y += dy;
			
			var evt:IsoEvent = new IsoEvent(IsoEvent.MOVE);
			evt.propName = "currentPt";
			evt.oldValue = currentScreenPt;
			
			currentScreenPt = targetScreenPt.clone() as Point;
			
			evt.newValue = currentScreenPt;
			dispatchEvent(evt);
		}
		
		public var autoUpdate:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		public function centerOnPt (pt:Point3D):void
		{
			var target:Point3D = Point3D(pt.clone());
			targetScreenPt = IsoTransformation.spaceToScreen(target);
			bPositionInvalidated = true;
			render();
		}
		
		/**
		 * @inheritDoc
		 */
		public function centerOnIso (iso:IsoSprite):void
		{
			centerOnPt(iso.centerPt);	
		}
		
		public function pan (px:Number, py:Number):void
		{
			targetScreenPt = currentScreenPt.clone() as Point;
			
			targetScreenPt.x += px;
			targetScreenPt.y += py;
			
			bPositionInvalidated = true;
			render();
		}
		
		public function get currentZoom ():Number
		{
			return zoomContainer.scaleX;
		}
		
		public function set currentZoom (value:Number):void
		{
			zoomContainer.scaleX = zoomContainer.scaleY = value;
		}
		
		public function zoom (zFactor:Number):void
		{
			zoomContainer.scaleX = zoomContainer.scaleY = zFactor;
		}
		
		public function reset ():void
		{
			zoomContainer.scaleX = zoomContainer.scaleY = 1;
			setSize(_w, _h);
			
			mContainer.x = 0;
			mContainer.y = 0;
			
			currentScreenPt = new Point();
		}
		
		private var viewRendererFactories:Array = [];
		
		public function get viewRenderers ():Array
		{
			return viewRendererFactories;
		}
		
		public function set viewRenderers (value:Array):void
		{
			if (value)
			{
				var temp:Array = [];
				var obj:Object;
				for each (obj in value)
				{
					if (obj is IFactory)
						temp.push(obj);
				}
				
				viewRendererFactories = temp;
				
				bPositionInvalidated = true;
				if (autoUpdate)
					render();
			}
			
			else
				viewRendererFactories = [];
		}
		
		protected var scenesArray:Array = [];
		
		public function get scenes ():Array
		{
			return scenesArray;
		}
		
		public function get numScenes ():uint
		{
			return scenesArray.length;
		}
		
		public function addScene (scene:IsoScene):void
		{
			addSceneAt(scene, scenesArray.length);
		}
		
		public function addSceneAt (scene:IsoScene, index:int):void
		{
			if (!containsScene(scene))
			{
				scenesArray.splice(index, 0, scene);
				
				scene.rootContainer = null;
				sceneContainer.addChildAt(scene.container, index);
			}
			
			else
				throw new Error("IsoView instance already contains parameter scene");
		}
		
		public function containsScene (scene:IsoScene):Boolean
		{
			var childScene:IsoScene;
			for each (childScene in scenesArray)
			{
				if (scene == childScene)
					return true;
			}
			
			return false;
		}
		
		public function getSceneByID (id:String):IsoScene
		{
			var scene:IsoScene;
			for each (scene in scenesArray)
			{
				if (scene.id == id)
					return scene;
			}
			
			return null;
		}
		
		public function removeScene (scene:IsoScene):IsoScene
		{
			if (containsScene(scene))
			{
				var i:int = scenesArray.indexOf(scene);
				scenesArray.splice(i, 1);
				sceneContainer.removeChild(scene.container);
				
				return scene;	
			}
			
			else
				return null;
		}
		
		public function removeAllScenes ():void
		{
			var scene:IsoScene;
			for each (scene in scenesArray)
				scene.rootContainer = null;
			
			scenesArray = [];
		}
		
		private var _w:Number;
		private var _h:Number;
		
		override public function get width ():Number
		{
			return _w;
		}
		
		override public function get height ():Number
		{
			return _h;
		}
		
		public function get size ():Point
		{
			return new Point(_w, _h);
		}
		
		public function setSize (w:Number, h:Number):void
		{
			_w = Math.round(w);
			_h = Math.round(h);
			
			romBoundsRect = new Rectangle(0, 0, _w + 1, _h + 1);
			this.scrollRect = _clipContent ? romBoundsRect : null;
			
			zoomContainer.x = _w / 2;
			zoomContainer.y = _h / 2;
			
			drawBorder();
		}
		
		private var _clipContent:Boolean = true;
		
		/**
		 * @private
		 */
		public function get clipContent ():Boolean
		{
			return _clipContent;
		}
		
		public function set clipContent (value:Boolean):void
		{
			if (_clipContent != value)
			{
				_clipContent = value;
				reset();
			}
		}
		
		protected var romTarget:DisplayObject;
		
		protected var romBoundsRect:Rectangle;
		
		public function get rangeOfMotionTarget ():DisplayObject
		{
			return romTarget;
		}
		
		public function set rangeOfMotionTarget (value:DisplayObject):void
		{
			romTarget = value;
			limitRangeOfMotion = romTarget ? true : false;
		}
		
		public var limitRangeOfMotion:Boolean = true;
		
		private var zoomContainer:Sprite;
		
		protected var mContainer:Sprite;
		
		public function get mainContainer ():Sprite
		{
			return mContainer;
		}

		private var bgContainer:Sprite;
		
		public function get backgroundContainer ():Sprite
		{
			if (!bgContainer)
			{
				bgContainer = new Sprite();
				mContainer.addChildAt(bgContainer, 0);
			}
			
			return bgContainer;
		}
		
		private var fgContainer:Sprite;
		
		public function get foregroundContainer ():Sprite
		{
			if (!fgContainer)
			{
				fgContainer = new Sprite();
				mContainer.addChild(fgContainer);
			}
			
			return fgContainer;
		}
		
		private var sceneContainer:Sprite;
		
		private var maskShape:Shape;
		private var borderShape:Shape;
		
		private var _showBorder:Boolean = true;
		
		public function get showBorder ():Boolean
		{
			return _showBorder;
		}
		
		public function set showBorder (value:Boolean):void
		{
			if (_showBorder != value)
			{
				_showBorder = value;
				drawBorder();
			}
		}
		
		protected function drawBorder ():void
		{
			var g:Graphics = borderShape.graphics;
			g.clear();
			
			if (showBorder)
			{
				g.lineStyle(0);
				g.drawRect(0, 0, _w, _h);
			}
		}
		
		public function IsoView ()
		{
			super();
			
			sceneContainer = new Sprite();
			
			mContainer = new Sprite();
			mContainer.addChild(sceneContainer);
			
			zoomContainer = new Sprite();
			zoomContainer.addChild(mContainer);
			addChild(zoomContainer);
			
			maskShape = new Shape();
			addChild(maskShape);
			
			borderShape = new Shape();
			addChild(borderShape);
			
			setSize(400, 300);
			
			
		}
		
		public function renderView() : void{
			var targetScenes:Array = (scenesArray && scenesArray.length >= 1) ? scenesArray : scenes;
			if (targetScenes.length < 1)
				return;
			
			var v:Sprite = this;
			var rect:Rectangle = new Rectangle(0, 0, v.width, v.height);
			var bounds:Rectangle;
			
			var child:IsoSprite;
			var children:Array = [];
			
			//aggregate child objects
			var scene:IsoScene;
			for each (scene in targetScenes)
				children = children.concat(scene.children);
			
			for each (child in children)
			{				
				bounds = child.getBounds(v);
				bounds.width *= currentZoom;
				bounds.height *= currentZoom;		
				
				child.includeInLayout = rect.intersects(bounds);
			}
		}
	}
}