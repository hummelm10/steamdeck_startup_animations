#!/usr/bin/env bash

if [[ -e "$HOME/.config/systemd/user/randomize_deck_startup.service" ]]; then
  echo ":: Removing the boot service"
  systemctl --user disable randomize_deck_startup.service
  rm "$HOME/.config/systemd/user/randomize_deck_startup.service"
fi

if [[ -e "$HOME/.config/systemd/user/randomize_deck_desktop.service" ]]; then
  echo ":: Removing the desktop service"
  systemctl --user disable randomize_deck_desktop.service
  rm "$HOME/.config/systemd/user/randomize_deck_desktop.service"
fi

if [[ -e "$HOME/.config/systemd/user/randomize_deck_suspend.service" ]]; then
  echo ":: Removing the desktop service"
  systemctl --user disable randomize_deck_suspend.service
  rm "$HOME/.config/systemd/user/randomize_deck_suspend.service"
fi

if [[ -f "$HOME/.steam/root/config/uioverrides/movies/deck_startup.webm" ]]; then
  echo ":: Deleting overrides deck_startup.webm"
  rm "$HOME/.steam/root/config/uioverrides/movies/deck_startup.webm"
fi

if [[ -f "$HOME/.steam/root/config/uioverrides/movies/deck-suspend-animation.webm" ]]; then
  echo ":: Deleting overrides deck-suspend-animation.webm"
  rm "$HOME/.steam/root/config/uioverrides/movies/deck-suspend-animation.webm"
fi

if [[ -f "$HOME/.steam/steam/steamui/library.js.backup" ]]; then
  echo ":: Restoring js file"
  mv "$HOME/.steam/steam/steamui/library.js.backup" "$HOME/.steam/steam/steamui/library.js"
fi

if [[ -e "$HOME/homebrew/startup_animations" ]]; then
  echo ":: Deleting the startup_animations directory"
  rm -rf "$HOME/homebrew/startup_animations"
fi

