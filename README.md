# steamdeck_startup_animations v2.0

## What's new in v2.0

Valve has listened to the community and has made it easier by creating a dedicated way to use custom animations. This project has been modified to use that feature and as such will be more stable with future updates and won't have to be fixed each time there's a client update with new hashes and regex's. A new service has also been added to randomize the suspend animation on each resume and before each suspend so you can have all the custom animations you want. 

&nbsp;

This was forked from https://github.com/kageurufu/steamdeck_startup_animations and added additional services and options for swapping files. 

A collection of steamdeck startup animations, plus a script to randomize your startup and suspend animations. 

Three systemd services are installed. One runs on device start which rotates the animation with each startup. A second service runs every time you switch to desktop mode so when you log off from desktop mode you get a new animation into game mode. A third service randomizes the suspend animation for those who don't like shutting down to see the coolness. 
### For startup/shutdown/and return to gamemode animations 
You can add/remove webms as long as theyre exactly `1840847` bytes to the `/home/deck/homebrew/startup_animations/deck_startup` directory.
Files not matching the exact size or not ending with `.webm` are ignored during the random selection process.
The service uses the `find` command to discover the files, which also works recursively, so don't hesitate to organize your videos in more subfolders.


### For suspend animations 
You can add/remove webms as long as theyre exactly `160008` bytes to the `/home/deck/homebrew/startup_animations/deck_suspend` directory.
Files not matching the exact size or not ending with `.webm` are ignored during the random selection process.
The service uses the `find` command to discover the files, which also works recursively, so don't hesitate to organize your videos in more subfolders.



If you have files smaller than the exact size in the `deck_startup` or `deck_suspend` folder, run the `truncate_videos.sh` utility script to enlarge them accordingly.
Additionally, it will warn you if there are any webm files larger than the size - those you'll have to reencode and compress more, or truncate yourself and lose the end of the video.


## Prioritizing videos

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

If you want to risk the feature/dev branch you can do so with:
```sh
curl -o - https://raw.githubusercontent.com/hummelm10/steamdeck_startup_animations/main/install_dev.sh | bash -
```
(There's a chance the feature/dev branch will soft brick your device since I'm still working on it. Don't do unless you know what you're doing. However, there is a chance at recovery if you boot from a USB and manually restore the css and js files and remove the startup script.)

# Updating
To update run the following. This will preserve whatever is in `/home/deck/homebrew/startup_animations/deck_startup` and will not overwrite any files. 
```sh
curl -o - https://raw.githubusercontent.com/hummelm10/steamdeck_startup_animations/main/update.sh | bash -
```

# Uninstallation

```sh
bash $HOME/homebrew/startup_animations/uninstall.sh
```

# Issue Reporting
Please include the journalctl logs using the output from `journalctl -n 100 --no-pager -e SYSLOG_IDENTIFIER=bootWebmRandomizer` in Konsole in your bug report along with a description of the behavior your are seeing for startup animation issues. 

Please include the journalctl logs using the output from `journalctl -n 100 --no-pager -e SYSLOG_IDENTIFIER=bootWebmRandomizerDesktop` in Konsole in your bug report along with a description of the behavior your are seeing for return to game mode animation issues. 

Please include the journalctl logs using the output from `journalctl -n 100 --no-pager -e SYSLOG_IDENTIFIER=suspendWebmRandomizerDesktop` in Konsole in your bug report along with a description of the behavior your are seeing for suspend animation issues. 

Please also submit the OS version and build and Steam version.

# Making an animation (somewhat advanced)

I used youtube-dl to grab the best video and audio tracks from youtube, and then ffmpeg to merge them, resizing down to fit the Deck's 1280x800 screen. Then I use `truncate` to make the file the right size. 

This all does work on the steamdeck

### Getting the dependencies

```sh
python3 -m ensurepip
~/.local/bin/pip install --user youtube-dl
```

### Creating the animation

```sh
# Get ps1.webm and ps1.m4a. Your file extensions may differ here
~/.local/bin/youtube-dl -f bestvideo -o 'ps1.%(ext)s' https://www.youtube.com/watch?v=1JwbfIi5Uio
~/.local/bin/youtube-dl -f bestaudio -o 'ps1.%(ext)s' https://www.youtube.com/watch?v=1JwbfIi5Uio

# Convert the video from whatever input formats to a webm video in VP9 encoding, with vorbis encoded audio
ffmpeg -i ps1.webm -i ps1.m4a \
       -map 0:v:0  -map 1:a:0 \
       -filter:v "scale='min(1280,iw)':min'(800,ih)':force_original_aspect_ratio=decrease,pad=1280:800:(ow-iw)/2:(oh-ih)/2" \
       -c:v vp9 \
       -c:a libvorbis \
       my_deck_startup_ps1.webm

# Make sure the generated file is less than 1840847B here
# Mine was `389670`, plenty small enough
stat -c '%s' my_deck_startup_ps1.webm

truncate -s 1840847 my_deck_startup_ps1.webm
```

The ffmpeg command is a bit confusing, so heres a breakdown

* `-i ps1.webm -i ps1.m4a`  
  Load both the video and audio files we downloaded.
* `-map 0:v:0  -map 1:a:0`  
  Only use the first video stream from the first file, and first audio stream from the second.  
  This prevents having multiple video or audio streams in the final file
* `-filter:v "scale='min(1280,iw)':min'(800,ih)':force_original_aspect_ratio=decrease,pad=1280:800:(ow-iw)/2:(oh-ih)/2"`  
  This is most confusing part, basically we're resizing the video to fit 1280x800  
  `min'(1280,iw)':min'(800,ih)'` ensures the target size is never upscaled  
  `force_original_aspect_ratio=decrease` scales to fit within a given size, keeping the original aspect ratio  
  `pad=1280:800:(ow-iw)/2:(oh-ih)/2` pad the video size to 1280:800, centering the original video. This is optional and I might not use it in the future
* `-c:v vp9 c:a libvorbis` Select our output VP9 / vorbis codecs

 
