#!/bin/sh
clear;

# example: sh Manager.sh

# 1. export path
# 2. set environment
# 3. load_whitelist_shell_file
# 4. check shell file
# 5. execute shell file
####################################################################################################
# 1. export path
export_path () {
  CURRENT_PATH=$(dirname $(realpath $0))
  PROJECT_PATH=$(cd $CURRENT_PATH; cd ../; pwd)

  cd $CURRENT_PATH || exit

  MANAGER_PATH=$CURRENT_PATH
  export MANAGER_PATH
  export PROJECT_PATH
}
# 2. set environment
set_environment () {
  . ./.color.env
}
# 3. load_whitelist_shell_file
load_whitelist_shell_file () {
  all="$(find ./ -mindepth 1 -maxdepth 1 -type d | awk -F"/" '{print $NF}')"

  > .services.whitelist
  for name in $all
  do
    grep -w "$name" .services > /dev/null
    if [ $? -eq 0 ]; then
      echo "$name" >> .services.whitelist
    fi
  done
}
# 4. check shell file
check_shell_file() {
  if [ $# -lt 1 ]; 
  then
    #   3-1. suggest shell file
    echo_red "Warning: No shell file was specified to run. (example: sh Agent.sh 'sample')"
    echo_blue "but, i will suggest."
    echo -n "${blue}wait ${color_init}"
    # for exp in . . . . . . . . . .
    # do
    #   echo -n "${blue}${exp}${color_init}"
    #   sleep 0.1
    # done
    
    clear;
    cat -n .services.whitelist
    echo -n "Enter number: "
    read num
    
    name=$(cat .services.whitelist | head -$num | tail -1)
    shell_file="${name}/${name}.sh"
  else
    grep -w $1 .services.whitelist
    if [ $? -ne 0 ]; then
      echo_red "\"$1\" is not found. need to read \"how to develop\" in README.md"
      exit 127
    fi
    shell_file="$1/$1.sh"
  fi
  
  ls "${shell_file}"
  if [ $? -eq 2 ]; then
    echo_red "${shell_file} is not exists."
    exit
  fi

  shell_file
}
# 5. execute shell file
execute_shell_file() {
  clear
  sh $shell_file
}
####################################################################################################
export_path
set_environment
load_whitelist_shell_file
check_shell_file "$@"
execute_shell_file "$@"
####################################################################################################