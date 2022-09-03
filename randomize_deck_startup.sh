#!/usr/bin/env bash

Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

msg() {
  echo -e ":: ${@}$Color_Off"
}

msg2() {
  echo -e "$Red!!$Color_Off ${@}$Color_Off"
}

DECK_STARTUP_FILE="/home/deck/.steam/steam/steamui/movies/deck_startup.webm"
DECK_STARTUP_FILE_SIZE=1840847
DECK_STARTUP_STOCK_MD5="4ee82f478313cf74010fc22501b40729"

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

DECK_CSS_FILE="/home/deck/.steam/steam/steamui/css/library.css"
DECK_CSS_FILE_SIZE=38488
DECK_CSS_STOCK_MD5="22d52af1fc507209fef4cf72a7a234d4"

DECK_JS_FILE="/home/deck/.steam/steam/steamui/library.js"
DECK_JS_FILE_SIZE=296411
DECK_JS_STOCK_MD5="047a4968a9e81faba14727a498f45429"

check_backup_js_css() {
  if [[ ! -f "$DECK_CSS_FILE.backup" ]]; then
    checksum="$(md5sum "$DECK_CSS_FILE" | cut -d ' ' -f 1)"
    if [[ "$checksum" != "$DECK_CSS_STOCK_MD5" ]]; then
      msg2 "library.css has already been modified, cannot make a backup"
    else
      msg "Creating backup of initial library.css ($checksum)"
      cp "$DECK_CSS_FILE" "$DECK_CSS_FILE.backup"
      msg "Copying new CSS file"
      cp "/home/deck/homebrew/startup_animations/library.css" "$DECK_CSS_FILE"
    fi
  fi

  if [[ ! -f "$DECK_JS_FILE.backup" ]]; then
    checksum="$(md5sum "$DECK_JS_FILE" | cut -d ' ' -f 1)"
    if [[ "$checksum" != "$DECK_JS_STOCK_MD5" ]]; then
      msg2 "library.js has already been modified, cannot make a backup"
    else
      msg "Creating backup of initial library.js ($checksum)"
      cp "$DECK_JS_FILE" "$DECK_JS_FILE.backup"
      msg "Copying new JS file"
      cp "/home/deck/homebrew/startup_animations/library.js" "$DECK_JS_FILE"
    fi
  fi
}

list_animations() {
  find ./deck_startup/ -type f -size "${DECK_STARTUP_FILE_SIZE}c" -iname '*.webm' -print0
}

random_animation() {
  mapfile -d $'\0' animations < <(list_animations)
  echo "${animations[$RANDOM % ${#animations[@]}]}"
}

check_backup
check_backup_js_css
animation="$(random_animation)"
msg "Using $animation"
ln -f "$animation" "$DECK_STARTUP_FILE"

