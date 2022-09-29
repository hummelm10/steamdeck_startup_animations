#!/usr/bin/env bash

cd $HOME/homebrew/startup_animations/

if [ -d "$HOME/homebrew/startup_animations/deck_startup/" ] 
then
    echo ":: Backing up deck_startup/"
    mv "$HOME/homebrew/startup_animations/deck_startup/" "$HOME/homebrew/deck_startup_backup"
else
    echo "Error: Run Install First."
fi

echo ":: Pulling Updates..."
git pull --verbose

echo ":: Restoring deck_startup/"
rm -rf "$HOME/homebrew/startup_animations/deck_startup/"
mv "$HOME/homebrew/deck_startup_backup" "$HOME/homebrew/startup_animations/deck_startup/"

echo ":: Reinstalling the device startup service"
ln -sf "$HOME/homebrew/startup_animations/randomize_deck_startup.service" "$HOME/.config/systemd/user/randomize_deck_startup.service"
systemctl --user daemon-reload
systemctl --user enable --now randomize_deck_startup.service

echo ":: Reinstalling the desktop startup service"
ln -sf "$HOME/homebrew/startup_animations/randomize_deck_desktop.service" "$HOME/.config/systemd/user/randomize_deck_desktop.service"
systemctl --user daemon-reload
systemctl --user enable --now randomize_deck_desktop.service