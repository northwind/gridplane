package services
{
	import com.adobe.serialization.json.JSON;
	
	import events.ResultEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class ServerService extends EventDispatcher
	{
		public var uid:String = "";
		private var prefix:String = "http://plane.sinaapp.com/staticdata/";
			
		public function getFriends() : void
		{
			var loader:URLLoader = getLoader();
			
			var request:URLRequest = new URLRequest( prefix + "getFriends.json" );
			request.method= "GET";
			
			loader.load( request ); 
		}

		public function setPlane( data:String ) : void
		{
			var loader:URLLoader = getLoader();
			
			var request:URLRequest = new URLRequest( prefix + "setPlane.json" );
			request.method= "POST";
			request.data.data = data;
			
			loader.load( request ); 
		}

		public function getPlane() : void
		{
			var loader:URLLoader = getLoader();
			
			var request:URLRequest = new URLRequest( prefix + "getPlane.json" );
			request.method= "GET";
			request.data.uid = uid;
			
			loader.load( request ); 
		}
		
		private function getLoader():URLLoader
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onCompleteHandler );
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			
			return loader;
		}

		private function onIOErrorHandler( event :IOErrorEvent ):void
		{
			var ret :ResultEvent;
			ret = new ResultEvent( ResultEvent.EROOR, "调用失败" );
			
			this.dispatchEvent( ret );
		}
		
		
		private function onCompleteHandler( event :Event ):void
		{
			var str:String = event.target.data as String;
			
			var ret :ResultEvent;
			try{
				var obj:Object = JSON.decode( str );
				ret = new ResultEvent( obj.code, obj.msg );
			}catch( e:Error ){
				ret = new ResultEvent( ResultEvent.EROOR, "解析错误" );
			}
			
			this.dispatchEvent( ret );
		}
		
		
	}
}