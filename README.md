# CustomTimer
A Flash Module for custom timers in Dota 2

<p align="center">
  <img src="https://raw.githubusercontent.com/ynohtna92/CustomTimer/master/src/CustomTimerPreview.PNG"/>
</p>

[GFY Preview](https://gfycat.com/OfficialCautiousCaimanlizard)

Usage
-----
Places the flash3 and script files in the correct location in your custom game directory.

In lua use  
````lua
FireGameEvent('cgm_timer_display', { timerMsg = "Remaining", timerSeconds = 10, timerWarning = 10, timerEnd = true, timerPosition = 0})
````
**Where:**
- timerMsg (String) = Your Message
- timerSeconds (Integer) = Duration in seconds
- timerEnd (Boolean) = When true the timer will not disappear when it hits 0
- timerPosition (Integer) = 0 (Display Center), 1 (Display Left), 2 (Display Right), 4 (Display Center - offset)
- timerWarning (Integer) = -1 (Disable, Will default to '0' Red) - Changes the timer color to red when the timer is low
  
You may also call this lua function to pause the timer.  
```lua
FireGameEvent('cgm_timer_pause', { timePaused = true})
```
  
**Where:**
- timePaused (Boolean) = true (Pause), false (Unpause)
