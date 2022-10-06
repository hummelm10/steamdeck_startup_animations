#!/usr/bin/env bash

. ./constants

msg() {
  echo -e ":: ${@}$Color_Off"
}

msg2() {
  echo -e "$Red!!$Color_Off ${@}$Color_Off"
}

list_animations() {
  find ./deck_suspend/ -type f -iname '*.webm'
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

if [[ ! -z "$(list_animations)" ]]; then
  animation="$(random_animation)"
  msg "Using $animation"
  ln -f "$animation" "$DECK_SUSPEND_FILE"
fi

