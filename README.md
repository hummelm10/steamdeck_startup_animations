# steamdeck_startup_animations
This was forked from https://github.com/kageurufu/steamdeck_startup_animations and added library.css and library.js file modifications following this guide https://docs.google.com/document/d/1LP3sLpi6N3NMSbqquLlY8a0ZNpFT-WRyRLiU_tm6N-k/edit from reddit user /u/Crazy89_

The modifications allow for:
* Full screen animations
* Changes how they fade out to make the boot transition smoother
* Removes the 10 second webm animation limit
* Removes the haptics on boot

A collection of steamdeck startup animations, plus a script to randomize your startup on each boot

You can add/remove webms as long as theyre exactly 1840847 bytes to the `/home/deck/homebrew/startup_animations/deck_startup` directory. The service uses the find command to randomly select one from that folder. 

**NOTE: library.css and library.js in the repo are for SteamOS 3.3.1 (build 20220817.1) and I will update if needed. As of now I am only maintaining the STABLE branch**
**The feature/dev version uses sed to automatically update the files**
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
```

# Uninstallation

```sh
bash $HOME/homebrew/startup_animations/uninstall.sh
```

# Issue Reporting
Please include the journalctl logs using the output from `journalctl SYSLOG_IDENTIFIER=bootWebmRandomizer` in Konsole in your bug report along with a description of the behavior your are seeing. 

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

 
