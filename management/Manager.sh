#!/bin/sh
clear;
# 0. export project root path
# 1. set environment
# 2. load_whitelist_shell_file
# 3. check shell file
#   3-1. suggest shell file
# 4. execute shell file
###########################################
# 0. export project root path
export_project_root_path () {
  local full_path
  local file
  local name

  full_path=$0
  file=$(echo $full_path | awk -F"/" '{print $NF}')
  name=$(echo $file | awk -F"." '{print $1}')

  if [ $full_path = $file ]; 
  then
    PROJECT_ROOT=$(pwd)
  else
    PROJECT_ROOT=$(echo $full_path | awk -F"$file" '{print $1}')    
  fi 

  # echo "full_path : ${full_path}"; echo "file : ${file}"; echo "name : ${name}"; echo "PROJECT_ROOT : ${PROJECT_ROOT}";
  export PROJECT_ROOT  
}
# 1. set environment
set_environment () {
  cd $PROJECT_ROOT || exit
  . ./.color.env
}
# 2. load_whitelist_shell_file
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
# 3. check shell file
check_shell_file() {
  if [ $# -lt 1 ]; 
  then
    #   3-1. suggest shell file
    echo_red "Warning: No shell file was specified to run. (example: sh Agent.sh 'sample')"
    echo_blue "but, i will suggest."
    echo -n "${blue}wait ${color_init}"
    for exp in . . . . . . . . . .
    do
      echo -n "${blue}${exp}${color_init}"
      sleep 0.1
    done
    
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
  
  echo "pwd: $(pwd)"
  echo "shell_file: $shell_file"
  ls "${shell_file}" #2> /dev/null
  if [ $? -eq 2 ]; then
    echo_red "${shell_file} is not exists."
    exit
  fi

  export shell_file
}
# 4. execute shell file
execute_shell_file() {
  clear
  sh $shell_file
}
###########################################
export_project_root_path
set_environment
load_whitelist_shell_file
check_shell_file "$@"
execute_shell_file "$@"
