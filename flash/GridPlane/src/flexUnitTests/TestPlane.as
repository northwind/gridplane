package flexUnitTests
{
	import flash.display.BitmapData;
	
	import flexunit.framework.Assert;
	
	import models.Plane;
	
	public class TestPlane
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
		public function testCalcValue90():void
		{
			var plane:Plane = new Plane( new BitmapData(240,196 ) );
			plane.rotation = 90;
		
			var ret:Array = [  [-1, -1, 1, -1],
										[ 1, -1, 1, -1],
										[ 1,  1, 1,  9],
										[ 1, -1, 1, -1],
										[-1, -1, 1, -1] ];
			
			trace( "90 : " + plane.calcValue().toString()  );
			
			Assert.assertTrue(  plane.calcValue().toString() ==  ret.toString() );
		}
		
		[Test]
		public function testCalcValue180():void
		{
			var plane:Plane = new Plane( new BitmapData(240,196 ) );
			plane.rotation = 180;
			
			var ret:Array = [  [ -1, 1, 1, 1, -1],
										[ -1,-1,1,-1,-1],
										[  1, 1, 1, 1, 1],
										[ -1,-1, 9,-1,-1] ];
			
			trace( "180 : " + plane.calcValue().toString()  );
			trace( "180 : " + ret.toString()  );
			
//			var values:Array = plane.calcValue();
//			for( var j:int = 0; j< plane.height; j++ ){
//				for( var i:int = 0; i< plane.width; i++ ){
//					if ( int( ret[j][i] ) != int( values[j][i] ) ){
//						trace( "j=" + j + " i=" + i );
//					}
//				}
//			}			
			
			Assert.assertTrue(  plane.calcValue().toString() ==  ret.toString() );
		}
		
		[Test]
		public function testCalcValue270():void
		{
			var plane:Plane = new Plane( new BitmapData(240,196 ) );
			plane.rotation = 270;
			
			var ret:Array = [  [-1, 1, -1, -1],
										[ -1, 1,-1,  1],
										[ 9,  1, 1,  1],
										[ -1, 1,-1, 1],
										[-1,  1,-1,-1] ];
			
			trace( "270 : " + plane.calcValue().toString()  );
			
			Assert.assertTrue(  plane.calcValue().toString() ==  ret.toString() );
		}	

		[Test]
		public function testtoString():void
		{
			var plane:Plane = new Plane( new BitmapData(240,196 ) );
			plane.rotation = 270;
			
			var ret:Array = [  [-1, 1, -1, -1],
				[ -1, 1,-1,  1],
				[ 9,  1, 1,  1],
				[ -1, 1,-1, 1],
				[-1,  1,-1,-1] ];
			trace( plane.toString() );
			Assert.assertTrue(  true );
		}
	}
}