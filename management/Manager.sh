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
  cd $CURRENT_PATH
  MANAGER_PATH=$(echo $(pwd))
  cd ../
  PROJECT_PATH=$(echo $(pwd))
  ENV_PATH=$(echo $(pwd)/.env)
  export MANAGER_PATH
  export PROJECT_PATH
  export ENV_PATH

  cd $MANAGER_PATH
}
# 2. set environment
set_environment () {
  . "${ENV_PATH}/.log.env"
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
    LOG_WARN "Warning: No shell file was specified to run. (example: sh Agent.sh 'sample')"
    LOG_WARN "but, i will suggest."
    echo -n "${blue}wait ${color_init}"
    # for exp in . . . . . . . . . .
    # do
    #   echo -n "${blue}${exp}${color_init}"
    #   sleep 0.1
    # done
    
    clear;
    cat -n .services.whitelist
    echo -n "Enter number(q: quit): "
    read num
    
    if [ $num = "q" ]; then
      clear
      LOG_INFO "DONE."
      exit
    fi

    name=$(cat .services.whitelist | head -$num | tail -1)
    shell_file="${name}/${name}.sh"
  else
    grep -w $1 .services.whitelist
    if [ $? -ne 0 ]; then
      LOG_WARN "\"$1\" is not found. need to read \"how to develop\" in README.md"
      exit 127
    fi
    shell_file="$1/$1.sh"
  fi
  
  ls "${shell_file}"
  if [ $? -eq 2 ]; then
    LOG_ERROR "${shell_file} is not exists."
    exit
  fi

  shell_file
}
# 5. execute shell file
execute_shell_file() {
  clear
  sh $shell_file
  echo -n "Enter any key "
  exps=("\033[31m" " . " "\033[0m" "\033[32m" " . " "\033[0m" "\033[33m" " . " "\033[0m" "\033[34m" " . " "\033[0m" "\033[35m" " . " "\033[0m" "\033[36m" " . " "\033[0m" "\033[37m" " . " "\033[0m")
  quotient=$(expr ${#exps[@]} / 3)
  for ((i = 0; i < ${#exps[@]}; i += 3)); do
    open="${exps[i]}"
    exp="${exps[i+1]}"
    close="${exps[i+2]}"

    echo -e -n "${open}${exp}${close}"
    sleep 0.1
  done
  read next
}
####################################################################################################
export_path
set_environment

while [ 1 ]; do
  load_whitelist_shell_file
  check_shell_file "$@"
  execute_shell_file "$@"
done
####################################################################################################