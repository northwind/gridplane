package components
{
	import skins.IconButtnSkin;
	
	import spark.components.Button;
	
	[Style(name="upIcon", type="*",inherit="no")]
	[Style(name="downIcon", type="*",inherit="no")]
	[Style(name="overIcon", type="*",inherit="no")]
	[Style(name="disabledIcon", type="*",inherit="no")]
	
	public class IconButton extends Button
	{
		public var defaultSkin:Class = IconButtnSkin;
		
		public function IconButton()
		{
			super();
			this.setStyle( "skinClass", defaultSkin );
			this.buttonMode = true;
		}
	}
}