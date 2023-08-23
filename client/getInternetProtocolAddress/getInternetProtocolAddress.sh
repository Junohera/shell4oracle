#!/bin/bash
clear

if [ ! -f ipconfig.txt  ]; then
  echo "ipconfig.txt is not exists."
  echo "Execute the following command: \`ipconfig | iconv -f cp949 -t utf-8 > ipconfig.txt\`"
  exit
fi

IP=$(cat -n ipconfig.txt | head -9 | tail -1 | awk -F: '{print $NF}' | tr -d ' ')

FULL_PATH=$0
FILE=$(echo "$FULL_PATH" | awk -F"/" '{print $NF}')
PATH=$(echo "$FULL_PATH" | awk -F"$FILE" '{print $1}')

DIST_FILE="${PATH}ip.txt"

echo "$IP" > $DIST_FILE
echo "$IP"