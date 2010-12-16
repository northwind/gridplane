package layers
{
	import mx.core.UIComponent;
	
	public class LineLayer extends UIComponent
	{
		[Bindable]
		public var rows : int;
		[Bindable]
		public var columns : int;
		[Bindable]
		public var cellWidth : int = 48;
		[Bindable]
		public var cellHeight : int = 48;
		[Bindable]
		public var color:uint = 0x333333;
		
		public function LineLayer()
		{
			super();
		}
		
		public function setParams ( r:int, c:int, w :int, h:int ) : void
		{
			this.rows = r;
			this.columns = c;
			this.cellWidth = w;
			this.cellHeight = h;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			repaint();
		}
		
		public function repaint() : void
		{
			this.graphics.clear();
			this.graphics.beginFill( color );
			this.graphics.lineStyle(2, color, 1, false, "normal", null, null, 0 );
			
			var totalH : int = cellHeight * rows;
			var totalW : int = cellWidth * columns;
			//列
			for( var i :int = 1; i < columns+1; i++ )
			{
				this.graphics.moveTo( i * cellWidth, 0 );
				this.graphics.lineTo( i * cellWidth, totalH );
			}
			
			//行
			for( i = 1; i < rows+1; i++ )
			{
				this.graphics.moveTo( 0, i * cellHeight );
				this.graphics.lineTo( totalW, i * cellHeight );
			}
			
			this.graphics.endFill();
		}
		
	}
}