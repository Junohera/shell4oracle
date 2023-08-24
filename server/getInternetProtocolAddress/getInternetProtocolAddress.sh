#!/bin/sh
ifconfig |
  head -2 |
  tail -1 |
  awk -Fnetmast '{print $1}' |
  awk -F" " '{print $NF}' > "$0.temp"
RESULT="$(cat "$0.temp")"
rm "$0.temp"
echo "$RESULT"
