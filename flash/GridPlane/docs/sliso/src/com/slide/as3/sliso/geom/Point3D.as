package com.slide.as3.sliso.geom {
	import flash.geom.Point;

	/**
	 * @author ashi
	 */
	public class Point3D extends Point{
		
		static public function distance (ptA:Point3D, ptB:Point3D):Number
		{
			var tx:Number = ptB.x - ptA.x;
			var ty:Number = ptB.y - ptA.y;
			var tz:Number = ptB.z - ptA.z;
			
			return Math.sqrt(tx * tx + ty * ty + tz * tz);
		}
		
		static public function theta (ptA:Point3D, ptB:Point3D):Number
		{
			var tx:Number = ptB.x - ptA.x;
			var ty:Number = ptB.y - ptA.y;
			
			var radians:Number = Math.atan(ty / tx);
			if (tx < 0)
				radians += Math.PI;
			
			if (tx >= 0 && ty < 0)
				radians += Math.PI * 2;
				
			return radians;
		}
		
		static public function angle (ptA:Point3D, ptB:Point3D):Number
		{
			return theta(ptA, ptB) * 180 / Math.PI;
		}
		
		static public function polar (originPt:Point3D, radius:Number, theta:Number = 0):Point3D
		{
			var tx:Number = originPt.x + Math.cos(theta) * radius;
			var ty:Number = originPt.y + Math.sin(theta) * radius;
			var tz:Number = originPt.z;
			
			return new Point3D(tx, ty, tz);
		}
		
		static public function interpolate (ptA:Point3D, ptB:Point3D, f:Number):Point3D
		{
			if (f <= 0)
				return ptA;
				
			if (f >= 1)
				return ptB;
				
			var nx:Number = (ptB.x - ptA.x) * f + ptA.x;	
			var ny:Number = (ptB.y - ptA.y) * f + ptA.y;	
			var nz:Number = (ptB.z - ptA.z) * f + ptA.z;
			
			return new Point3D(nx, ny, nz);
		}
		
		public var z:Number = 0;
		
		override public function get length ():Number
		{
			return Math.sqrt(x * x + y * y + z * z);
		}
		
		override public function clone ():Point
		{
			return new Point3D(x, y, z);
		}
		
		public function Point3D (x:Number = 0, y:Number = 0, z:Number = 0)
		{
			super();
			
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		override public function toString ():String
		{
			return "x:" + x + " y:" + y + " z:" + z;
		}
	}
}
