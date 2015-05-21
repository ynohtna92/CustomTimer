// Credits to Noya for a lot of this Flash code, from his mod Courier Madness.
// Also Credits to Perry for abundant Flash info.

package {
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
	
	public class Timer_Module extends MovieClip{
		
		//these three variables are required by the engine
		public var gameAPI:Object;
		public var globals:Object;
		public var elementName:String;
		
		private var ScreenWidth:int;
		private var ScreenHeight:int;
		public var scaleRatioY:Number;

		private var MouseStreamCheckbox:Object;
		
		//constructor, you usually will use onLoaded() instead
		public function Timer_Module() : void {
	
		}
		
		//this function is called when the UI is loaded
		public function onLoaded() : void {		
			//make this UI visible
			visible = true;
			
			//let the client rescale the UI
			Globals.instance.resizeManager.AddListener(this);

			this.timer.setup(this.gameAPI, this.globals);
			
			trace("## Custom UI loaded!");
		}
		
		public function onMouseStreamChecked(event:ButtonEvent) {
			trace("onMouseStreamChecked");
			this.gameAPI.SendServerCommand("MouseStreamToggle");

			// color resets, so we have to set it again.
			resetMouseStreamText();
		}

		private function resetMouseStreamText() : void
		{
			MouseStreamCheckbox.textField.textColor = 0xFFC800;
			// make the text bigger
			var format:TextFormat = new TextFormat();
			format.size = 16;
			MouseStreamCheckbox.textField.defaultTextFormat = format;
			MouseStreamCheckbox.textField.setTextFormat(format);
		}

		//Parameters: 
		//	mc - The movieclip to replace
		//	type - The name of the class you want to replace with
		//	keepDimensions - Resize from default dimensions to the dimensions of mc (optional, false by default)
		public function replaceWithValveComponent(mc:MovieClip, type:String, keepDimensions:Boolean = false) : MovieClip {
			var parent = mc.parent;
			var oldx = mc.x;
			var oldy = mc.y;
			var oldwidth = mc.width;
			var oldheight = mc.height;
			
			var newObjectClass = getDefinitionByName(type);
			var newObject = new newObjectClass();
			newObject.x = oldx;
			newObject.y = oldy;
			if (keepDimensions) {
				newObject.width = oldwidth;
				newObject.height = oldheight;
			}
			
			parent.removeChild(mc); 
			parent.addChild(newObject);
			
			return newObject;
		}

		public function onResize(re:ResizeManager) : * {
			
			// calculate by what ratio the stage is scaling
			scaleRatioY = re.ScreenHeight/1080;
			
			trace("##### RESIZE #########");
					
			ScreenWidth = re.ScreenWidth;
			ScreenHeight = re.ScreenHeight;
					
			//pass the resize event to our module, we pass the width and height of the screen, as well as the INVERSE of the stage scaling ratios.
			this.timer.screenResize(re.ScreenWidth, re.ScreenHeight, scaleRatioY, scaleRatioY, re.IsWidescreen());
		}
	}
}