#!/usr/bin/env bash

DECK_STARTUP_FILE_SIZE=1840847

SMALLER_FILES="$(find ./deck_startup/ -type f -iname "*.webm" -size "-${DECK_STARTUP_FILE_SIZE}c")"
if [ "$(echo "$SMALLER_FILES" | wc -l)" -gt 0 ] && [ "$SMALLER_FILES" != "" ]; then
    echo "Truncating files smaller than $DECK_STARTUP_FILE_SIZE B." >&2
    while read -r file; do
        echo "  $file"
        truncate -s "$DECK_STARTUP_FILE_SIZE" "$file"
    done <<< "$SMALLER_FILES"
else
    echo "No files to truncate." >&2
fi

LARGER_FILES="$(find ./deck_startup/ -type f -iname "*.webm" -size "+${DECK_STARTUP_FILE_SIZE}c")"
if [ "$(echo "$LARGER_FILES" | wc -l)" -gt 0 ] && [ "$LARGER_FILES" != "" ]; then
    echo -e "\nWARNING: Following files are too large for the startup video:"
    while read -r file; do
        echo "  $file"
    done <<< "$LARGER_FILES"
fi >&2
