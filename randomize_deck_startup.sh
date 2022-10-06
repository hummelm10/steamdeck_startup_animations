#!/usr/bin/env bash

. ./constants

msg() {
  echo -e ":: ${@}$Color_Off"
}

msg2() {
  echo -e "$Red!!$Color_Off ${@}$Color_Off"
}

list_animations() {
  find ./deck_startup/ -type f -size -iname '*.webm'
}

random_animation() {
  # for each listed file
  list_animations | while IFS= read -r file; do
    repeat=1
    # check if it has a number at the end, e.g. some-animation.5.webm
    if [[ $file =~ .*\.([0-9]+)\.[A-Za-z0-9]+$ ]]; then
      repeat="${BASH_REMATCH[1]}"
    fi
    # and repeat the file said number of times, increasing its chance
    yes "$file" | head -n $repeat
  done | shuf -n 1
  # in the end, shuffle the list of files (including repetitions) and select first
}

check_backup_js() {
  if [[ ! -f "$DECK_JS_FILE.backup" ]]; then
    msg "Creating backup of initial library.js ($checksum)"
    cp "$DECK_JS_FILE" "$DECK_JS_FILE.backup"
    cp "$DECK_JS_FILE" "$HOME/homebrew/startup_animations/library.js.mod"
  fi
}

mod_js() {
  if [[ ! -f "$HOME/homebrew/startup_animations/library.js.mod" ]]; then
    cp "$DECK_JS_FILE.backup" "$HOME/homebrew/startup_animations/library.js.mod"
  fi
  DECK_JS_FILE_SIZE=$(stat -c %s "$DECK_JS_FILE.backup")
  msg "JS File Size: $DECK_JS_FILE_SIZE"
  msg "Modifying JS file"
  sed -i -E 's/(.*return\(0,g\.KS\)\()(s,1e4)(.*$)/\1s,9e9\3/' "$HOME/homebrew/startup_animations/library.js.mod"
  msg "Modified time limit"
  sed -i -E -E 's/(.*)(HapticEvent\(0,2,6,2,0\))(.*$)/\1HapticEvent\(0,0,0,0,0\)\3/' "$HOME/homebrew/startup_animations/library.js.mod"
  truncate -s $DECK_JS_FILE_SIZE "$HOME/homebrew/startup_animations/library.js.mod"
  msg "Disabled boot haptics"
  ln -f "$HOME/homebrew/startup_animations/library.js.mod" "$DECK_JS_FILE"
  msg "Linked modified JS file"
}

check_backup_js
mod_js

animation="$(random_animation)"
msg "Using $animation"
ln -f "$animation" "$DECK_STARTUP_FILE"

