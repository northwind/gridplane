package com.slide.as3.sliso.display {
	import com.slide.as3.sliso.events.IsoEvent;
	import com.slide.as3.sliso.data.INode;
	import com.slide.as3.sliso.data.Node;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	/**
	 * @author ashi
	 */
	public class IsoDisplayObject extends Node implements IIsoDisplayObject {

		protected var displayChildren : Array = new Array();

		protected var _container : Sprite;
		
		protected var _isInvalidated : Boolean = false;
		
		protected var _includeInLayout : Boolean = false;
		
		protected var includeInLayoutChanged : Boolean = false;

		public function get children() : Array {
			var res : Array = [];
			var child : IIsoDisplayObject;
			for each (child in displayChildren)
				res.push(child);
			
			return res;
		}

		override public function addChildAt(child : INode, index : uint) : void {
			if (child is IIsoDisplayObject) {
				super.addChildAt(child, index);
				
				
				displayChildren.push(child);
				if (index > _container.numChildren)
						index = _container.numChildren;
					
				var p : DisplayObjectContainer = IIsoDisplayObject(child).container.parent;
				if (p && p != _container)
						p.removeChild(IIsoDisplayObject(child).container);
					
				_container.addChildAt(IIsoDisplayObject(child).container, index);
			}
		}

		override public function setChildIndex(child : INode, index : uint) : void {
			if (!child is IIsoDisplayObject)
				return;
			
			else if (!child.hasParent || child.parent != this)
				return; else {
				super.setChildIndex(child, index);
				container.setChildIndex(IIsoDisplayObject(child).container, index);
			}
		}

		override public function removeChildByID(id : String) : INode {
			var child : INode = super.removeChildByID(id);
			if (child) {
				var i : int = displayChildren.indexOf(child);
				if (i > -1) displayChildren.splice(i, 1);
				_container.removeChild(IIsoDisplayObject(child).container);
			}
			
			return child;
		}

		override public function removeAllChildren() : void {
			var child : IIsoDisplayObject;
			for each (child in children) {
				_container.removeChild(child.container);
			}
			
			displayChildren = new Array();
				
			super.removeAllChildren();
		}

		public function get depth() : int {
			if (_container.parent)
				return _container.parent.getChildIndex(_container);
			else
				return -1;
		}

		public function get container() : Sprite {
			return _container;
		}

		public function render() : void {
			preRender();
			renderNow();
			postRender();
		}

		protected function postRender() : void {
			dispatchEvent(new IsoEvent(IsoEvent.RENDER));
		}

		protected function renderNow() : void {
			
			if (includeInLayoutChanged && parent)
			{
				var p:IsoDisplayObject = IsoDisplayObject(parent);
				var i:int = p.displayChildren.indexOf(this);
				if (_includeInLayout)
				{
					if (i == -1)
						p.displayChildren.push(this);
					
					if (!_container.parent)
						IsoDisplayObject(parent).container.addChildAt(_container, Math.max(i, 0));
				}
				
				else if (!_includeInLayout)
				{
					if (i >= 0)
						p.displayChildren.splice(i, 1);
					
					if (_container.parent)
						IsoDisplayObject(parent).container.removeChild(_container);
				}
				
				includeInLayoutChanged = false;
			}
			
			var child : IIsoDisplayObject;
			for each (child in children)
					 child.render();
		}

		protected function preRender() : void {
			dispatchEvent(new IsoEvent(IsoEvent.RENDER_COMPLETE));
		}

		public function IsoDisplayObject() {
			super();
			createContainer();
		}

		public function createContainer() : void {
			_container = new Sprite();
		}
		
		public function get isInvalidated() : Boolean {
			return _isInvalidated;
		}
		
		public function get includeInLayout ():Boolean {
			 return _includeInLayout;
		}
		
		public function set includeInLayout(value : Boolean) : void {
			if (_includeInLayout != value)
			{
				_includeInLayout = value;
				includeInLayoutChanged = true;
			}
		}
	}
}
