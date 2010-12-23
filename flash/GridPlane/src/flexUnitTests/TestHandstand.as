package flexUnitTests
{
	import flexunit.framework.Assert;
	
	import models.Hardstand;
	import models.Plane;
	
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
			var plane:Plane = new Plane();
			plane.rotation = 180;
			
			var handstand:Hardstand = new Hardstand();
			handstand.init();
			handstand.setPlane( 2,2, plane );
			
			trace("-------------------------------------");
			for( var i:int = 0; i< handstand.values.length; i++ ){
				trace( handstand.values[i] );
			}
			trace("-------------------------------------");
			
			Assert.assertTrue( false );
		}
	}
}