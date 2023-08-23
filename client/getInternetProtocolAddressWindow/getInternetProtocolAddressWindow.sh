#!/bin/bash
clear

DIST_PATH="$0.result"

function show_and_exit() {
  cat "$DIST_PATH"
  exit
}

if [ -f $DIST_PATH ]; then
  show_and_exit
fi

if [ ! -f ipconfig.txt ]; then
  echo "ipconfig.txt is not exists."
  echo "Execute the following command: \`ipconfig | iconv -f cp949 -t utf-8 > ipconfig.txt\`"
  exit
fi

IP=$(cat -n ipconfig.txt | head -9 | tail -1 | awk -F: '{print $NF}' | tr -d ' ')


echo "$IP" > "$DIST_PATH"
show_and_exit