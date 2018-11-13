package com.progrestar.games.restorator
{
   import flash.events.Event;
   import flash.net.URLLoader;
   
   public class ResourceHandler extends URLLoader
   {
       
      
      private var networkResPath:Object;
      
      public var network:String;
      
      private var resPath:Object;
      
      public function ResourceHandler(param1:String, param2:String)
      {
         super(new URLRequest(param1));
         this.addEventListener(Event.COMPLETE,this.onComplete);
         this.network = param2;
      }
      
      public function getResUrl(param1:String) : String
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         _loc2_ = null;
         _loc3_ = this.networkResPath[this.network].src;
         _loc4_ = this.networkResPath[this.network].name;
         _loc5_ = this.resPath[_loc4_];
         _loc6_ = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc2_ = _loc5_[_loc6_];
            if(_loc2_.name == param1 && _loc2_.network == this.network)
            {
               return _loc2_.src;
            }
            _loc6_ = _loc6_ + 1;
         }
         return null;
      }
      
      private function onComplete(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         _loc2_ = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc5_ = null;
         _loc6_ = null;
         _loc7_ = null;
         _loc8_ = null;
         _loc9_ = null;
         _loc10_ = new XML(param1.currentTarget.data);
         _loc11_ = _loc10_.paths;
         _loc12_ = _loc10_.resources;
         this.networkResPath = new Object();
         _loc13_ = 0;
         _loc14_ = _loc11_.path;
         for each(_loc2_ in _loc14_)
         {
            _loc4_ = new Object();
            _loc4_["name"] = _loc2_.attribute("name").toString();
            _loc4_["src"] = _loc2_.attribute("src").toString();
            _loc5_ = _loc2_.attribute("network").toString();
            this.networkResPath[_loc5_] = _loc4_;
         }
         this.resPath = new Object();
         _loc13_ = 0;
         _loc14_ = _loc12_;
         for each(_loc3_ in _loc14_)
         {
            _loc6_ = new Array();
            _loc7_ = _loc3_.attribute("path").toString();
            this.resPath[_loc7_] = _loc6_;
            _loc15_ = 0;
            _loc16_ = _loc3_.resource;
            for each(_loc8_ in _loc16_)
            {
               _loc9_ = new Object();
               _loc9_["name"] = _loc8_.attribute("name").toString();
               _loc9_["network"] = _loc8_.attribute("network").toString();
               _loc9_["src"] = _loc8_.attribute("src").toString();
               _loc6_.push(_loc9_);
            }
         }
      }
   }
}
