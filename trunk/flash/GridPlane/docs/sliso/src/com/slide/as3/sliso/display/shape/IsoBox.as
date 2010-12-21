package com.slide.as3.sliso.display.shape {
	import flash.display.Graphics;
	import flash.geom.Point;

	import com.slide.as3.sliso.geom.IsoTransformation;
	import com.slide.as3.sliso.display.IsoSprite;
	import com.slide.as3.sliso.geom.Point3D;

	/**
	 * @author ashi
	 */
	public class IsoBox extends IsoSprite{
		
		static public const DEFAULT_WIDTH:Number = 35;
		static public const DEFAULT_LENGTH:Number = 35;
		static public const DEFAULT_HEIGHT:Number = 35;
		
		public function IsoBox() {
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
				drawBox();
				
				validateSize();
				bSizeInvalidated = false;
			}
			
			super.renderNow();
		}
		
		protected function drawBox() : void
		{
			var points : Array = getPts();
			
			var lbb:Point = IsoTransformation.spaceToScreen(points[0]);
			var rbb:Point = IsoTransformation.spaceToScreen(points[1]);
			var rbf:Point = IsoTransformation.spaceToScreen(points[2]);
			var lbf:Point = IsoTransformation.spaceToScreen(points[3]);
			
			var ltb:Point = IsoTransformation.spaceToScreen(points[4]);
			var rtb:Point = IsoTransformation.spaceToScreen(points[5]);
			var rtf:Point = IsoTransformation.spaceToScreen(points[6]);
			var ltf:Point = IsoTransformation.spaceToScreen(points[7]);
			
			var g:Graphics = _container.graphics;
			g.clear();
			
			g.lineStyle(0, 0xDEDEDE, 1);
			
			g.moveTo(lbb.x, lbb.y);
			g.lineTo(rbb.x, rbb.y);
			g.lineTo(rbf.x, rbf.y);
			g.lineTo(lbf.x, lbf.y);
			g.lineTo(lbb.x, lbb.y);
			
			g.moveTo(lbb.x, lbb.y);
			g.lineTo(lbf.x, lbf.y);
			g.lineTo(ltf.x, ltf.y);
			g.lineTo(ltb.x, ltb.y);
			g.lineTo(lbb.x, lbb.y);
			
			g.moveTo(lbb.x, lbb.y);
			g.lineTo(rbb.x, rbb.y);
			g.lineTo(rtb.x, rtb.y);
			g.lineTo(ltb.x, ltb.y);
			g.lineTo(lbb.x, lbb.y);
			
			g.moveTo(lbf.x, lbf.y);
			g.lineTo(ltf.x, ltf.y);
			g.lineTo(rtf.x, rtf.y);
			g.lineTo(rbf.x, rbf.y);
			g.lineTo(lbf.x, lbf.y);
			
			g.moveTo(rbb.x, rbb.y);
			g.lineTo(rbf.x, rbf.y);
			g.lineTo(rtf.x, rtf.y);
			g.lineTo(rtb.x, rtb.y);
			g.lineTo(rbb.x, rbb.y);
			
			g.moveTo(ltb.x, ltb.y);
			g.lineTo(rtb.x, rtb.y);
			g.lineTo(rtf.x, rtf.y);
			g.lineTo(ltf.x, ltf.y);
			g.lineTo(ltb.x, ltb.y);
		}
		
		protected function getPts ():Array
		{
			var a:Array = [];
			
			a.push(new Point3D(0, 0, 0));
			a.push(new Point3D(width, 0, 0));
			a.push(new Point3D(width, 0, length));
			a.push(new Point3D(0, 0, length));
			
			a.push(new Point3D(0, -height, 0));
			a.push(new Point3D(width, -height, 0));
			a.push(new Point3D(width, -height, length));
			a.push(new Point3D(0, -height, length));
			
			return a;
		}
	}
}
