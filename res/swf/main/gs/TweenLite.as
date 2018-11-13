package gs
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class TweenLite
   {
      
      private static var _timer:Timer = new Timer(2000);
      
      private static var _classInitted:Boolean;
      
      public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
      
      public static var defaultEase:Function = TweenLite.easeOut;
      
      public static var version:Number = 8.16;
      
      private static var _sprite:Sprite = new Sprite();
      
      static var _all:Dictionary = new Dictionary();
      
      static var _curTime:uint;
      
      public static var overwriteManager:Object;
      
      private static var _listening:Boolean;
      
      {
         version = 8.16;
      }
      
      public var delay:Number;
      
      protected var _hasUpdate:Boolean;
      
      protected var _subTweens:Array;
      
      protected var _hst:Boolean;
      
      protected var _initted:Boolean;
      
      public var target:Object;
      
      public var duration:Number;
      
      protected var _isDisplayObject:Boolean;
      
      protected var _active:Boolean;
      
      public var startTime:int;
      
      public var vars:Object;
      
      public var tweens:Array;
      
      public var initTime:int;
      
      protected var _timeScale:Number;
      
      public function TweenLite(param1:Object, param2:Number, param3:Object)
      {
         super();
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         _loc5_ = undefined;
         if(param1 == null)
         {
            return;
         }
         if(!_classInitted)
         {
            _curTime = getTimer();
            _sprite.addEventListener(Event.ENTER_FRAME,executeAll);
            if(overwriteManager == null)
            {
               overwriteManager = {
                  "mode":1,
                  "enabled":false
               };
            }
            _classInitted = true;
         }
         this.vars = param3;
         this.duration = Number(param2) || Number(0.001);
         this.delay = Number(param3.delay) || Number(0);
         this._timeScale = Number(param3.timeScale) || Number(1);
         this._active = param2 == 0 && this.delay == 0;
         this.target = param1;
         this._isDisplayObject = param1 as DisplayObject;
         if(!(this.vars.ease as Function))
         {
            this.vars.ease = defaultEase;
         }
         if(this.vars.easeParams != null)
         {
            this.vars.proxiedEase = this.vars.ease;
            this.vars.ease = this.easeProxy;
         }
         if(!isNaN(Number(this.vars.autoAlpha)))
         {
            this.vars.alpha = Number(this.vars.autoAlpha);
            this.vars.visible = this.vars.alpha > 0;
         }
         this.tweens = [];
         this._subTweens = [];
         var _loc7_:* = false;
         _loc6_ = false;
         this._initted = _loc7_;
         this._hst = _loc6_;
         this.initTime = _curTime;
         this.startTime = this.initTime + this.delay * 1000;
         _loc4_ = param3.overwrite == undefined || !overwriteManager.enabled && param3.overwrite > 1?overwriteManager.mode:int(param3.overwrite);
         if(_all[param1] == undefined || param1 != null && _loc4_ == 1)
         {
            delete _all[param1];
            _all[param1] = new Dictionary(true);
         }
         else if(_loc4_ > 1 && this.delay == 0)
         {
            overwriteManager.manageOverwrites(this,_all[param1]);
         }
         _all[param1][this] = this;
         if(this.vars.runBackwards == true && this.vars.renderOnStart != true || this._active)
         {
            this.initTweenVals();
            if(this._active)
            {
               this.render(this.startTime + 1);
            }
            else
            {
               this.render(this.startTime);
            }
            _loc5_ = this.vars.visible;
            if(this.vars.isTV == true)
            {
               _loc5_ = this.vars.exposedProps.visible;
            }
            if(_loc5_ != null && this.vars.runBackwards == true && this._isDisplayObject)
            {
               this.target.visible = Boolean(_loc5_);
            }
         }
         if(!_listening && !this._active)
         {
            _timer.addEventListener("timer",killGarbage);
            _timer.start();
            _listening = true;
         }
      }
      
      public static function easeOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         var _loc5_:* = undefined;
         var _loc6_:* = param1 / param4;
         _loc5_ = param1 / param4;
         param1 = _loc6_;
         return -param3 * _loc5_ * (param1 - 2) + param2;
      }
      
      public static function frameProxy(param1:Object) : void
      {
         var _loc2_:* = undefined;
         _loc2_.info.target.gotoAndStop(Math.round(_loc2_.target.frame));
      }
      
      public static function removeTween(param1:TweenLite = null) : void
      {
         var _loc2_:* = undefined;
         if(_loc2_ != null && _all[_loc2_.target] != undefined)
         {
            _all[_loc2_.target][_loc2_] = null;
            delete _all[_loc2_.target][_loc2_];
         }
      }
      
      public static function killTweensOf(param1:Object = null, param2:Boolean = false) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         _loc3_ = null;
         _loc4_ = undefined;
         if(param1 != null && _all[param1] != undefined)
         {
            if(param2)
            {
               _loc3_ = _all[param1];
               _loc5_ = 0;
               _loc6_ = _loc3_;
               for(_loc4_ in _loc6_)
               {
                  _loc3_[_loc4_].complete(false);
               }
            }
            delete _all[param1];
         }
      }
      
      public static function delayedCall(param1:Number, param2:Function, param3:Array = null) : TweenLite
      {
         return new TweenLite(param2,0,{
            "delay":param1,
            "onComplete":param2,
            "onCompleteParams":param3,
            "overwrite":0
         });
      }
      
      public static function from(param1:Object, param2:Number, param3:Object) : TweenLite
      {
         param3.runBackwards = true;
         return new TweenLite(param1,param2,param3);
      }
      
      public static function executeAll(param1:Event = null) : void
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
         _loc4_ = null;
         _loc5_ = null;
         _loc6_ = null;
         var _loc11_:* = getTimer();
         _loc7_ = getTimer();
         _curTime = _loc11_;
         _loc3_ = _loc7_;
         if(_listening)
         {
            _loc4_ = _all;
            _loc7_ = 0;
            _loc8_ = _loc4_;
            for each(_loc5_ in _loc8_)
            {
               _loc9_ = 0;
               _loc10_ = _loc5_;
               for(_loc6_ in _loc10_)
               {
                  if(_loc5_[_loc6_] != undefined && _loc5_[_loc6_].active)
                  {
                     _loc5_[_loc6_].render(_loc3_);
                  }
               }
            }
         }
      }
      
      public static function tintProxy(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         _loc3_ = _loc2_.target.progress;
         _loc4_ = 1 - _loc3_;
         _loc5_ = _loc2_.info.color;
         _loc6_ = _loc2_.info.endColor;
         _loc2_.info.target.transform.colorTransform = new ColorTransform(_loc5_.redMultiplier * _loc4_ + _loc6_.redMultiplier * _loc3_,_loc5_.greenMultiplier * _loc4_ + _loc6_.greenMultiplier * _loc3_,_loc5_.blueMultiplier * _loc4_ + _loc6_.blueMultiplier * _loc3_,_loc5_.alphaMultiplier * _loc4_ + _loc6_.alphaMultiplier * _loc3_,_loc5_.redOffset * _loc4_ + _loc6_.redOffset * _loc3_,_loc5_.greenOffset * _loc4_ + _loc6_.greenOffset * _loc3_,_loc5_.blueOffset * _loc4_ + _loc6_.blueOffset * _loc3_,_loc5_.alphaOffset * _loc4_ + _loc6_.alphaOffset * _loc3_);
      }
      
      public static function volumeProxy(param1:Object) : void
      {
         var _loc2_:* = undefined;
         _loc2_.info.target.soundTransform = _loc2_.target;
      }
      
      public static function killGarbage(param1:TimerEvent) : void
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
         _loc4_ = false;
         _loc5_ = null;
         _loc6_ = null;
         _loc7_ = null;
         _loc3_ = 0;
         _loc8_ = 0;
         _loc9_ = _all;
         for(_loc5_ in _loc9_)
         {
            _loc4_ = false;
            _loc10_ = 0;
            _loc11_ = _all[_loc5_];
            for(_loc6_ in _loc11_)
            {
               _loc4_ = true;
            }
            if(!_loc4_)
            {
               delete _all[_loc5_];
            }
            else
            {
               _loc3_ = _loc3_ + 1;
            }
         }
         if(_loc3_ == 0)
         {
            _timer.removeEventListener("timer",killGarbage);
            _timer.stop();
            _listening = false;
         }
      }
      
      public static function to(param1:Object, param2:Number, param3:Object) : TweenLite
      {
         return new TweenLite(param1,param2,param3);
      }
      
      public function get active() : Boolean
      {
         if(this._active)
         {
            return true;
         }
         if(_curTime >= this.startTime)
         {
            this._active = true;
            if(this._initted)
            {
               if(this.vars.visible != undefined && this._isDisplayObject)
               {
                  this.target.visible = true;
               }
            }
            else
            {
               this.initTweenVals();
            }
            if(this.vars.onStart != null)
            {
               this.vars.onStart.apply(null,this.vars.onStartParams);
            }
            if(this.duration == 0.001)
            {
               this.startTime - 1;
            }
            return true;
         }
         return false;
      }
      
      protected function addSubTween(param1:String, param2:Function, param3:Object, param4:Object, param5:Object = null) : void
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         _loc7_ = null;
         _loc6_ = {
            "name":param1,
            "proxy":param2,
            "target":param3,
            "info":param5
         };
         this._subTweens[this._subTweens.length] = _loc6_;
         _loc8_ = 0;
         _loc9_ = param4;
         for(_loc7_ in _loc9_)
         {
            if(typeof param4[_loc7_] == "number")
            {
               this.tweens[this.tweens.length] = {
                  "o":param3,
                  "p":_loc7_,
                  "s":param3[_loc7_],
                  "c":param4[_loc7_] - param3[_loc7_],
                  "sub":_loc6_,
                  "name":param1
               };
            }
            else
            {
               this.tweens[this.tweens.length] = {
                  "o":param3,
                  "p":_loc7_,
                  "s":param3[_loc7_],
                  "c":Number(param4[_loc7_]),
                  "sub":_loc6_,
                  "name":param1
               };
            }
         }
         this._hst = true;
      }
      
      public function initTweenVals(param1:Boolean = false, param2:String = "") : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         _loc3_ = null;
         _loc4_ = 0;
         _loc6_ = null;
         _loc7_ = null;
         _loc8_ = null;
         _loc9_ = null;
         _loc5_ = this.vars;
         if(_loc5_.isTV == true)
         {
            _loc5_ = _loc5_.exposedProps;
         }
         if(!param1 && this.delay != 0 && overwriteManager.enabled)
         {
            overwriteManager.manageOverwrites(this,_all[this.target]);
         }
         if(this.target as Array)
         {
            _loc6_ = this.vars.endArray || [];
            _loc4_ = 0;
            while(_loc4_ < _loc6_.length)
            {
               if(this.target[_loc4_] != _loc6_[_loc4_] && this.target[_loc4_] != undefined)
               {
                  this.tweens[this.tweens.length] = {
                     "o":this.target,
                     "p":_loc4_.toString(),
                     "s":this.target[_loc4_],
                     "c":_loc6_[_loc4_] - this.target[_loc4_],
                     "name":_loc4_.toString()
                  };
               }
               _loc4_ = _loc4_ + 1;
            }
         }
         else
         {
            if((typeof _loc5_.tint != "undefined" || this.vars.removeTint == true) && this._isDisplayObject)
            {
               _loc7_ = this.target.transform.colorTransform;
               _loc8_ = new ColorTransform();
               if(_loc5_.alpha == undefined)
               {
                  _loc8_.alphaMultiplier = this.target.alpha;
               }
               else
               {
                  _loc8_.alphaMultiplier = _loc5_.alpha;
                  delete _loc5_.alpha;
               }
               if(this.vars.removeTint != true && (_loc5_.tint != null && _loc5_.tint != "" || _loc5_.tint == 0))
               {
                  _loc8_.color = _loc5_.tint;
               }
               this.addSubTween("tint",tintProxy,{"progress":0},{"progress":1},{
                  "target":this.target,
                  "color":_loc7_,
                  "endColor":_loc8_
               });
            }
            if(_loc5_.frame != null && this._isDisplayObject)
            {
               this.addSubTween("frame",frameProxy,{"frame":this.target.currentFrame},{"frame":_loc5_.frame},{"target":this.target});
            }
            if(!isNaN(this.vars.volume) && this.target.hasOwnProperty("soundTransform"))
            {
               this.addSubTween("volume",volumeProxy,this.target.soundTransform,{"volume":this.vars.volume},{"target":this.target});
            }
            _loc10_ = 0;
            _loc11_ = _loc5_;
            for(_loc3_ in _loc11_)
            {
               if(!(_loc3_ == "ease" || _loc3_ == "delay" || _loc3_ == "overwrite" || _loc3_ == "onComplete" || _loc3_ == "onCompleteParams" || _loc3_ == "runBackwards" || _loc3_ == "visible" || _loc3_ == "autoOverwrite" || _loc3_ == "persist" || _loc3_ == "onUpdate" || _loc3_ == "onUpdateParams" || _loc3_ == "autoAlpha" || _loc3_ == "timeScale" && !(this.target as TweenLite) || _loc3_ == "onStart" || _loc3_ == "onStartParams" || _loc3_ == "renderOnStart" || _loc3_ == "proxiedEase" || _loc3_ == "easeParams" || param1 && param2.indexOf(" " + _loc3_ + " ") != -1))
               {
                  if(!(this._isDisplayObject && (_loc3_ == "tint" || _loc3_ == "removeTint" || _loc3_ == "frame")) && !(_loc3_ == "volume" && this.target.hasOwnProperty("soundTransform")))
                  {
                     if(typeof _loc5_[_loc3_] == "number")
                     {
                        this.tweens[this.tweens.length] = {
                           "o":this.target,
                           "p":_loc3_,
                           "s":this.target[_loc3_],
                           "c":_loc5_[_loc3_] - this.target[_loc3_],
                           "name":_loc3_
                        };
                     }
                     else
                     {
                        this.tweens[this.tweens.length] = {
                           "o":this.target,
                           "p":_loc3_,
                           "s":this.target[_loc3_],
                           "c":Number(_loc5_[_loc3_]),
                           "name":_loc3_
                        };
                     }
                  }
               }
            }
         }
         if(this.vars.runBackwards == true)
         {
            _loc4_ = this.tweens.length - 1;
            while(_loc4_ > -1)
            {
               _loc9_ = this.tweens[_loc4_];
               this.tweens[_loc4_].s = _loc9_.s + _loc9_.c;
               _loc9_.c = _loc9_.c * -1;
               _loc4_--;
            }
         }
         if(_loc5_.visible == true && this._isDisplayObject)
         {
            this.target.visible = true;
         }
         if(this.vars.onUpdate != null)
         {
            this._hasUpdate = true;
         }
         this._initted = true;
      }
      
      public function render(param1:uint) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         _loc4_ = NaN;
         _loc5_ = null;
         _loc6_ = 0;
         _loc3_ = (_loc2_ - this.startTime) / 1000;
         if(_loc3_ >= this.duration)
         {
            _loc3_ = this.duration;
            _loc4_ = 1;
         }
         else
         {
            _loc4_ = this.vars.ease(_loc3_,0,1,this.duration);
         }
         _loc6_ = this.tweens.length - 1;
         while(_loc6_ > -1)
         {
            _loc5_ = this.tweens[_loc6_];
            _loc5_.o[_loc5_.p] = _loc5_.s + _loc4_ * _loc5_.c;
            _loc6_--;
         }
         if(this._hst)
         {
            _loc6_ = this._subTweens.length - 1;
            while(_loc6_ > -1)
            {
               this._subTweens[_loc6_].proxy(this._subTweens[_loc6_]);
               _loc6_--;
            }
         }
         if(this._hasUpdate)
         {
            this.vars.onUpdate.apply(null,this.vars.onUpdateParams);
         }
         if(_loc3_ == this.duration)
         {
            this.complete(true);
         }
      }
      
      protected function easeProxy(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return this.vars.proxiedEase.apply(null,arguments.concat(this.vars.easeParams));
      }
      
      public function killVars(param1:Object) : void
      {
         var _loc2_:* = undefined;
         if(overwriteManager.enabled)
         {
            overwriteManager.killVars(_loc2_,this.vars,this.tweens,this._subTweens,[]);
         }
      }
      
      public function complete(param1:Boolean = false) : void
      {
         var _loc2_:* = undefined;
         if(!_loc2_)
         {
            if(!this._initted)
            {
               this.initTweenVals();
            }
            this.startTime = _curTime - this.duration * 1000 / this._timeScale;
            this.render(_curTime);
            return;
         }
         if(this.vars.visible != undefined && this._isDisplayObject)
         {
            if(!isNaN(this.vars.autoAlpha) && this.target.alpha == 0)
            {
               this.target.visible = false;
            }
            else if(this.vars.runBackwards != true)
            {
               this.target.visible = this.vars.visible;
            }
         }
         if(this.vars.persist != true)
         {
            removeTween(this);
         }
         if(this.vars.onComplete != null)
         {
            this.vars.onComplete.apply(null,this.vars.onCompleteParams);
         }
      }
   }
}
