# Recovery Steps
If your system begins to hang on boot or you start running into issues you can manually restore the original boot files with these steps.

1. Create a USB recovery drive following Valve's instructions [here](https://help.steampowered.com/en/faqs/view/1B71-EDF2-EB6D-2BB3)
2. Instead of choosing the restore or reinstall options open up Konsole and type the following commands hitting enter after each one:

NOTE: You'll need a usb keyboard and hub to use both the boot flash drive and keyboard. You can also boot from an SD Card. Only USB 2.0 hubs seemed to work for me in recovery for some reason.
```sh
cp /run/media/deck/home/deck/.local/share/Steam/steamui/library.js.backup /run/media/deck/home/deck/.local/share/Steam/steamui/library.js
cp /run/media/deck/home/deck/.local/share/Steam/steamui/css/library.css.backup /run/media/deck/home/deck/.local/share/Steam/steamui/css/library.css
rm /run/media/deck/home/deck/homebrew/startup_animations/randomize_deck_startup.sh
```
3. Reboot and you should be able to boot with the stock animation
4.Go into desktop mode and run the uninstall or update command from [README.md](../README.md). If something broke I'd wait to see if I announce an update (the version will be in the README file)