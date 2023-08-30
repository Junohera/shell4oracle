#!/bin/sh
clear;
sed '/^ECHO_/!d' "$(dirname $(realpath $0))/.color.env" | awk -F" " '{print $1}'