package com.slide.as3.sliso.display {
	import flash.display.Sprite;

	/**
	 * @author ashi
	 */
	public interface IIsoDisplayObject{
		function get children ():Array;
		
		function get depth ():int;
		
		function get container ():Sprite;
		
		function render():void;
	}
}
