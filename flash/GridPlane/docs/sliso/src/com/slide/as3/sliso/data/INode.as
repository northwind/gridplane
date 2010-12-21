package com.slide.as3.sliso.data {
	import flash.events.Event;

	/**
	 * @author ashi
	 */
	public interface INode {

		function addChild(child : INode) : void;
		
		function addChildAt(child : INode, index :uint) : void;

		function getChildByID(id : String) : INode;
		
		function getChildAt(index : uint) : INode;
		
		function getChildIndex(child : INode) : int;

		function contains(child : INode) : Boolean;

		function removeChild(child : INode) : INode;
		
		function removeChildAt(index :uint) : INode;
		
		function removeChildByID(id : String) : INode;
		
		function removeAllChildren() : void;
		
		function get numChildren() : uint;
		
		function set id(id : String) : void;
		
		function get id() : String;
		
		function set data(data : Object) : void;

		function get data() : Object;
		
		function set parent(parent : INode) : void;
		
		function get parent() : INode;
		
		function get hasParent() : Boolean;
		
		function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void;
		
		function dispatchEvent(event : Event) : Boolean;
		
		function hasEventListener(type : String) : Boolean;
		
		function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void;
		
		function willTrigger(type : String) : Boolean;
	}
}
