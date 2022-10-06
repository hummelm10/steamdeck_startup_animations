#!/usr/bin/env bash

. ./constants

msg() {
  echo -e ":: ${@}$Color_Off"
}

msg2() {
  echo -e "$Red!!$Color_Off ${@}$Color_Off"
}

list_animations() {
  find ./deck_startup/ -type f -iname '*.webm'
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

check_js() {
  if [[ ! -f "$DECK_JS_FILE.backup" ]]; then
    cp "$DECK_JS_FILE" "$DECK_JS_FILE.backup"
  fi
  if [[ ! -f "$HOME/homebrew/startup_animations/library.js.mod" ]]; then
    cp "$DECK_JS_FILE.backup" "$HOME/homebrew/startup_animations/library.js.mod"
  fi
  checksum="$(md5sum "$DECK_JS_FILE" | cut -d ' ' -f 1)"
  checksum1="$(md5sum "$HOME/homebrew/startup_animations/library.js.mod" | cut -d ' ' -f 1)"
  if [[ "$checksum" != "$checksum1" ]]; then #check if og file and mod file match
    if [[ -f "$DECK_JS_FILE.backup" ]]; then #if they dont check if backup exists
      checksum1="$(md5sum "$DECK_JS_FILE.backup" | cut -d ' ' -f 1)"
      if [[ "$checksum" == "$checksum1" ]]; then #check if backup and og match
        msg2 "New JS File, check regex" 
      fi
    fi
    msg "Creating backup of library.js ($checksum)"
    cp "$DECK_JS_FILE" "$DECK_JS_FILE.backup" #will be used to compare next boot, if these match but the mod file doesn then file is being overwritten
    cp "$DECK_JS_FILE.backup" "$HOME/homebrew/startup_animations/library.js.mod" #still attempt to modify it if this is the first time the file is written
  fi
}

mod_js() {
  check_js
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

mod_js

if [[ ! -z "$(list_animations)" ]]; then
  animation="$(random_animation)"
  msg "Using $animation"
  ln -f "$animation" "$DECK_STARTUP_FILE"
fi

