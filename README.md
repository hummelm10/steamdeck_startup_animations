# steamdeck_startup_animations v2.0

## What's new in v2.0

Valve has listened to the community and has made it easier by creating a dedicated way to use custom animations. This project has been modified to use that feature and as such will be more stable with future updates and won't have to be fixed each time there's a client update with new hashes and regex's. A new service has also been added to randomize the suspend animation on each resume and before each suspend so you can have all the custom animations you want. 

**NOTE: You can't update from 1.0 to 2.0. You'll need to uninstall and reinstall again. Just backup your animations to another folder before doing so. This is due to how some of the files are being handled now so the originals need to be replaced and then modified again.**

&nbsp;

This was originally forked from https://github.com/kageurufu/steamdeck_startup_animations and added additional services and options for swapping files. 

Three systemd services are installed. One runs on device start which rotates the animation with each startup. A second service runs every time you switch to desktop mode so when you log off from desktop mode you get a new animation into game mode. A third service randomizes the suspend animation for those who don't like shutting down to see the coolness. 

&nbsp;

# Adding your files
## **For startup/shutdown/and return to gamemode animations:**
You can add/remove webms as long as theyre exactly `1840847` bytes to the `/home/deck/homebrew/startup_animations/deck_startup` directory.
Files not matching the exact size or not ending with `.webm` are ignored during the random selection process.
The service uses the `find` command to discover the files, which also works recursively, so don't hesitate to organize your videos in more subfolders.

## **For suspend animations:**
You can add/remove webms as long as theyre exactly `160008` bytes to the `/home/deck/homebrew/startup_animations/deck_suspend` directory.
Files not matching the exact size or not ending with `.webm` are ignored during the random selection process.
The service uses the `find` command to discover the files, which also works recursively, so don't hesitate to organize your videos in more subfolders.


If you have files smaller than the exact size in the `deck_startup` or `deck_suspend` folder, run the `truncate_videos.sh` utility script to enlarge them accordingly.
Additionally, it will warn you if there are any webm files larger than the size - those you'll have to reencode and compress more, or truncate yourself and lose the end of the video.


## Prioritizing videos:

You may also increase the chances of some videos to be played during boot by adding an optional "parameter" within the file names. The syntax is quite simple: `<name>.<chance>.webm`, e.g. `better-call-saul.69.webm` or `star-wars-disneyplus.420.webm`.  
By default each video has a chance of `1` to be selected as boot animation, i.e. the chances are equal and in long term you should not see one specific video significantly more often than others (unless you only have one).
With a higher chance number in the file name the chance of the video to be selected rises. The increase is relative to the amount of videos in the folder and their respective chances.

Example:  
You have 4 videos with the following names:
- `hello-there.webm`
- `those_bastards_lied_to_me.1.webm`
- `dindu.nuffin.2.webm`
- `seymour waiting for fry.4.webm`

The chances summed up are **8**:
- **1** for each `hello-there` (by default in this case) and `those_bastards_lied_to_me`,
- **2** for `dindu.nuffin` and
- **4** for `seymour waiting for fry`.

This means the first two videos have only a 12.5% chance to play each, the third 25% and the last one 50%. In the long run they should play in those ratios.

&nbsp;

# So far, I've made boot animations from the following consoles:

* dreamcast
* ps1
* ps2
* ps4
* switch
* gamecube
* ps2
* switchfirst (first boot animation)
* switch (regular boot animation)
* xbox
* xbox 360
* xbox one

&nbsp;

# Installation

```sh
curl -o - https://raw.githubusercontent.com/hummelm10/steamdeck_startup_animations/main/install.sh | bash -
```

If you're (justifiably) not a fan of `curl | bash`, you can run this:

```sh
mkdir -p "$HOME/homebrew"
mkdir -p "$HOME/.config/systemd/user"
git clone https://github.com/hummelm10/steamdeck_startup_animations "$HOME/homebrew/startup_animations"
ln -sf "$HOME/homebrew/startup_animations/randomize_deck_startup.service" "$HOME/.config/systemd/user/randomize_deck_startup.service"
systemctl --user daemon-reload
systemctl --user enable --now randomize_deck_startup.service
ln -sf "$HOME/homebrew/startup_animations/randomize_deck_desktop.service" "$HOME/.config/systemd/user/randomize_deck_desktop.service"
systemctl --user daemon-reload
systemctl --user enable --now randomize_deck_desktop.service
ln -sf "$HOME/homebrew/startup_animations/randomize_deck_suspend.service" "$HOME/.config/systemd/user/randomize_deck_suspend.service"
systemctl --user daemon-reload
systemctl --user enable --now randomize_deck_suspend.service
```

If you want to risk the dev branch you can do so with:
```sh
curl -o - https://raw.githubusercontent.com/hummelm10/steamdeck_startup_animations/feature/dev/bugfix/install_dev.sh | bash -
```
(There's a chance the feature/dev branch will soft brick your device since I'm still working on it. Don't do unless you know what you're doing. However, there is a chance at recovery if you boot from a USB and manually restore the css and js files and remove the startup script.)

&nbsp;

# Updating
To update run the following. This will preserve whatever is in `/home/deck/homebrew/startup_animations/deck_startup` and will not overwrite any files. 
```sh
curl -o - https://raw.githubusercontent.com/hummelm10/steamdeck_startup_animations/main/update.sh | bash -
```
&nbsp;

# Uninstallation

```sh
bash $HOME/homebrew/startup_animations/uninstall.sh
```
&nbsp;

# Issue Reporting
Please include the journalctl logs using the output from `journalctl -n 100 --no-pager -e SYSLOG_IDENTIFIER=bootWebmRandomizer` in Konsole in your bug report along with a description of the behavior your are seeing for startup animation issues. 

Please include the journalctl logs using the output from `journalctl -n 100 --no-pager -e SYSLOG_IDENTIFIER=bootWebmRandomizerDesktop` in Konsole in your bug report along with a description of the behavior your are seeing for return to game mode animation issues. 

Please include the journalctl logs using the output from `journalctl -n 100 --no-pager -e SYSLOG_IDENTIFIER=suspendWebmRandomizerDesktop` in Konsole in your bug report along with a description of the behavior your are seeing for suspend animation issues. 

Please also submit the OS version and build and Steam version.

&nbsp;

# Making Animations

Somewhat advanced, but the steps to making your own animations are [here](docs/making_animations.md).

# Credits
Thanks to those I forked this from and who have submitted PRs:
* kageurufu (original repo)
* inkassso
 
