#!/bin/sh

# sample
# sh executeQueryWithLog.sh 'select 1 from dual;' 'test'

logging="$0.log"
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
  export operation_time_start=$(echo $(date +%S))

  LOG ""
  LOG "======= TRY CONNECTION AT: $(date +%F" "%T) ========"
  LOG "$queryname"
  LOG "-------------------- INFO ---------------------"
  LOG "    TAG= $tag"
  LOG "    username= $db_user_name"
  LOG "    pagesize= $db_pagesize"
  LOG "    linesize= $db_linesize"
  LOG "-------------------- QUERY --------------------"
  LOG "$query"
}

SUCCESS() {
  operation_time_end=$(echo $(date +%S))
  operation_time=$(($operation_time_end - $operation_time_start))
  
  LOG "-------------------- RESULT -------------------"
  LOG "$result"
  LOG "-------------------- DONE ---------------------"
  LOG "    TAG= $tag"
  LOG "operation time: $operation_time"
  LOG "======= SUCCESS AT: $(date +%F" "%T) ==============="
}

FAILURE() {
  operation_time_end=$(echo $(date +%S))
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
result=$(sqlplus -S ${db_user_name}/${db_password} <<EOF
set head off
set feedback off
set pagesize ${db_pagesize}
set linesize ${db_linesize}
${query}
exit;
EOF
)
if [ $? -ne 0 ]; 
then
  FAILURE "$result"
else
  SUCCESS "$result"
fi