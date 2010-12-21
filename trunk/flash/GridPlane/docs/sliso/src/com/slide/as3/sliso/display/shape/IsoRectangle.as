package com.slide.as3.sliso.display.shape {
	import flash.display.Graphics;
	import flash.geom.Point;

	import com.slide.as3.sliso.geom.IsoTransformation;
	import com.slide.as3.sliso.display.IsoSprite;
	import com.slide.as3.sliso.geom.Point3D;

	/**
	 * @author ashi
	 */
	public class IsoRectangle extends IsoSprite{
		
		static public const DEFAULT_WIDTH:Number = 35;
		static public const DEFAULT_LENGTH:Number = 35;
		static public const DEFAULT_HEIGHT:Number = 35;
		
		public function IsoRectangle() {
			super();
			
			width = DEFAULT_WIDTH;
			length = DEFAULT_LENGTH;
			height = DEFAULT_HEIGHT;
		}
		
		override protected function renderNow():void
		{
			if (!hasParent && !renderAsOrphan)
				return;
			
			if (bSizeInvalidated)
			{
				drawRect();
				
				validateSize();
				bSizeInvalidated = false;
			}
			
			super.renderNow();
		}
		
		protected function drawRect() : void
		{
			var points : Array = getPts();
			
			var lbb:Point = IsoTransformation.spaceToScreen(points[0]);
			var rbb:Point = IsoTransformation.spaceToScreen(points[1]);
			var rbf:Point = IsoTransformation.spaceToScreen(points[2]);
			var lbf:Point = IsoTransformation.spaceToScreen(points[3]);
			
			var g:Graphics = _container.graphics;
			g.clear();
			
			g.lineStyle(0, 0xDEDEDE, 1);
			
			g.moveTo(lbb.x, lbb.y);
			g.lineTo(rbb.x, rbb.y);
			g.lineTo(rbf.x, rbf.y);
			g.lineTo(lbf.x, lbf.y);
			g.lineTo(lbb.x, lbb.y);
		}
		
		protected function getPts ():Array
		{
			var a:Array = [];
			a.push(new Point3D(0, 0, 0));
			a.push(new Point3D(width, 0, 0));
			a.push(new Point3D(width, 0, length));
			a.push(new Point3D(0, 0, length));
			return a;
		}
	}
}
