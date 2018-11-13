package com.progrestar.games.restorator
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   
   public class Preloader extends Sprite
   {
      
      public static var resPath:String = "";
      
      private static const STAGE_HEIGHT:int = 700;
      
      public static const GAME_VERSION:String = "streetcafe-2.0.0";
      
      private static const STAGE_WIDTH:int = 720;
      
      private static const ASSET_NAMES:Array = ["game_asset","avatar_asset","indoor_asset","outdoor_asset","outdoor_asset2","perk_asset","ingredient_asset","sound_asset"];
      
      private static const SERVER_ARRAY:Array = ["https://app.streets.cafe/"];
       
      
      private var socialNetworkHolder:URLLoader;
      
      private var defaultEngineName:String = "";
      
      private const STATE_INIT:int = 2;
      
      private var assetLoaderInfos:Array;
      
      private const STATE_START:int = 0;
      
      private var loadComplete:Boolean;
      
      private var engineLoaderInfo:LoaderInfo;
      
      private var engine:Object;
      
      private const STATE_LOADING:int = 1;
      
      private var clowds:MovieClip;
      
      private var resHandler:ResourceHandler;
      
      private var state:int = 0;
      
      private var params:Object;
      
      private const STATE_LOADED:int = 5;
      
      private const STATE_ERROR:int = 4;
      
      private const LOADER_VERSION:String = "1.0.0";
      
      private var errorScreen:MovieClip;
      
      private var scene:MovieClip;
      
      private var assetIndex:int = 0;
      
      private var loadingBarStartFrame:int;
      
      private const STATE_ERROR_105:int = 6;
      
      private const STATE_ERROR_106:int = 7;
      
      private const STATE_END:int = 3;
      
      public function Preloader()
      {
         super();
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         instance = this;
         var _loc5_:* = new ContextMenu();
         _loc5_.hideBuiltInItems();
         var _loc6_:* = new ContextMenuItem("© Restaurant Streets  2018");
         _loc5_.customItems.push(_loc6_);
         instance.contextMenu = _loc5_;
         this.defaultEngineName = "";
         this.state = 0;
         this.assetIndex = 0;
         this.params = LoaderInfo(this.loaderInfo).parameters;
         this.params["id"] = "316630";
         this.params["view"] = "canvas";
         this.params["st"] = "2d1188f653de13b06417b1e61aea0460";
         this.params["session_expire"] = "1277885655";
         this.params["is_app_user"] = "1";
         this.params["author"] = "1808456";
         this.params["token"] = "2d1188f653de13b06417b1e61aea0460";
         this.params["window_id"] = "CometName_c33b6edd34647d5b03a2fc8bd5a146ff";
         this.params["referer_type"] = "catalog";
         this.params["app_id"] = "316630";
         this.params["session_key"] = "2d1188f653de13b06417b1e61aea0460";
         this.params["authentication_key"] = "4f0bd401a5f3e8a89b2d63e2a2a0b62a&oid=4681614330894492552";
         this.params["vid"] = "4681614330894492552";
         this.params["ext_perm"] = "notifications,stream,widget";
         _loc1_ = int(this.params["viewer_id"]) % SERVER_ARRAY.length;
         resPath = this.params["res_url"];
         this.defaultEngineName = resPath + "/restorator.swf";
         this.params["res_uid"] = this.params["viewer_id"];
         this.params["res_network"] = "mailru";
         this.params["res_billing_config"] = resPath + "/billing.xml";
         this.params["res_lang"] = "en";
         this.params["res_user_country"] = "us";
         this.params["res_lang_url"] = resPath + "/lang_en.bin";
         this.params["res_res_base_url"] = resPath;
         this.params["res_purchase_base"] = resPath;
         this.params["vk_sig_new_uid"] = this.params["vid"];
         this.params["vk_sig_app_id"] = this.params["api_id"];
         this.params["vk_sig_user_id"] = this.params["user_id"];
         this.params["vk_sig_is_app_user"] = this.params["is_app_user"];
         this.params["vk_sig_api_key"] = this.params["token"];
         this.params["vk_sig_auth_key"] = this.params["auth_key"];
         this.params["res_url"] = this.params["res_url"] + "/rpc/";
         _loc2_ = new URLRequest(this.params["res_url"] + "referer.php");
         _loc2_.method = URLRequestMethod.POST;
         _loc3_ = new URLVariables();
         _loc3_["uid"] = this.params["viewer_id"];
         _loc3_["ref_id"] = this.params["user_id"];
         _loc3_["user_id"] = this.params["user_id"];
         _loc3_["access_token"] = this.params["access_token"];
         _loc3_["auth"] = this.params["auth_key"];
         _loc3_["api_url"] = this.params["api_url"];
         _loc3_["api_id"] = this.params["api_id"];
         _loc2_.data = _loc3_;
         _loc4_ = new URLLoader(_loc2_);
         _loc4_.addEventListener(Event.COMPLETE,defLoaderHandler);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,defErrorHandler);
         this.params["api_key"] = "e4fd5a3eb80b4b7e58123946bfb39999";
         MailruHandler.init("e4fd5a3eb80b4b7e58123946bfb39999",this.params);
         this.assetLoaderInfos = new Array();
         this.resHandler = new ResourceHandler(this.params["res_res_config"],this.params["res_network"]);
         this.resHandler.addEventListener(Event.COMPLETE,this.onResHandlerComplete);
         this.resHandler.addEventListener(IOErrorEvent.IO_ERROR,this.onResHandlerError);
      }
      
      private static function defLoaderHandler(param1:Event) : void
      {
         param1.target.removeEventListener(Event.COMPLETE,defLoaderHandler);
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,defErrorHandler);
      }
      
      private static function defErrorHandler(param1:Event) : void
      {
         param1.target.removeEventListener(Event.COMPLETE,defLoaderHandler);
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,defErrorHandler);
         param1.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,defErrorHandler);
      }
      
      private function loadUserProfileComplete(param1:Event) : void
      {
         var e:Event = null;
         var loc2:* = undefined;
         var event:Event = param1;
         var loc1:* = event;
         e = loc1;
         e.target.removeEventListener(Event.COMPLETE,this.loadUserProfileComplete);
         if(JSON.decode(e.target.data as String).response)
         {
            this.params["userProfile"] = JSON.decode(e.target.data as String).response[0];
            this.loadFriendProfiles();
         }
         else if(JSON.decode(e.target.data as String).error && JSON.decode(e.target.data as String).error.error_code == 6)
         {
            TweenLite.to(this,0.1,{
               "ease":Sine.easeOut,
               "onComplete":function():void
               {
                  loadUserProfile();
               }
            });
         }
         else if(JSON.decode(e.target.data as String).error && JSON.decode(e.target.data as String).error.error_code == 7)
         {
            this.showError("Установка приложения","Если ты хочешь попробовать свои силы в ресторанном бизнесе, то установи приложение на свою страницу.");
         }
      }
      
      private function loadAppFriendProfiles() : void
      {
         this.socialNetworkHolder = MailruHandler.loadAppFriendProfiles();
         this.socialNetworkHolder.addEventListener(Event.COMPLETE,this.loadAppFriendProfilesComplete);
      }
      
      public function showError(param1:String = "", param2:String = "", param3:Function = null) : void
      {
         var _loc4_:* = undefined;
         this.state = -1;
         removeEventListener(Event.ENTER_FRAME,this.tick);
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownListener);
         removeChild(this.scene);
         this.errorScreen.mc_tutorial.mc_content.invite_btn.visible = false;
         if(this.engine && stage.contains(DisplayObject(this.engine)))
         {
            stage.removeChild(DisplayObject(this.engine));
         }
         this.scene = null;
         this.engine = null;
         this.assetIndex = 0;
         this.loadComplete = false;
         this.errorScreen.mc_tutorial.mc_content.tf_title.htmlText = param1;
         this.errorScreen.mc_tutorial.mc_content.tf_body.htmlText = param2;
         _loc4_ = 0;
         _loc4_ = 0;
         while(_loc4_ < this.assetLoaderInfos.length)
         {
            this.assetLoaderInfos[_loc4_].removeEventListener(Event.COMPLETE,this.completeListener);
            this.assetLoaderInfos[_loc4_].removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorListener);
            this.assetLoaderInfos[_loc4_] = null;
            _loc4_ = _loc4_ + 1;
         }
         if(this.engineLoaderInfo)
         {
            this.engineLoaderInfo.removeEventListener(Event.COMPLETE,this.completeListener);
            this.engineLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorListener);
         }
         if(param3 != null)
         {
            this.errorScreen.mc_tutorial.mc_content.tf_body.addEventListener(TextEvent.LINK,param3);
         }
         addChild(this.errorScreen);
      }
      
      private function showInstallBox() : void
      {
         this.showError("Установка приложения","Если ты хочешь попробовать свои силы в ресторанном бизнесе, то установи приложение на свою страницу. <a href=\'event:S\'><font color=\'#2F9AC8\'>Установить!</font></a>",function(param1:TextEvent):void
         {
            trace("App is not installed");
            MailruCall.exec("mailru.app.users.requireInstallation",onInstallClose,["notification"]);
         });
      }
      
      private function loadFriendProfiles() : void
      {
         this.socialNetworkHolder = MailruHandler.loadFriendProfiles();
         this.socialNetworkHolder.addEventListener(Event.COMPLETE,this.loadFriendProfilesComplete);
      }
      
      private function onResHandlerComplete(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         _loc2_ = new LoaderContext(false,ApplicationDomain.currentDomain,SecurityDomain.currentDomain);
         _loc3_ = new Loader();
         _loc3_.load(new URLRequest(this.resHandler.getResUrl("preloader_asset")),_loc2_);
         _loc3_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.initPreloader);
         _loc3_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,defErrorHandler);
         _loc3_.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,defErrorHandler);
      }
      
      private function loadAppFriendProfilesComplete(param1:Event) : void
      {
         var e:Event = null;
         var loc2:* = undefined;
         var event:Event = param1;
         var loc1:* = event;
         e = loc1;
         e.target.removeEventListener(Event.COMPLETE,this.loadAppFriendProfilesComplete);
         if(JSON.decode(e.target.data as String).response)
         {
            this.params["userAppFriends"] = JSON.decode(e.target.data as String).response;
            this.completeListener(null);
         }
         else if(JSON.decode(e.target.data as String).error && JSON.decode(e.target.data as String).error.error_code == 6)
         {
            TweenLite.to(this,0.1,{
               "ease":Sine.easeOut,
               "onComplete":function():void
               {
                  loadAppFriendProfiles();
               }
            });
         }
         else if(JSON.decode(e.target.data as String).error && JSON.decode(e.target.data as String).error.error_code == 7)
         {
            this.showError("",JSON.decode(e.target.data as String).error.error_msg);
         }
         instance = this;
         var _loc_1:* = new ContextMenu();
         _loc_1.hideBuiltInItems();
         var _loc_3:* = new ContextMenuItem("© Restaurant Streets 2018");
         _loc_1.customItems.push(_loc_3);
         instance.contextMenu = _loc_1;
         this.addEventListener(Event.ADDED_TO_STAGE,this.added);
      }
      
      public function added(param1:Event) : void
      {
      }
      
      public function ioErrorListener(param1:Event) : void
      {
         this.scene.error.text = param1.toString();
      }
      
      public function completeListener(param1:Event) : void
      {
         instance = this;
         var _loc2_:* = undefined;
         _loc2_ = this.assetIndex + 1;
         this.assetIndex = _loc2_;
         if(this.assetIndex >= this.assetLoaderInfos.length + 2)
         {
            this.loadComplete = true;
         }
         var _loc3_:* = new ContextMenu();
         _loc3_.hideBuiltInItems();
         var _loc4_:* = new ContextMenuItem("© Restaurant Streets  2018");
         _loc3_.customItems.push(_loc4_);
         instance.contextMenu = _loc3_;
      }
      
      public function onInitError_106(param1:Event) : void
      {
         this.scene.gotoAndPlay("init_complete");
         this.state = this.STATE_ERROR_106;
      }
      
      public function keyDownListener(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 32)
         {
            if(this.scene.version.text.length == 0)
            {
               this.scene.version.text = "Loader: " + this.LOADER_VERSION;
            }
            else
            {
               this.scene.version.text = "";
            }
         }
      }
      
      public function onInitError_105(param1:Event) : void
      {
         this.scene.gotoAndPlay("init_complete");
         this.state = this.STATE_ERROR_105;
      }
      
      private function initPreloader(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = undefined;
         _loc2_ = null;
         _loc3_ = 0;
         _loc4_ = null;
         _loc5_ = null;
         _loc6_ = null;
         _loc7_ = param1;
         this.errorScreen = this.getMovieClip("NetworkError");
         this.errorScreen.x = STAGE_WIDTH / 2;
         this.errorScreen.y = STAGE_HEIGHT / 2;
         this.clowds = this.getMovieClip("Clowds");
         this.clowds.x = STAGE_WIDTH / 2;
         this.clowds.y = 460;
         addChild(this.clowds);
         this.scene = this.getMovieClip("PreloadingScene");
         this.scene.x = STAGE_WIDTH / 2;
         this.scene.y = 250;
         addChild(this.scene);
         this.params["is_app_user"] = "1";
         if(this.params["is_app_user"] != "1")
         {
            this.showInstallBox();
            MailruCall.exec("mailru.app.users.requireInstallation",this.onInstallClose,["notification"]);
            return;
         }
         this.preloaderAssetLoaded(param1);
      }
      
      private function loadFriendProfilesComplete(param1:Event) : void
      {
         var e:Event = null;
         var loc2:* = undefined;
         var event:Event = param1;
         var loc1:* = event;
         e = loc1;
         e.target.removeEventListener(Event.COMPLETE,this.loadFriendProfilesComplete);
         if(JSON.decode(e.target.data as String).response)
         {
            this.params["userFriends"] = JSON.decode(e.target.data as String).response;
            if(this.params["userFriends"])
            {
               if(this.params["userFriends"].length > 0)
               {
                  this.loadAppFriendProfiles();
               }
               else
               {
                  this.showError("No friends","You have no friends in this game.<br/> So you can hire friends to work and be a good restaurateur, you have to invite your friends to the game.");
                  this.show_friends_invite_button();
               }
            }
            else
            {
               this.showError("No friends","You have no friends in this game.<br/> So you can hire friends to work and be a good restaurateur, you have to invite your friends to the game.");
               this.show_friends_invite_button();
            }
         }
         else if(JSON.decode(e.target.data as String).error && JSON.decode(e.target.data as String).error.error_code == 6)
         {
            TweenLite.to(this,0.1,{
               "ease":Sine.easeOut,
               "onComplete":function():void
               {
                  loadFriendProfiles();
               }
            });
         }
         else if(JSON.decode(e.target.data as String).error && JSON.decode(e.target.data as String).error.error_code == 7)
         {
            this.showError("Разрешение действий","Для того, чтобы играть с друзьями, зайди в <font color=\'#2F9AC8\'>Настройки</font> приложения, разреши ему все действия и обнови страницу.");
         }
      }
      
      public function show_friends_invite_button() : void
      {
         this.errorScreen.mc_tutorial.mc_content.invite_btn.visible = true;
         this.errorScreen.mc_tutorial.mc_content.addEventListener(MouseEvent.CLICK,this.invite_friends_dialog);
      }
      
      public function invite_friends_dialog(param1:MouseEvent) : void
      {
         ExternalInterface.call("invite_friends_dialog","");
      }
      
      private function mailruReadyHandler(param1:Object) : void
      {
         trace("Mail.ru API ready");
         this.resHandler = new ResourceHandler(this.params["res_res_config"],this.params["res_network"]);
         this.resHandler.addEventListener(Event.COMPLETE,this.onResHandlerComplete);
         this.resHandler.addEventListener(IOErrorEvent.IO_ERROR,this.onResHandlerError);
      }
      
      private function loadUserProfile() : void
      {
         this.socialNetworkHolder = MailruHandler.loadUserProfile();
         this.socialNetworkHolder.addEventListener(Event.COMPLETE,this.loadUserProfileComplete);
      }
      
      public function tick(param1:Event) : void
      {
         var totalBytes:int = 0;
         var loadedBytes:int = 0;
         var i:int = 0;
         var loadingPercentage:int = 0;
         var e:* = undefined;
         var _loc_1:* = undefined;
         var _loc_3:* = undefined;
         var _loc_1_:* = undefined;
         var _loc_3_:* = undefined;
         var event:Event = param1;
         ;
         ;
         e = event;
         try
         {
            if(this.state == this.STATE_START)
            {
               if(this.scene.currentLabel == "loading")
               {
                  this.loadingBarStartFrame = this.scene.currentFrame;
                  this.state = this.STATE_LOADING;
               }
            }
            else if(this.state == this.STATE_LOADING)
            {
               if(this.loadComplete)
               {
                  this.state = this.STATE_LOADED;
                  this.scene.gotoAndPlay("complete");
               }
            }
            else if(this.state == this.STATE_LOADED)
            {
               if(this.scene.currentLabel == "init")
               {
                  this.state = this.STATE_INIT;
                  this.engine = this.engineLoaderInfo.content;
                  this.engine.resHandler = this.resHandler;
                  this.engine.flashVars = this.params;
                  this.engineLoaderInfo = null;
                  this.engine.addEventListener("init_error",this.onInitError);
                  this.engine.addEventListener("init_error_105",this.onInitError_105);
                  this.engine.addEventListener("init_error_106",this.onInitError_106);
                  this.engine.addEventListener("init_complete",this.onInitComplete);
                  stage.addChild(DisplayObject(this.engine));
                  this.engine.visible = false;
                  _loc_1 = new ContextMenu();
                  _loc_1.hideBuiltInItems();
                  _loc_3 = new ContextMenuItem("© Restaurant Streers  2018");
                  _loc_1.customItems.push(_loc_3);
                  this.engine.contextMenu = _loc_1;
               }
            }
            else if(this.state == this.STATE_INIT)
            {
               if(this.scene.currentLabel == "init_complete")
               {
                  this.scene.gotoAndPlay("init");
               }
            }
            else if(this.state == this.STATE_END)
            {
               if(this.scene.currentFrame == this.scene.totalFrames)
               {
                  this.state = -1;
                  removeEventListener(Event.ENTER_FRAME,this.tick);
                  stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownListener);
                  removeChild(this.scene);
                  removeChild(this.clowds);
                  this.scene = null;
                  this.clowds = null;
                  this.engine.visible = true;
                  this.engine.dispatchEvent(new Event("preload_complete"));
                  this.engine = null;
               }
               instance = this;
               _loc_1_ = new ContextMenu();
               _loc_1_.hideBuiltInItems();
               _loc_3_ = new ContextMenuItem("© Restaurant Streets  2018");
               _loc_1_.customItems.push(_loc_3_);
               instance.contextMenu = _loc_1_;
            }
            else if(this.state == this.STATE_ERROR)
            {
               if(this.scene.currentFrame == this.scene.totalFrames)
               {
                  this.showError("No connection","Unable to connect to the server.<br>Please try again later.<br>If the problem occurs frequently, contact the developers to the game page on Facebook");
               }
            }
            else if(this.state == this.STATE_ERROR_105)
            {
               if(this.scene.currentFrame == this.scene.totalFrames)
               {
                  this.showError("No connection","Unable to connect to the server.<br>Please try again later.<br>If the problem occurs frequently, contact the developers to the game page on Facebook");
               }
            }
            else if(this.state == this.STATE_ERROR_106)
            {
               if(this.scene.currentFrame == this.scene.totalFrames)
               {
                  this.showError("No connection","Unable to connect to the server.<br>Please try again later.<br>If the problem occurs frequently, contact the developers to the game page on Facebook");
               }
            }
            return;
         }
         catch(e:Error)
         {
            scene.error.text = e.toString();
            return;
         }
      }
      
      public function onInitError(param1:Event) : void
      {
         this.scene.gotoAndPlay("init_complete");
         this.state = this.STATE_ERROR;
      }
      
      private function onResHandlerError(param1:IOErrorEvent) : void
      {
         this.showError("No connection","Unable to connect to the server.<br>Please try again later.<br>If the problem occurs frequently, contact the developers to the game page on Facebook");
      }
      
      private function onInstallClose(param1:Object) : void
      {
         var _loc2_:* = undefined;
         if(!param1.status)
         {
            return;
         }
         _loc2_ = param1.status as String;
         trace("API INSTALL RESPONSE: " + param1);
         if(_loc2_ == "success")
         {
            this.state = this.STATE_START;
            this.initPreloader(param1);
         }
      }
      
      public function preloaderAssetLoaded(param1:Object) : void
      {
         var ldrContext:LoaderContext = null;
         var i:int = 0;
         var engineUrl:String = null;
         var loader:Loader = null;
         var request:URLRequest = null;
         var event:* = undefined;
         var e:* = undefined;
         var loc1:* = param1;
         event = loc1;
         e = event;
         try
         {
            ldrContext = new LoaderContext(false,ApplicationDomain.currentDomain,SecurityDomain.currentDomain);
            while(i < ASSET_NAMES.length)
            {
               loader = new Loader();
               request = new URLRequest(this.resHandler.getResUrl(ASSET_NAMES[i]));
               loader.load(request,ldrContext);
               this.assetLoaderInfos[i] = loader.contentLoaderInfo;
               this.assetLoaderInfos[i].addEventListener(Event.COMPLETE,this.completeListener,false,0,true);
               this.assetLoaderInfos[i].addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorListener,false,0,true);
               i = i + 1;
            }
            engineUrl = this.params["res_game_swf_url"];
            if(engineUrl == null)
            {
               engineUrl = this.defaultEngineName;
            }
            loader = new Loader();
            loader.load(new URLRequest(engineUrl),ldrContext);
            this.engineLoaderInfo = loader.contentLoaderInfo;
            this.engineLoaderInfo.addEventListener(Event.COMPLETE,this.completeListener,false,0,true);
            this.engineLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorListener,false,0,true);
            addEventListener(Event.ENTER_FRAME,this.tick);
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownListener);
            this.loadUserProfile();
            return;
         }
         catch(e:Error)
         {
            scene.error.text = e.toString();
            return;
         }
      }
      
      public function onInitComplete(param1:Event) : void
      {
         this.scene.gotoAndPlay("init_complete");
         this.state = this.STATE_END;
      }
      
      public function getMovieClip(param1:String) : MovieClip
      {
         var _loc2_:* = undefined;
         _loc2_ = Class(getDefinitionByName(param1));
         return new _loc2_();
      }
   }
}
