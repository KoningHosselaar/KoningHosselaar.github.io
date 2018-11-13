package com.progrestar.games.restorator
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   
   public dynamic class MailruHandler extends EventDispatcher
   {
      
      public static var photo_queue:Array = new Array();
      
      public static var params:Object;
      
      private static var apiLoader:URLLoader;
      
      private static var apiRequest:URLRequest;
      
      private static var key:String;
      
      public static var current_photo_queue:Array = new Array();
      
      public static var all_photos:Array = new Array();
      
      private static var inited:Boolean = false;
      
      public static var userObject:Object = new Object();
      
      private static var apiVariables:URLVariables;
      
      {
         inited = false;
      }
      
      public function MailruHandler()
      {
         super();
      }
      
      private static function defErrorHandler(param1:Event) : void
      {
         var _loc2_:* = undefined;
         _loc2_.target.removeEventListener(Event.COMPLETE,defLoaderHandler);
         _loc2_.target.removeEventListener(IOErrorEvent.IO_ERROR,defErrorHandler);
      }
      
      public static function init(param1:String, param2:Object) : void
      {
         if(inited)
         {
            return;
         }
         key = param1;
         params = param2;
         inited = true;
      }
      
      public static function loadBalance() : URLLoader
      {
         apiRequest = new URLRequest(params["res_res_base_url"] + "/old/api");
         apiRequest.method = URLRequestMethod.POST;
         apiVariables = new URLVariables();
         apiVariables["api_id"] = params["api_id"];
         apiVariables["format"] = "JSON";
         apiVariables["method"] = "getUserBalance";
         apiVariables["v"] = "2.0";
         apiVariables["sig"] = MD5.hash(params["viewer_id"] + "api_id=" + params["api_id"] + "format=JSONmethod=getUserBalancev=2.0" + key);
         apiRequest.data = apiVariables;
         apiLoader = new URLLoader(apiRequest);
         apiLoader.addEventListener(Event.COMPLETE,defLoaderHandler);
         apiLoader.addEventListener(IOErrorEvent.IO_ERROR,defErrorHandler);
         return apiLoader;
      }
      
      public static function loadUserProfile() : URLLoader
      {
         apiRequest = new URLRequest(params["res_res_base_url"] + "/rpc/getUser.php");
         apiRequest.method = URLRequestMethod.POST;
         apiVariables = new URLVariables();
         apiVariables["user_id"] = params["user_id"];
         apiVariables["access_token"] = params["access_token"];
         apiRequest.data = apiVariables;
         apiLoader = new URLLoader(apiRequest);
         apiLoader.addEventListener(Event.COMPLETE,defLoaderHandler);
         apiLoader.addEventListener(IOErrorEvent.IO_ERROR,defErrorHandler);
         return apiLoader;
      }
      
      public static function loadUserProfiles(param1:Array, param2:String = "uid,first_name,last_name,nickname,sex,bdate,city,country,timezone,photo,photo_medium,photo_big") : URLLoader
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         _loc4_ = null;
         _loc3_ = "";
         if(param1 as Array)
         {
            _loc5_ = 0;
            _loc6_ = param1;
            for(_loc4_ in _loc6_)
            {
               _loc3_ = !!(_loc3_ + _loc3_)?",":"" + param1[_loc4_];
            }
         }
         apiRequest = new URLRequest(params["res_res_base_url"] + "/old/api");
         apiRequest.method = URLRequestMethod.POST;
         apiVariables = new URLVariables();
         apiVariables["api_id"] = params["api_id"];
         apiVariables["fields"] = param2;
         apiVariables["format"] = "JSON";
         apiVariables["method"] = "getProfiles";
         apiVariables["uids"] = _loc3_;
         apiVariables["v"] = "2.0";
         apiVariables["sig"] = MD5.hash(params["viewer_id"] + "api_id=" + params["api_id"] + "fields=" + param2 + "format=JSONmethod=getProfilesuids=" + _loc3_ + "v=2.0" + key);
         apiRequest.data = apiVariables;
         apiLoader = new URLLoader(apiRequest);
         apiLoader.addEventListener(Event.COMPLETE,defLoaderHandler);
         apiLoader.addEventListener(IOErrorEvent.IO_ERROR,defErrorHandler);
         return apiLoader;
      }
      
      public static function loadAppFriendProfiles() : URLLoader
      {
         apiRequest = new URLRequest(params["res_res_base_url"] + "/rpc/getFriends.php");
         apiRequest.method = URLRequestMethod.POST;
         apiVariables = new URLVariables();
         apiVariables["user_id"] = params["user_id"];
         apiVariables["access_token"] = params["access_token"];
         apiRequest.data = apiVariables;
         apiLoader = new URLLoader(apiRequest);
         apiLoader.addEventListener(Event.COMPLETE,defLoaderHandler);
         apiLoader.addEventListener(IOErrorEvent.IO_ERROR,defErrorHandler);
         return apiLoader;
      }
      
      public static function loadFriendProfiles() : URLLoader
      {
         apiRequest = new URLRequest(params["res_res_base_url"] + "/rpc/getFriends.php");
         apiRequest.method = URLRequestMethod.POST;
         apiVariables = new URLVariables();
         apiVariables["user_id"] = params["user_id"];
         apiVariables["access_token"] = params["access_token"];
         apiVariables["viewer_id"] = params["user_id"];
         apiRequest.data = apiVariables;
         apiLoader = new URLLoader(apiRequest);
         apiLoader.addEventListener(Event.COMPLETE,defLoaderHandler);
         apiLoader.addEventListener(IOErrorEvent.IO_ERROR,defErrorHandler);
         return apiLoader;
      }
      
      private static function defLoaderHandler(param1:Event) : void
      {
         param1.target.removeEventListener(Event.COMPLETE,defLoaderHandler);
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,defErrorHandler);
      }
      
      public static function loadServerTime() : URLLoader
      {
         apiRequest = new URLRequest(params["res_res_base_url"] + "/old/api");
         apiRequest.method = URLRequestMethod.POST;
         apiVariables = new URLVariables();
         apiVariables["api_id"] = params["api_id"];
         apiVariables["format"] = "JSON";
         apiVariables["method"] = "getServerTime";
         apiVariables["v"] = "2.0";
         apiVariables["sig"] = MD5.hash(params["viewer_id"] + "api_id=" + params["api_id"] + "format=JSONmethod=getServerTimev=2.0" + key);
         apiRequest.data = apiVariables;
         apiLoader = new URLLoader(apiRequest);
         apiLoader.addEventListener(Event.COMPLETE,defLoaderHandler);
         apiLoader.addEventListener(IOErrorEvent.IO_ERROR,defErrorHandler);
         return apiLoader;
      }
   }
}
