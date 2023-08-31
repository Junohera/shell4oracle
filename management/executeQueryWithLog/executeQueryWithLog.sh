#!/bin/sh

# sample
# sh executeQueryWithLog.sh 'select 1 from dual;' 'test'
# sh executeQueryWithLog.sh 'select 1 from dual;' 'test' '/test/log.txt'

logging="$0.log"
if [ $# -ge 3 ]; then
  if ! [ -f $3 ]; then
    LOG_ERROR "$3 is not exists. (to be safe, we don't initialize the log file)."
    exit 1
  fi

  logging=$3
fi

CONNECTION_INFO="${db_user_name}/${db_password}"
AS_SYSDBA=0
if [ $# -ge 4 ]; then
  if [ "$4" = 'as sysdba' ]; then
    CONNECTION_INFO=" / as sysdba"
    AS_SYSDBA=1
  fi
fi

queryname="$2"
#################### DEFINITION ####################
LOG() {
  if ! [ -f $logging ]; then
    > $logging
  fi
  echo "$1" >> $logging
}

START() {
  export tag=$(echo $(date +%N%SS%M%H%d%m%Y))
  export operation_time_start=$(echo $(date -d "$(date +"%F %T")" +%s))

  LOG ""
  LOG "======= TRY CONNECTION AT: $(date +%F" "%T) ========"
  LOG "$queryname"
  LOG "-------------------- INFO ---------------------"
  LOG "    TAG= $tag"
  if [ $AS_SYSDBA -eq 0 ];
  then
    LOG "    username= $db_user_name"
  else
    LOG "    connection= $CONNECTION_INFO"
  fi
  LOG "    pagesize= $db_pagesize"
  LOG "    linesize= $db_linesize"
  LOG "-------------------- QUERY --------------------"
  LOG "$query"
}

SUCCESS() {
  operation_time_end=$(echo $(date -d "$(date +"%F %T")" +%s))
  operation_time=$(($operation_time_end - $operation_time_start))
  
  LOG "-------------------- RESULT -------------------"
  LOG "$result"
  LOG "-------------------- DONE ---------------------"
  LOG "    TAG= $tag"
  LOG "operation time: $operation_time"
  LOG "======= SUCCESS AT: $(date +%F" "%T) ==============="
}

FAILURE() {
  operation_time_end=$(echo $(date -d "$(date +"%F %T")" +%s))
  operation_time=$(($operation_time_end - $operation_time_start))
  LOG "💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥"
  LOG "-------------------- ERROR --------------------"
  LOG "$result"
  LOG "-------------------- FAILURE ------------------"
  LOG "    TAG= $tag"
  LOG "operation time: $operation_time"
  LOG "💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥"
  LOG "======= FAILURE AT: $(date +%F" "%T) ==============="
}
#################### INITIALIZE ####################
query="$(echo "$1" | sed '/^$/d')"
#################### PLAYGROUND ####################
START
result="$(sqlplus -S ${CONNECTION_INFO} <<EOF
set head off
set feedback off
set pagesize ${db_pagesize}
set linesize ${db_linesize}
${query}
exit;
EOF
)"
if [ $? -ne 0 ]; 
then
  FAILURE "$result"
  exit 255
else
  SUCCESS "$result"
  echo "$result"
fi
exit