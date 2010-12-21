package com.slide.as3.sliso.display {
	import flash.utils.Dictionary;
	import com.slide.as3.sliso.events.IsoEvent;
	import com.slide.as3.sliso.data.INode;

	import flash.display.Sprite;

	/**
	 * @author ashi
	 */
	public class IsoScene extends IsoDisplayObject{
		private var _rootContainer : Sprite;
		
		protected var invalidatedChildrenArray:Array = new Array();
		
		public function get rootContainer() : Sprite {
			return _rootContainer;
		}
		
		public function set rootContainer(value : Sprite) : void {
			if (value && _rootContainer != value)
			{
				if (_rootContainer && _rootContainer.contains(container))
				{
					_rootContainer.removeChild(container);
				}
				
				else if (hasParent)
					parent.removeChild(this);
				
				_rootContainer = value;
				if (_rootContainer)
				{
					_rootContainer.addChild(container);
					parent = null;
				}
			}
		}
		
		public function get invalidatedChildren ():Array
		{
			return invalidatedChildrenArray;
		}
		
		override public function addChildAt (child:INode, index:uint):void
		{
			if (child is IIsoDisplayObject)
			{
				super.addChildAt(child, index);
				child.addEventListener(IsoEvent.INVALIDATE, child_invalidateHandler);
				
				_isInvalidated = true;
			}
		}
		
		override public function setChildIndex (child:INode, index:uint):void
		{
			super.setChildIndex(child, index);
			_isInvalidated = true;
		}
		
		override public function removeChildByID (id:String):INode
		{
			var child:INode = super.removeChildByID(id);
			if (child)
			{
				child.removeEventListener(IsoEvent.INVALIDATE, child_invalidateHandler);
				_isInvalidated = true;
			}
			
			return child;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeAllChildren ():void
		{			
			var child:INode;
			for each (child in children)
				child.removeEventListener(IsoEvent.INVALIDATE, child_invalidateHandler);
			
			super.removeAllChildren();
			_isInvalidated = true;
		}
		
		protected function child_invalidateHandler (evt:IsoEvent):void
		{
			var child:Object = evt.target;
			if (invalidatedChildrenArray.indexOf(child) == -1)
				invalidatedChildrenArray.push(child);
			
			_isInvalidated = true;
		}
		
		override protected function renderNow():void {
			super.renderNow();
			
			if (_isInvalidated)
			{
				renderScene();
				_isInvalidated = false;
			}
		}
		
		private var dependency : Dictionary;
		private var visited : Dictionary = new Dictionary();
		private var childDepth : int = 0;
		
		protected function renderScene() : void {
			dependency = new Dictionary();
			
			var children:Array = this.children;
			var len:uint = children.length;
			
			for (var i:uint = 0; i < len; ++i)
			{
				var behind:Array = [];
				
				var objA:IsoSprite = children[i];
				
				var rightA:Number = objA.x + objA.width;
				var frontA:Number = objA.z + objA.length;
				var topA:Number = objA.y - objA.height;
				
				for (var j:uint = 0; j < len; ++j)
				{
					var objB:IsoSprite = children[j];
					if ((objB.x < rightA) &&
						(objB.z < frontA) &&
						(objB.y > topA) &&
						(i !== j))
					{
						behind.push(objB);
					}
				}
				
				dependency[objA] = behind;
			}
			
			childDepth = 0;
			for each (var obj:IsoSprite in children){
				if (true !== visited[obj]){
					place(obj);
				}
			}
			visited = new Dictionary();
		}
		
		private function place(obj:IsoDisplayObject):void
		{
			visited[obj] = true;
			
			for each(var inner:IsoDisplayObject in dependency[obj]){
				if(true != visited[inner]){
					place(inner);
				}
			}
			
			if (childDepth != obj.depth)
			{
				setChildIndex(obj, depth);
			}
			
			++childDepth;
		};
	}
}
