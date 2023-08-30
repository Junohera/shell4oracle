#!/bin/sh

# example
# . loadProfile/loadProfile.sh scott
# echo "db_user_name is ${db_user_name}"
# echo "db_password is ${db_password}"
# echo "db_pagesize is ${db_pagesize}"
# echo "db_linesize is ${db_linesize}"

# move management
cd $MANAGER_PATH

# move .profiles
cd .profiles

# set actor, persona
ACTOR=$1
PERSONA="${ACTOR}.profile"

# check physical file
ls $PERSONA 1> /dev/null
if [ $? -ne 0 ]; then
  LOG_ERROR "${PERSONA} is not exists."
  exit 255
fi

# exist keys
cat $PERSONA | grep -w 'username' > /dev/null; is_exist_username=$(echo $?);
cat $PERSONA | grep -w 'password' > /dev/null; is_exist_password=$(echo $?);
cat $PERSONA | grep -w 'pagesize' > /dev/null; is_exist_pagesize=$(echo $?);
cat $PERSONA | grep -w 'linesize' > /dev/null; is_exist_linesize=$(echo $?);
if [ $is_exist_username -ne 0 ]; then LOG_WARN "username is not exist.(at ${PERSONA})"; exit 255; fi
if [ $is_exist_password -ne 0 ]; then LOG_WARN "password is not exist.(at ${PERSONA})"; exit 255; fi
if [ $is_exist_pagesize -ne 0 ]; then LOG_WARN "pagesize is not exist.(at ${PERSONA})"; exit 255; fi
if [ $is_exist_linesize -ne 0 ]; then LOG_WARN "linesize is not exist.(at ${PERSONA})"; exit 255; fi

# get values
db_user_name=$(cat $PERSONA | grep -w 'username' | awk -F= '{print $NF}')
db_password=$(cat $PERSONA | grep -w 'password' | awk -F= '{print $NF}')
db_pagesize=$(cat $PERSONA | grep -w 'pagesize' | awk -F= '{print $NF}')
db_linesize=$(cat $PERSONA | grep -w 'linesize' | awk -F= '{print $NF}')

# check actor&value
if [ $ACTOR != $db_user_name ]; then
  LOG_ERROR "username is invalid.(${ACTOR} <> ${db_user_name})"
  exit 255
fi

export db_user_name
export db_password
export db_pagesize
export db_linesize

cd $MANAGER_PATH