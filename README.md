# CustomTimer
A Flash Module for custom timers in Dota 2



Usage
-----
Places the files in the correct location.

In lua use  
````lua
FireGameEvent('cgm_timer_display', { timerMsg = "Remaining", timerSeconds = 10, timerEnd = true, timerPosition = 0})
````
**Where:**
- timerMsg (String) = Your Message
- timerSeconds (Integer) = Duration in seconds
- timerEnd (Boolean) = When true the timer will disappear when it hits 0
- timerPosition (Integer) = 0 (Display Center), 1 (Display Left), 2 (Display Right), 4 (Display Center - offset)
  
You may also call this lua function to pause the timer.  
```lua
FireGameEvent('cgm_timer_pause', { timePaused = true})
```
  
**Where:**
- timePaused (Boolean) = true (Pause), false (Unpause)
