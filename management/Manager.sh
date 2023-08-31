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
    
    clear;
    lines=$(cat .services.whitelist | wc -l)

    cat -n .services.whitelist
    echo -n "$(echo "Enter number(number(")$(ECHO_RED "1~${lines}")$(echo ") or ")$(ECHO_BLUE "q")$(echo "(quit)")"
    read num

    if [ $num = "q" ]; then
      clear
      LOG_INFO "DONE."
      exit
    fi

    if [ ${num} -le ${lines} ] && [ ${num} -gt 0 ]
    then
      name=$(cat .services.whitelist | head -$num | tail -1)
      echo "$name"
      shell_file="${name}/${name}.sh"
    else
      clear
      if [ ${num} -gt ${lines} 2> /dev/null ]; then 
        echo -n $(ECHO_RED_DOUBLE "Entered Number(${num}) is greather than ${lines} "); wait; read;
        continue
      fi
      if [ ${num} -le 0 2> /dev/null ]; then
        echo -n $(ECHO_BLUE_DOUBLE "Entered Number(${num}) is less than 0 "); wait; read;
        continue
      fi
      
      echo -n $(ECHO_MAGENTA_WHITE_GLOW "Give you one more chance, so read and type carefully"); wait; read;
      continue
    fi
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
  echo -n "Enter any key(if q then quit.) "
  wait
  read next

  if [ $next = "q" ]; then
    LOG_INFO "DONE."
    exit
  fi
}
# 6. wait
wait () {
  exps=("\033[31m" " . " "\033[0m" "\033[32m" " . " "\033[0m" "\033[33m" " . " "\033[0m" "\033[34m" " . " "\033[0m" "\033[35m" " . " "\033[0m" "\033[36m" " . " "\033[0m" "\033[37m" " . " "\033[0m")
  for ((i = 0; i < ${#exps[@]}; i += 3)); do
    open="${exps[i]}"
    exp="${exps[i+1]}"
    close="${exps[i+2]}"

    echo -e -n "${open}${exp}${close}"
    sleep 0.03
  done
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