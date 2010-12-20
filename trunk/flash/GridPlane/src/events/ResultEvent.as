package events
{
	import flash.events.Event;
	
	public class ResultEvent extends Event
	{
		public static var EROOR :String = "result error";
		public static var OK	 :String = "1";
		
		public static var SetPlaneOK	 :String = "1";
		public static var GetPlaneOK	 :String = "2";
		
		public static var FriendsOK	 :String = "10";
		
		public var code:String;
		public var msg:*;
		
		public function ResultEvent( type:String, msg:* )
		{
			this.code = type;
			this.msg = msg;
			
			super( type , false, false);
		}
	}
}