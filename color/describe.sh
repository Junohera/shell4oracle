#!/bin/sh
clear;
current_path=$(dirname $(realpath $0))
sed '/ECHO_/!d' "${current_path}/.color.env" | awk -F" " '{print $1}'