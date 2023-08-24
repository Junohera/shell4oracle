#!/bin/sh

# 0. export project root path
# 1. set environment
# 2. check shell file
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
    echo "full_path same file"
    PROJECT_ROOT=$(pwd)
  else
    echo "else"
    PROJECT_ROOT=$(echo $full_path | awk -F"$file" '{print $1}')    
  fi 

  echo "full_path : ${full_path}"; echo "file : ${file}"; echo "name : ${name}"; echo "PROJECT_ROOT : ${PROJECT_ROOT}";
  export PROJECT_ROOT  
}
# 1. set environment
set_environment () {
  cd $PROJECT_ROOT || exit
  . ./.color.env
}
# 2. check shell file
check_shell_file() {
  if [ $# -lt 1 ]; then
    echo_red "No shell file was specified to run. (example: sh Agent.sh 'sample')"
    exit
  fi
}
###########################################
export_project_root_path
set_environment
check_shell_file "$@"

