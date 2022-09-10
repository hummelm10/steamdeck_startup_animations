# Instructions for library.css/js modification

Saving this for future reference in case SteamOS updates the files. 

**First: Replace the deck_startup.webm located within /home/deck/.steam/steam/steamui/movies/**

I’d recommend turning on “Show Hidden Files” within the menu of Dolphin (the file explorer), or pressing Ctrl+H. Make sure to rename the video from “deck_startup_valve.webm” to “deck_startup.webm”

**Second: Patch library.css in the css folder in steamui**

This is where it gets a little more complex. Credit to Kageurufuru for discovering most of this. Firstly, KWrite won’t work for this… or well, it will, but you’ll have to truncate back down the file. I’d recommend getting notepadqq from the Discover store to edit these. Once it’s installed, launch it and open the library.css file. You probably wanna turn on word wrapping under View. Scroll down to the bottom of the file, you should see 4 instances of “300px,” replace them to “0100%” (keep the zero). Now, we’re gonna go a little bit higher. You’re looking for the last instances of “animation-delay” and “animation-duration”. This will change the way the background fades and I use it in my Valve video. Change the delay to 11500ms and duration to 3000ms. This will make it go over the original size though, so remove any 3 characters you want in the command at the very end (anything in “sourceMappingURL=css\library.css.map”).

**Third: Patch library.js in the root of the steamui folder**

One thing about the video is that it’s over 10 seconds, so we need to remove (or more accurately, lengthen) the cutoff. To do so, open library.js in notepadqq. Under Search, click on Replace. We’re gonna be replacing “i,1e4” (that’s 10,000ms) to “i,9e9” (9,000,000,000ms, or almost 3 centuries, kinda short). After that, we need to remove the haptic hum. Simply replace “HapticEvent(0,2,6,2,0)” with “HapticEvent(0,0,0,0,0)”. With that, everything should work now! 

I’d recommend going to the terminal first and typing in “steam -gamepadui” to test it so you don’t have to go in and out of game mode in case it doesn’t work.
