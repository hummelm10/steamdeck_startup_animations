#!/usr/bin/env bash

#installs the feature/dev branch
#you really shouldnt use this unless you know what youre doing. high chance of soft bricking

# Create required directories
echo ":: Creating required directories"
mkdir -p "$HOME/homebrew"
mkdir -p "$HOME/.config/systemd/user"

# Clone the startup animations repository
if [[ ! -d "$HOME/homebrew/startup_animations" ]]; then
  echo ":: Installing to $HOME/homebrew/startup_animations"
  git clone --branch feature/dev https://github.com/hummelm10/steamdeck_startup_animations "$HOME/homebrew/startup_animations"
  cd "$HOME/homebrew/startup_animations"
fi

if [[ ! -d "$HOME/.steam/steam/steamui/overrides" ]]; then
  echo ":: Making overrides directory $HOME/.steam/steam/steamui/overrides"
  mkdir "$HOME/.steam/steam/steamui/overrides"
fi

# Install the service file
echo ":: Installing the device startup service"
ln -sf "$HOME/homebrew/startup_animations/randomize_deck_startup.service" "$HOME/.config/systemd/user/randomize_deck_startup.service"
systemctl --user daemon-reload
systemctl --user enable --now randomize_deck_startup.service

echo ":: Installing the desktop startup service"
ln -sf "$HOME/homebrew/startup_animations/randomize_deck_desktop.service" "$HOME/.config/systemd/user/randomize_deck_desktop.service"
systemctl --user daemon-reload
systemctl --user enable --now randomize_deck_desktop.service

echo ":: Installing the suspend service"
ln -sf "$HOME/homebrew/startup_animations/randomize_deck_suspend.service" "$HOME/.config/systemd/user/randomize_deck_suspend.service"
systemctl --user daemon-reload
systemctl --user enable --now randomize_deck_desktop.service