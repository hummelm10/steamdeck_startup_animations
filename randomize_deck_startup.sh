#!/usr/bin/env bash

. ./constants

msg() {
  echo -e ":: ${@}$Color_Off"
}

msg2() {
  echo -e "$Red!!$Color_Off ${@}$Color_Off"
}

check_backup() {
  if [[ ! -f "$DECK_STARTUP_FILE.backup" ]]; then
    checksum="$(md5sum "$DECK_STARTUP_FILE" | cut -d ' ' -f 1)"
    if [[ "$checksum" != "$DECK_STARTUP_STOCK_MD5" ]]; then
      msg2 "deck_startup.webm has already been modified, cannot make a backup"
    else
      msg "Creating backup of initial deck_startup.webm ($checksum)"
      cp "$DECK_STARTUP_FILE" "$DECK_STARTUP_FILE.backup"
    fi
  fi
}

check_backup_js_css() {
  if [[ ! -f "$DECK_CSS_FILE.backup" ]]; then
    checksum="$(md5sum "$DECK_CSS_FILE" | cut -d ' ' -f 1)"
    checksum2="$(md5sum "$DECK_CSS_FILE.backup" | cut -d ' ' -f 1)"
    if [[ "$checksum" != "$DECK_CSS_STOCK_MD5" ]]; then
      msg2 "library.css has already been modified, cannot make a backup"
    else
      msg "Creating backup of initial library.css ($checksum)"
      cp "$DECK_CSS_FILE" "$DECK_CSS_FILE.backup"
      cp "$DECK_CSS_FILE" "$HOME/homebrew/startup_animations/library.css.mod"
    fi
  fi

  if [[ ! -f "$DECK_JS_FILE.backup" ]]; then
    checksum="$(md5sum "$DECK_JS_FILE" | cut -d ' ' -f 1)"
    if [[ "$checksum" != "$DECK_JS_STOCK_MD5" ]]; then
      msg2 "library.js has already been modified, cannot make a backup"
      cp "$DECK_JS_FILE.backup" "$HOME/homebrew/startup_animations/library.js.modb"
    else
      msg "Creating backup of initial library.js ($checksum)"
      cp "$DECK_JS_FILE" "$DECK_JS_FILE.backup"
      cp "$DECK_JS_FILE" "$HOME/homebrew/startup_animations/library.js.mod"
    fi
  fi
}

list_animations() {
  find ./deck_startup/ -type f -size "${DECK_STARTUP_FILE_SIZE}c" -iname '*.webm'
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

  # mapfile -d $'\0' animations < <(list_animations)
  # #add SEED based on pid with $$
  # RANDOM=$$
  # echo "${animations[$RANDOM % ${#animations[@]}]}"
}

mod_css() {
  if [[ ! -f "$HOME/homebrew/startup_animations/library.css.mod" ]]; then
    cp "$DECK_CSS_FILE.backup" "$HOME/homebrew/startup_animations/library.css.mod"
  fi
  DECK_CSS_FILE_SIZE=$(stat -c %s "$DECK_CSS_FILE.backup")
  msg "CSS File Size: $DECK_CSS_FILE_SIZE"
  msg "Modifying CSS file"
  perl -p -i -e 's/^(.+?)\s(.*img\{.*?width\:)(.*?px)(.*?height\:)(.*?px)(.*?$)/${1}${2}0100%${4}0100%${6}/g' "$HOME/homebrew/startup_animations/library.css.mod"
  perl -p -i -e 's/^(.+?)\s(.*video\{.*?width\:)(.*?px)(.*?height\:)(.*?px)(.*?$)/${1}${2}0100%${4}0100%${6}/g' "$HOME/homebrew/startup_animations/library.css.mod"
  perl -p -i -e 's/^(!?.*animation-duration\:)(.*?ms)(.*$)/${1}3000ms${3}/g' "$HOME/homebrew/startup_animations/library.css.mod"
  perl -p -i -e 's/^(!?.*animation-delay\:)(.*?ms)(.*$)/${1}11500ms${3}/g' "$HOME/homebrew/startup_animations/library.css.mod"
  #remove comment line to make room for truncate
  sed -i '/\/\*.*\*\// d; /\/\*/,/\*\// d' "$HOME/homebrew/startup_animations/library.css.mod"
  truncate -s $DECK_CSS_FILE_SIZE "$HOME/homebrew/startup_animations/library.css.mod"
  msg "Enabled full screen animations"
  ln -f "$HOME/homebrew/startup_animations/library.css.mod" "$DECK_CSS_FILE"
  msg "Linked modified CSS file"
}

mod_js() {
  if [[ ! -f "$HOME/homebrew/startup_animations/library.js.mod" ]]; then
    cp "$DECK_JS_FILE.backup" "$HOME/homebrew/startup_animations/library.js.mod"
  fi
  DECK_JS_FILE_SIZE=$(stat -c %s "$DECK_JS_FILE.backup")
  msg "JS File Size: $DECK_JS_FILE_SIZE"
  msg "Modifying JS file"
  sed -i -E 's/(.*return\(0,g\.KS\)\()(i,1e4)(.*$)/\1i,9e9\3/' "$HOME/homebrew/startup_animations/library.js.mod"
  msg "Modified time limit"
  sed -i -E -E 's/(.*)(HapticEvent\(0,2,6,2,0\))(.*$)/\1HapticEvent\(0,0,0,0,0\)\3/' "$HOME/homebrew/startup_animations/library.js.mod"
  truncate -s $DECK_JS_FILE_SIZE "$HOME/homebrew/startup_animations/library.js.mod"
  msg "Disabled boot haptics"
  ln -f "$HOME/homebrew/startup_animations/library.js.mod" "$DECK_JS_FILE"
  msg "Linked modified JS file"
}

check_backup
check_backup_js_css
mod_css
mod_js
animation="$(random_animation)"
msg "Using $animation"
ln -f "$animation" "$DECK_STARTUP_FILE"

