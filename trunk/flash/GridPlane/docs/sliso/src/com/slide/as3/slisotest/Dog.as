package com.slide.as3.slisotest {
	import com.slide.as3.sliso.display.shape.IsoBox;

	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;

	/**
	 * @author ashi
	 */
	public class Dog extends IsoBox {
		static public const DEFAULT_WIDTH : Number = 35;
		static public const DEFAULT_LENGTH : Number = 35;
		static public const DEFAULT_HEIGHT : Number = 45;

		private var mv0 : MovieClip;
		private var mv1 : MovieClip;
		private var mv2 : MovieClip;
		private var mv3 : MovieClip;
		private var mv4 : MovieClip;
		private var mv5 : MovieClip;
		private var mv6 : MovieClip;
		private var mv7 : MovieClip;

		private static var OFFSET_X : int = 19;
		private static var OFFSET_Y : int = 2;

		private var artworks : ArtworksLiberary;

		public function Dog() {
			cachedAsBitmap = false;
			
			super();
			artworks = new ArtworksLiberary();
			
			width = DEFAULT_WIDTH;
			length = DEFAULT_LENGTH;
			height = DEFAULT_HEIGHT;
			
			getAnimations();
		}

		private function getAnimations() : void {
			var ani0 : Class = getDefinitionByName("ArtworksLiberary_Dog_Assets_0") as Class;
			mv0 = new ani0() as MovieClip;
			var ani1 : Class = getDefinitionByName("ArtworksLiberary_Dog_Assets_1") as Class;
			mv1 = new ani1() as MovieClip;
			var ani2 : Class = getDefinitionByName("ArtworksLiberary_Dog_Assets_2") as Class;
			mv2 = new ani2() as MovieClip;
			var ani3 : Class = getDefinitionByName("ArtworksLiberary_Dog_Assets_3") as Class;
			mv3 = new ani3() as MovieClip;
			var ani4 : Class = getDefinitionByName("ArtworksLiberary_Dog_Assets_4") as Class;
			mv4 = new ani4() as MovieClip;
			var ani5 : Class = getDefinitionByName("ArtworksLiberary_Dog_Assets_5") as Class;
			mv5 = new ani5() as MovieClip;
			var ani6 : Class = getDefinitionByName("ArtworksLiberary_Dog_Assets_6") as Class;
			mv6 = new ani6() as MovieClip;
			var ani7 : Class = getDefinitionByName("ArtworksLiberary_Dog_Assets_7") as Class;
			mv7 = new ani7() as MovieClip;
			
			mv0.x = mv1.x = mv2.x = mv3.x = mv4.x = mv5.x = mv6.x = mv7.x = OFFSET_X;
			mv0.y = mv1.y = mv2.y = mv3.y = mv4.y = mv5.y = mv6.y = mv7.y = OFFSET_Y;
		}

		override protected function renderNow() : void {
			if (!hasParent && !renderAsOrphan)
				return;
			
			if (bSizeInvalidated) {
				super.drawBox();
				drawCharacter();
				
				validateSize();
				bSizeInvalidated = false;
			}
			
			super.renderNow();
		}

		protected function drawCharacter() : void {
			if(!_container.contains(mv0)) {
				_container.addChildAt(mv0, 0);
			}
		}
	}
}
