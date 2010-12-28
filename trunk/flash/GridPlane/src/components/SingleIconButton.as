package components
{
	import skins.SingleIconButtnSkin;
	import spark.components.Button;
	
	//icons
	[Style(name="icon",type="*")]
	
	public class SingleIconButton extends Button
	{
		public static var defaultSkin:Class = SingleIconButtnSkin;
		public function SingleIconButton()
		{
			super();
			this.setStyle( "skinClass", defaultSkin );
			this.buttonMode = true;
		}
	}
}