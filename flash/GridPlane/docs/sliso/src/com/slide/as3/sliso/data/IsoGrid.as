package com.slide.as3.sliso.data {
	import com.slide.as3.sliso.display.IsoSprite;
	import com.slide.as3.sliso.geom.IsoTransformation;
	import com.slide.as3.sliso.geom.Point3D;

	import flash.display.Graphics;
	import flash.geom.Point;

	/**
	 * @author ashi
	 */
	public class IsoGrid extends IsoSprite{
		private var _cols : Number;
		
		private var _rows : Number;
		
		private var _size : Number;
		
		override protected function renderNow():void
		{
			
			if (!hasParent && !renderAsOrphan)
				return;
			
			if (bSizeInvalidated)
			{
				drawGrid();
				
				validateSize();
				bSizeInvalidated = false;
			}
			
			super.renderNow();
		}
		
		private function drawGrid() : void {
			
			var g:Graphics = _container.graphics;
			g.clear();
			g.lineStyle(0, 0xDEDEDE, 1);
			
			var pt:Point = new Point();
			
			var i:int = 0;
			var m:int = cols;
			while (i <= m)
			{
				pt = IsoTransformation.spaceToScreen(new Point3D(_size * i));
				g.moveTo(pt.x, pt.y);
				
				pt = IsoTransformation.spaceToScreen(new Point3D(_size * i, 0, _size * rows));
				g.lineTo(pt.x, pt.y);
				
				i++;
			}
			
			i = 0;
			m = rows;
			while (i <= m)
			{
				pt = IsoTransformation.spaceToScreen(new Point3D(0, 0, _size * i));
				g.moveTo(pt.x, pt.y);
				
				pt = IsoTransformation.spaceToScreen(new Point3D(_size * cols, 0, _size * i));
				g.lineTo(pt.x, pt.y);
				
				i++;
			}
			
			pt = IsoTransformation.spaceToScreen(new Point3D(0, 0));
			g.moveTo(pt.x, pt.y);
			g.lineStyle(0, 0, 0);
			g.beginFill(0xFF0000, 0.0);
			
			pt = IsoTransformation.spaceToScreen(new Point3D(_size * cols, 0));
			g.lineTo(pt.x, pt.y);
			
			pt = IsoTransformation.spaceToScreen(new Point3D(_size * cols, 0, _size * rows));
			g.lineTo(pt.x, pt.y);
			
			pt = IsoTransformation.spaceToScreen(new Point3D(0, 0, _size * rows));
			g.lineTo(pt.x, pt.y);
			
			pt = IsoTransformation.spaceToScreen(new Point3D(0, 0));
			g.lineTo(pt.x, pt.y);
			g.endFill();
			
		}
		
		public function get cols() : Number {
			return _cols;
		}
		
		public function set cols(value : Number) : void {
			if (_cols != value)
			{
				_cols = value;
				
				invalidateSize();
				if (autoUpdate)
					render();
			}
		}
		
		public function get rows() : Number {
			return _rows;
		}
		
		public function set rows(value : Number) : void {
			if (_rows != value)
			{
				_rows = value;
				
				invalidateSize();
				if (autoUpdate)
					render();
			}
		}
		
		public function get size() : Number {
			return _size;
		}
		
		public function set size(value : Number) : void {
			if (_size != value)
			{
				_size = value;
				
				invalidateSize();
				if (autoUpdate)
					render();
			}
		}
		
		public function IsoGrid(size : int = 35, cols : int = 40, rows : int = 40) {
			super();
			
			this.size = size;
			this.cols = cols;
			this.rows = rows;
		}
	}
}
