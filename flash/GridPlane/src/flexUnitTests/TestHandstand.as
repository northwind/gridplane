package flexUnitTests
{
	import flash.display.BitmapData;
	
	import flexunit.framework.Assert;
	
	import models.Hardstand;
	import models.Plane;
	
	import services.ServerService;
	
	public class TestHandstand
	{		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testSetPlane():void
		{
			var handstand:Hardstand = new Hardstand( new ServerService() );
			handstand.init();
			handstand.setPlane( 2,2, handstand.createPlane( new BitmapData(100,100) ) );
			
			trace("-------------------------------------");
			for( var i:int = 0; i< handstand.values.length; i++ ){
				trace( handstand.values[i] );
			}
			trace("-------------------------------------");
			
			Assert.assertTrue( true );
		}
		
		[Test]
		public function testtoString():void
		{
			var handstand:Hardstand = new Hardstand( new ServerService() );
			handstand.init();
			handstand.setPlane( 2,2, handstand.createPlane( new BitmapData(100,100) ) );
			
			trace( handstand.toString() );
			
			Assert.assertTrue( true );
		}
	}
}