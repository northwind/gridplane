package com.slide.as3.sliso.data {
	import com.slide.as3.sliso.events.IsoEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author ashi
	 */
	public class Node extends EventDispatcher implements INode{

		static private var _IDCount : uint = 0;

		public const UID : uint = _IDCount++;

		private var _id : String;

		private var _data : Object;

		private var _parent : INode;

		private var children : Array = new Array();

		public function Node() {
			super();
		}
		
		public function get id() : String {
			return (_id == null || _id == "") ? "node_" + UID.toString() : _id;
		}

		public function set id(id : String) : void {
			_id = id;
		}

		public function addChild(child : INode) : void {
			addChildAt(child, numChildren);
		}

		public function addChildAt(child : INode, index : uint) : void {
			//if it already exists here, do nothing
			//if (getChildByID(child.id))
				//return;
				
			//if it has another parent, then remove it there
			if (child.parent) {
				var parent : INode = child.parent;
				parent.removeChildByID(child.id);
			}
			
			Node(child).parent = this;
			children.splice(index, 0, child);
			
			var evt : IsoEvent = new IsoEvent(IsoEvent.CHILD_ADDED);
			evt.newValue = child;
			
			dispatchEvent(evt);
		}

		public function getChildByID(id : String) : INode {
			var childID : String;
			var child : INode;
			for each (child in children) {
				childID = child.id;
				if (childID == id)
					return child;
			}
			
			return null;
		}

		public function getChildAt(index : uint) : INode {
			if (index >= numChildren)
				throw new Error("");
			
			else
				return INode(children[index]);
		}

		public function getChildIndex(child : INode) : int {
			var i : int;
			while (i < numChildren) {
				if (child == children[i])
					return i;
				
				i++;
			}
			
			return -1;
		}
		
		public function setChildIndex (child:INode, index:uint):void
		{
			var i:int = getChildIndex(child);
			if (i == index)
				return;
				
			if (i > -1)
			{
				children.splice(i, 1);
				
				var c:INode;
				var notRemoved:Boolean = false;
				for each (c in children)
				{
					if (c == child)
						notRemoved = true;
				}
				
				if (notRemoved)
				{
					throw new Error("");
					return;
				}
				
				if (index >= numChildren)
					children.push(child);
				
				else
					children.splice(index, 0, child);
			}
			
			else
				throw new Error("");
		}

		public function contains(child : INode) : Boolean {
			if (child.hasParent)
				return child.parent == this; else {
				var theChild : INode;
				for each (theChild in children) {
					if (theChild == child)
						return true;
				}
				
				return false;
			}
		}

		public function removeChild(child : INode) : INode {
			return removeChildByID(child.id);
		}
		
		public function removeChildAt(index : uint) : INode {				
			var child : INode;
			if (index >= numChildren)
				return null;
				
			else
				child = INode(children[index]);
				
			return removeChildByID(child.id);
		}

		public function removeChildByID(id : String) : INode {
			var child : INode = getChildByID(id);
			if (child) {
				Node(child).parent = null;
				
				var i : uint;
				for (i;i < children.length;i++) {
					if (child == children[i]) {
						children.splice(i, 1);
						break;
					}
				}
				
				var evt : IsoEvent = new IsoEvent(IsoEvent.CHILD_REMOVED);
				evt.newValue = child;
				
				dispatchEvent(evt);
			}
			
			return child;
		}

		public function removeAllChildren() : void {
			var child : INode;
			for each (child in children) {
				Node(child).parent = null;
			}
			children = new Array();
		}

		public function get numChildren() : uint {
			return children.length;
		}

		public function set data(data : Object) : void {
			_data = data;
		}

		public function get data() : Object {
			return data;
		}

		public function get parent() : INode {
			return _parent;
		}

		public function set parent(parent : INode) : void {
			_parent = parent;
		}

		public function get hasParent() : Boolean {
			return _parent ? true : false;
		}
		
		public override function dispatchEvent(event : Event) : Boolean
		{
			if (event.bubbles && parent)
			{
				return parent.dispatchEvent(event);
			}
			
			return super.dispatchEvent(event);
		}
	}
}
