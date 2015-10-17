# CustomTimer
A Panorama Module for custom timers in Dota 2  
The Scaleform Module has been depreciated and can be found here [[src]](https://github.com/ynohtna92/CustomTimer/tree/3833a3acfc7c8205b653f6d0c2438ea57215cad7).

<p align="center">
  <img src="https://raw.githubusercontent.com/ynohtna92/CustomTimer/master/src/CustomTimerPreview.PNG"/>
</p>

[GFY Preview](https://gfycat.com/OfficialCautiousCaimanlizard)

Usage
-----
Places the panorama and script files in the correct location in your custom game directory.

In lua use  
````lua
CustomGameEventManager:Send_ServerToAllClients("display_timer", {msg="Remaining", duration=10, mode=0, endfade=false, position=0, warning=5, paused=false, sound=true} )
````
**Where:**
- msg (String) = Your Message
- duration (Integer) = Duration in seconds
- endfade (Boolean) = When true the timer will not disappear when it hits 0
- position (Integer) = 0 (Display Center), 1 (Display Left), 2 (Display Right), 4 (Display Center - offset)
- warning (Integer) = -1 (Disable, Will default to '0' Red) - Changes the timer color to red when the timer is low
- paused (Boolean) = true (Pause), false (Unpause)
- sound (Boolean) = true (Warning Sound On), false (Warning Sound Off)
- mode (Integer) = 0 (Countdown), 1 (Countup)

You may also call this lua function to pause the timer.  
```lua
CustomGameEventManager:Send_ServerToAllClients("pause_timer", {pause=true} )
```
  
**Where:**
- paused (Boolean) = true (Pause), false (Unpause)
