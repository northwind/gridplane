package com.slide.as3.sliso.geom {
	import flash.geom.Point;

	/**
	 * @author ashi
	 */
	public class IsoTransformation {
		public static const Y_CORRECT : Number = Math.cos(-Math.PI / 6) * Math.SQRT2;

		public static function spaceToScreen(point : Point3D) : Point {
			var screenX : Number = point.x - point.z;
			var screenY : Number = point.y * Y_CORRECT + (point.x + point.z) * .5;
			return new Point(screenX, screenY);
		}

		public static function screenToSpace(point : Point) : Point3D {
			var xpos : Number = point.y + (point.x * .5);
			var ypos : Number = 0;
			var zpos : Number = point.y - (point.x * .5);
			return new Point3D(xpos, ypos, zpos);
		}
	}
}
