package  {
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	import scaleform.clik.events.*;
	
	//import some stuff from the valve lib
	import ValveLib.Globals;
	import ValveLib.ResizeManager;

	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	//copied from VotingPanel.as source
	import flash.display.*;
    import flash.filters.*;
    import flash.text.*;
    import scaleform.clik.events.*;
    import vcomponents.*;
	
	public class CG_Timer extends MovieClip {
		
		public var gameAPI:Object;
		public var globals:Object;
		
		public var startTime:Number = -1;
		public var timerDuration:int;
		public var timerMessage:String;
		public var timerEnd:Boolean = false;
		public var timerPosition:int = 0;
		public var timerPaused:Boolean = false;
		public var timer:Timer = null;
		public var timerWarning:Number = -1;
		
		public var xTemp:int;
		public var yTemp:int;
		public var stageWTemp:int;

		public function CG_Timer() {
			// constructor code
		}

		//set initialise this instance's gameAPI
		public function setup(api:Object, globals:Object) {
			this.gameAPI = api;
			this.globals = globals;
			
			// default: play btn is visible, stop button is not
			trace("##Called Timer Setup!");
			this.visible = false;
			
			this.timeMessage.text = Globals.instance.GameInterface.Translate("#TimerTitle");
			
			this.gameAPI.SubscribeToGameEvent("cgm_timer_display", this.onTimerUpdate);
			this.gameAPI.SubscribeToGameEvent("cgm_timer_pause", this.onTimerPaused);
			
			trace("## Called Timer Setup Completed!");
		}
		
		//On UI unload, we need to kill the timer
		public function kill() : void {
			trace("Timer: Killing timer");
			if ( this.timer != null) {
				this.timer.stop();
				this.timer = null;
				trace("Timer: Timer Killed!");
			}
		}
		
		//onScreenResize
		public function screenResize(stageW:int, stageH:int, xScale:Number, yScale:Number, wide:Boolean){
			
			trace("Stage Size: ",stageW,stageH);
			
			this.x = (stageW/2 + 180)*yScale*0.8;
			this.y = 95*yScale*0.8;
			
			this.xTemp = this.x;
			this.yTemp = this.y;
			this.stageWTemp = stageW;
			
			trace("#Result Resize: ",this.x,this.y,yScale);

			this.width = this.width*yScale;
			this.height	 = this.height*yScale;
			
			//Now we just set the scale of this element, because these parameters are already the inverse ratios
			this.scaleX = xScale*0.8;
			this.scaleY = yScale*0.8;
			
			trace("#ScoreBoard Panel Resize");			
		}
		
		public function updateCounter(e:TimerEvent) :void{
			// Check if object still exist in ui.
			if ( this.timeRemaining == null ) {
				kill()
				return;
			}
				
			if (Globals.instance.Loader_overlay.movieClip.dota_paused.visible || this.timerPaused)
				this.startTime += .1;		
			
			var time:Number =  Globals.instance.Game.Time() - this.startTime;
			var remaining:Number = Math.ceil(this.timerDuration - time);
			
			if (remaining <= (this.timerWarning) && this.timerWarning != -1)
				this.timeRemaining.textColor = 0xDF161F;
			else
				this.timeRemaining.textColor = 0xFFFFFF;
				
			if (remaining >= 0)
				this.timeRemaining.text = getTime(remaining);
			
			if (time >= this.timerDuration){
				this.timer.stop();
				this.timer = null;
				if (!this.timerEnd){
					var t:Timer = new Timer(1000,1);
					t.addEventListener(TimerEvent.TIMER, fadeOut);
					t.start();
				}
			}
		}
		
		public function fadeIn():void{
			this.y -= 100;
			var t:Timer = new Timer(25,10);
			t.addEventListener(TimerEvent.TIMER, incrementFadeIn);
			t.start();
		}
		
		public function incrementFadeIn(e:TimerEvent) :void{
			this.y += 10;
		}
		
		public function fadeOut():void{
			var t:Timer = new Timer(25,10);
			t.addEventListener(TimerEvent.TIMER, incrementFadeOut);
			t.start();
		}
		
		public function incrementFadeOut(e:TimerEvent) :void{
			this.y -= 10;
			if (this.y < 20){
				this.visible = false;
				this.y += 100;
			}
		}
		
		public function getTime(seconds:int) : String{
			var timeString:String;
			var seconds:int;
			var s:String = "";
			var minutes:int;
			var m:String = "";
			var hours:int;
			var h:String = "";
			hours = seconds / 3600;
			var remainder:int = seconds % 3600;
			minutes = remainder / 60;
			seconds = remainder % 60;
			if (seconds < 10){
				s = "0";
			}
			if (minutes < 10){
				m = "0";
			}
			if (hours < 10){
				h = "0";
			}
			timeString = h + hours + ":" + m + minutes + ":" + s + seconds;
			return timeString;
		}
		
		//onTimerPaused
		public function onTimerPaused(args:Object) : void{
			if (args.timePaused != null)
				this.timerPaused = args.timePaused;
		}
		
		//onTimerUpdate
		public function onTimerUpdate(args:Object) : void{
			if (args.timerMsg != "") {
				this.timeMessage.htmlText = Globals.instance.GameInterface.Translate(args.timerMsg);
				this.timerMessage = args.timerMsg;
			}
			this.timeRemaining.text = getTime(args.timerSeconds);
			this.timerDuration = args.timerSeconds;			
			if (args.timerEnd != null)
				this.timerEnd = args.timerEnd;
			if (args.timerWarning != null)
				this.timerWarning = args.timerWarning;
			if (args.timerSeconds <= args.timerWarning && args.timerWarning != -1)
				this.timeRemaining.textColor = 0xDF161F;
			else
				this.timeRemaining.textColor = 0xFFFFFF;
			if (args.timerPosition != null) {
				this.timerPosition = args.timerPosition;
				if (this.timerPosition == 0) {
					this.x = this.xTemp;
					this.y = this.yTemp;
				}
				if (this.timerPosition == 1) {
					this.x = 20 + this.width/2;
					this.y = this.yTemp - 15;
				}
				if (this.timerPosition == 2) {
					this.x = this.stageWTemp - this.width/2 - 15;
					this.y = this.yTemp - 15;
				}
				if (this.timerPosition == 4) {
					this.x = this.xTemp;
					this.y = this.yTemp - 15;
				}
			}
			if (!this.visible){
				fadeIn();
			}
			
			if ( this.timer != null) {
				this.timer.stop();
				this.timer = null;
			}
			this.startTime = Globals.instance.Game.Time();
			this.timer = new Timer(100);
			this.timer.addEventListener(TimerEvent.TIMER, updateCounter);
			this.timer.start();
			this.visible = true;
		}
	}
}
