#!/usr/bin/env bash

if [[ -e "$HOME/.config/systemd/user/randomize_deck_startup.service" ]]; then
  echo ":: Removing the boot service"
  systemctl --user disable randomize_deck_startup.service
  rm "$HOME/.config/systemd/user/randomize_deck_startup.service"
fi

if [[ -f "$HOME/.steam/steam/steamui/movies/deck_startup.webm.backup" ]]; then
  echo ":: Restoring deck_startup.webm.backup"
  rm "$HOME/.steam/steam/steamui/movies/deck_startup.webm"
  mv "$HOME/.steam/steam/steamui/movies/deck_startup.webm.backup" "$HOME/.steam/steam/steamui/movies/deck_startup.webm"
fi

if [[ -f "$HOME/.steam/steam/steamui/css/library.css.backup" ]]; then
  echo ":: Restoring library.css.backup"
  rm "$HOME/.steam/steam/steamui/css/library.css"
  mv "$HOME/.steam/steam/steamui/css/library.css" "$HOME/.steam/steam/steamui/css/library.css"
fi

if [[ -f "$HOME/.steam/steam/steamui/library.js.backup" ]]; then
  echo ":: Restoring library.js.backup"
  rm "$HOME/.steam/steam/steamui/library.js"
  mv "$HOME/.steam/steam/steamui/library.js.backup" "$HOME/.steam/steam/steamui/library.js"
fi

if [[ -e "$HOME/homebrew/startup_animations" ]]; then
  echo ":: Deleting the startup_animations directory"
  rm -rf "$HOME/homebrew/startup_animations"
fi

