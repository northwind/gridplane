package components
{
	import skins.IconButtnSkin;
	
	import spark.components.Button;
	
	//icons
	[Style(name="iconUp",type="*")]
	[Style(name="iconOver",type="*")]
	[Style(name="iconDown",type="*")]
	[Style(name="iconDisabled",type="*")]
	
	public class IconButton extends Button
	{
		public static var defaultSkin:Class = IconButtnSkin;
		public function IconButton()
		{
			super();
			this.setStyle( "skinClass", defaultSkin );
			this.buttonMode = true;
		}
	}
}