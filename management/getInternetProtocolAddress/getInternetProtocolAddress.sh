#!/bin/sh
ifconfig |
  head -2 |
  tail -1 |
  awk -Fnetmask '{print $1}' |
  awk -F" " '{print $NF}' > "$0.temp"
RESULT="$(cat "$0.temp")"
rm "$0.temp"
LOG_DEBUG $RESULT
