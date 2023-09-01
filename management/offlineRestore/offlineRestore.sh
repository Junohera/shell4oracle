#!/bin/sh

clear;

prefix="$(echo $0 | awk -F"/" '{print $1}')"

START_SECOND=$(date +%s)

BACKUP_DIRECTORY=""
ORACLE_DATA=""
ORACLE_DBS=""

# SET TRACE
TRACE_CONTEXT=""
TRACE_AT_START=""
TRACE_AT_END=""
TRACE_START () { 
  TRACE_CONTEXT="$1"

  TRACE_NOW=$(date +%F" "%T" "%N)
  TRACE_AT_START_SECOND=$(date +%s)

  LOG_TRACE "::: ${TRACE_NOW} ${TRACE_CONTEXT} START :::";
}
TRACE_END () {
  TRACE_NOW=$(date +%F" "%T" "%N)
  TRACE_AT_END_SECOND=$(date +%s)
  TRACE_OPERATION_TIME_SECOND=$(($TRACE_AT_END_SECOND - $TRACE_AT_START_SECOND))

  if [ $TRACE_OPERATION_TIME_SECOND -gt 5 ];
  then
    LOG_WARN "::: ${TRACE_NOW} ${TRACE_CONTEXT} COMPLETE (${TRACE_OPERATION_TIME_SECOND}s):::";
  else
    LOG_TRACE "::: ${TRACE_NOW} ${TRACE_CONTEXT} COMPLETE (${TRACE_OPERATION_TIME_SECOND}s):::";
  fi
}

TRACE_START "LOAD PROFILE START"
. loadProfile/loadProfile.sh system
TRACE_END

TRACE_START "TEMPORAL DIRECTORY INITIALIE"
temp_directory="${MANAGER_PATH}/${prefix}/.temp"
temp_unique_extensions="${temp_directory}/unique_extensions.txt"
if [ ! -d $temp_directory ]; then mkdir -p $temp_directory; fi
TRACE_END

TRACE_START "LOGGING FILE INITIALIZING"
logging_directory="${MANAGER_PATH}/${prefix}/.log"
logging_file="${logging_directory}/$(echo $(date +%Y%m%d%H%M)).txt"
if [ ! -d $logging_directory ]; then mkdir -p $logging_directory; fi
if [ ! -f $logging_file ]; then touch $logging_file; fi
TRACE_END

TRACE_START "READ CONFIG FILE"
config="${MANAGER_PATH}/${prefix}/.config"
BACKUP_DIRECTORY=$(cat $config | sed '/^#/d' | grep 'BACKUP_DIRECTORY=' | awk -F= '{print $NF}');
TRACE_END

TRACE_START "VALIDATION DIRECTORY BY CONFIG FILE"
if [ -z $BACKUP_DIRECTORY ];  then LOG_ERROR "BACKUP_DIRECTORY is not defined. (.config)"; exit 1; fi
LOG_INFO "BACKUP_DIRECTORY: ${BACKUP_DIRECTORY}"
TRACE_END

TRACE_START "CHECK BACKUP_DIRECTORY"
if [ ! -d $BACKUP_DIRECTORY ]; then
  LOG_ERROR "BACKUP_DIRECTORY IS NOT EXISTS.(${BACKUP_DIRECTORY})"
  exit 255
fi

BACKUP_TARGET_DIRECTORY_COUNT=$(find ${BACKUP_DIRECTORY} -mindepth 1 -maxdepth 1 | grep "BACKUP_" | wc -l)
if [ $BACKUP_TARGET_DIRECTORY_COUNT -eq 0 ]; then
  LOG_ERROR "AVAILABLE BACKUP_DIRECTORY IS EMPTY. (${BACKUP_DIRECTORY})"
  exit 255
fi
LOG_INFO "BACKUP_TARGET_DIRECTORY_COUNT: ${BACKUP_TARGET_DIRECTORY_COUNT}"
TRACE_END

TRACE_START "SELECT BACKUP_TARGET_DIRECTORY"
find ${BACKUP_DIRECTORY} -mindepth 1 -maxdepth 1 | grep "BACKUP_" | cat -n
echo -n $(ECHO_GREEN_DOUBLE "Enter backup target directory full path:")
read BACKUP_TARGET_DIRECTORY

LOG_INFO "BACKUP_TARGET_DIRECTORY: ${BACKUP_TARGET_DIRECTORY}"
TRACE_END

TRACE_START "CHECK SELECTED BACKUP_TARGET_DIRECTORY"
IS_EXISTS_DIRECTORY="FALSE"
for i in $(find ${BACKUP_DIRECTORY} -mindepth 1 -maxdepth 1 | grep "BACKUP_"); do
  if [ "$BACKUP_TARGET_DIRECTORY" = "$i" ]; then
    IS_EXISTS_DIRECTORY="TRUE"
    break
  fi
done

if [ "$IS_EXISTS_DIRECTORY" = 'FALSE' ]; then
  LOG_ERROR "BACKUP_TARGET_DIRECTORY(${BACKUP_TARGET_DIRECTORY}) is not exists."
  exit 255
fi
TRACE_END

TRACE_START "LOAD UNIQUE EXTENSIONS IN BACKUP_TARGET_DIRECTORY"
extensions=()
for file in "$BACKUP_TARGET_DIRECTORY"/*; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    extension="${filename##*.}"
    extensions+=("$extension")
  fi
done

echo "${extensions[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ' > $temp_unique_extensions
echo $(
  LOG_INFO "UNIQUE EXTENSIONS:"
  LOG_WARN "$(cat ${temp_unique_extensions})"
)

TRACE_END

TRACE_START "GET EXIST FLAG FILES BACKUPABLE DIRECTORY"
IS_EXIST_DBF='FALSE'
IS_EXIST_CTL='FALSE'
IS_EXIST_LOG='FALSE'
IS_EXIST_ORA='FALSE'
cat $temp_unique_extensions | grep -w 'dbf' > /dev/null; if [ "$?" = "0" ]; then IS_EXIST_DBF='TRUE'; fi
cat $temp_unique_extensions | grep -w 'ctl' > /dev/null; if [ "$?" = "0" ]; then IS_EXIST_CTL='TRUE'; fi
cat $temp_unique_extensions | grep -w 'log' > /dev/null; if [ "$?" = "0" ]; then IS_EXIST_LOG='TRUE'; fi
cat $temp_unique_extensions | grep -w 'ora' > /dev/null; if [ "$?" = "0" ]; then IS_EXIST_ORA='TRUE'; fi
LOG_INFO "IS_EXIST_DBF: ${IS_EXIST_DBF}"
LOG_INFO "IS_EXIST_CTL: ${IS_EXIST_CTL}"
LOG_INFO "IS_EXIST_LOG: ${IS_EXIST_LOG}"
LOG_INFO "IS_EXIST_ORA: ${IS_EXIST_ORA}"
TRACE_END

TRACE_START "GET RESTORE TYPE(BY COLD BACKUP OR HOT BACKUP)"
BACKUP_TYPE=""

if ([ "$IS_EXIST_DBF" = 'TRUE' ] && 
    [ "$IS_EXIST_CTL" = 'TRUE' ] &&
    [ "$IS_EXIST_LOG" = 'TRUE' ] && 
    [ "$IS_EXIST_ORA" = 'TRUE' ]); then BACKUP_TYPE='COLD'; fi

if ([ "$IS_EXIST_DBF" = 'TRUE' ] &&
    [ "$IS_EXIST_CTL" = 'FALSE' ] &&
    [ "$IS_EXIST_LOG" = 'FALSE' ] &&
    [ "$IS_EXIST_ORA" = 'FALSE' ]); then BACKUP_TYPE='HOT'; fi

if [ "$IS_EXIST_DBF" = 'FALSE' ]; then
  LOG_FATAL "No .dbf files in BACKUP_TARGET_DIRECTORY(${BACKUP_TARGET_DIRECTORY})"
  exit 255
fi

LOG_INFO "BACKUP_TYPE: ${BACKUP_TYPE}"
TRACE_END

TRACE_START "GET ORACLE_DATA, ORACLE_DBS"
ORACLE_DATA=$(echo "${ORACLE_BASE}/oradata/${ORACLE_SID}")
ORACLE_DBS=$(echo "${ORACLE_HOME}/dbs")

if [ ! -d $ORACLE_DATA ]; then LOG_ERROR "ORACLE_DATA is not exists.(${ORACLE_DATA})"; exit 127;fi
if [ ! -d $ORACLE_DBS ]; then LOG_ERROR "ORACLE_DBS is not exists.(${ORACLE_DBS})"; exit 127;fi

LOG_INFO "ORACLE_DATA: ${ORACLE_DATA}"
LOG_INFO "ORACLE_DBS: ${ORACLE_DBS}"
TRACE_END

TRACE_START "GET IS NOT YET SHUTDOWN"
IS_OPEN="FALSE"
query="select instance_name, status from v\$instance;"
result="$(
  sh "${MANAGER_PATH}/executeQueryWithLog/executeQueryWithLog.sh"\
  "$query" "$TRACE_CONTEXT" "$logging_file"
)"
if [ "$?" = "0" ]; then
  IS_OPEN="TRUE"
fi
LOG_INFO "IS_OPEN: ${IS_OPEN}"
TRACE_END

if [ "$IS_OPEN" = "TRUE" ]; then
  # FIXME: HOT BACKUP을 활용한 RESTORE가 가능해질 경우, 해당 IF문 제거할것
  # HOT BACKUP을 RESTORE하는 기능을 제공하기 전까지는 shutdown 하기전에 멈추기위함.)
  if [ "$BACKUP_TYPE" = "HOT" ]; then
    ECHO_RED_DOUBLE "BACKUP_TYPE : ${BACKUP_TYPE}"
    TRACE_START "EXECUTE RESTORE USING HOTBACKUP"
    # TODO: online backup을 restore하는 경우는 자세히 소화한 후에 진행 하도록
    echo
    LOG_WARN "Restore using hotbackup is not supported..."
    LOG_WARN "Restore using hotbackup is not supported..."
    LOG_WARN "Restore using hotbackup is not supported..."
    TRACE_END
    exit 255
  fi

  TRACE_START "SHUTDOWN IMMEDIATE"
  query="shutdown immediate;"
  result="$(
    sh "${MANAGER_PATH}/executeQueryWithLog/executeQueryWithLog.sh"\
    "$query" "$TRACE_CONTEXT" "$logging_file" "as sysdba"
  )"
  if [ "$?" = "0" ]; then
    IS_OPEN="FALSE"
  else
    LOG_ERROR "SHUTDOWN IMMEDIATE FAILURE."
    exit 255
  fi
  LOG_INFO "IS_OPEN: ${IS_OPEN}"
  TRACE_END
else
  LOG_WARN "ALREADY SHUTDOWN"
fi

TRACE_START "ONE MORE CHECK BACKUP_TYPE 4 SAFETY RESTORE"
if ([ "$BACKUP_TYPE" != "HOT" ] &&
    [ "$BACKUP_TYPE" != "COLD" ]); then
  LOG_FATAL "An invalid BACKUP_TYPE was received, even though the BACKUP_TYPE was checked beforehand."
  exit 255
fi
TRACE_END


if [ "$BACKUP_TYPE" = "HOT" ]; then
  ECHO_RED_DOUBLE "BACKUP_TYPE : ${BACKUP_TYPE}"
  TRACE_START "EXECUTE RESTORE USING HOTBACKUP"
  # TODO: online backup을 restore하는 경우는 자세히 소화한 후에 진행 하도록
  echo
  LOG_WARN "Restore using hotbackup is not supported..."
  LOG_WARN "Restore using hotbackup is not supported..."
  LOG_WARN "Restore using hotbackup is not supported..."
  TRACE_END
  exit 255
fi

if [ "$BACKUP_TYPE" = "COLD" ]; then
  ECHO_CYAN_DOUBLE "BACKUP_TYPE : ${BACKUP_TYPE}"
  TRACE_START "EXECUTE RESTORE USING COLDBACKUP"
  # TODO: cold backup = every files
  LOG_INFO "ORACLE_DATA: ${ORACLE_DATA}"
  LOG_INFO "ORACLE_DBS: ${ORACLE_DBS}"
  LOG_INFO "BACKUP_TARGET_DIRECTORY: ${BACKUP_TARGET_DIRECTORY}"
  TRACE_END

  TRACE_START "REMOVE FILES ORACLE_DATA, ORACLE_DBS"

  rm -rf ${ORACLE_DATA}/*;
  if [ "$?" != "0" ]; then
    LOG_FATAL "WHEN REMOVE ORACLE_DATA/*"
    exit 255
  fi

  rm -rf ${ORACLE_DBS}/*;
  if [ "$?" != "0" ]; then
    LOG_FATAL "WHEN REMOVE ORACLE_DBS/*"
    exit 255
  fi

  TRACE_END

  TRACE_START "COPY FILES ORACLE_DATA, ORACLE_DBS"

  cp -rf ${BACKUP_TARGET_DIRECTORY}/* ${ORACLE_DATA}/;
  if [ "$?" != "0" ]; then
    LOG_FATAL "WHEN COPY FROM BACKUP_TARGET_DIRECTORY TO ORACLE_DATA"
    exit 255
  fi

  cp -rf ${BACKUP_TARGET_DIRECTORY}/*.ora ${ORACLE_DBS}/;
  if [ "$?" != "0" ]; then
    LOG_FATAL "WHEN COPY FROM BACKUP_TARGET_DIRECTORY TO ORACLE_DBS"
    exit 255
  fi

  rm ${ORACLE_DATA}/*.ora;
  if [ "$?" != "0" ]; then
    LOG_FATAL "WHEN REMOVE .ORA IN ORACLE_DATA"
    exit 255
  fi

  TRACE_END

  TRACE_START "DESCRIBE FILES ORACLE_DATA"
  ls -al $ORACLE_DATA
  TRACE_END

  TRACE_START "DESCRIBE FILES ORACLE_DBS"
  ls -al $ORACLE_DBS
  TRACE_END
fi

TRACE_START "STARTUP OPEN"
query="startup open;"
result="$(
  sh "${MANAGER_PATH}/executeQueryWithLog/executeQueryWithLog.sh"\
  "$query" "$TRACE_CONTEXT" "$logging_file" "as sysdba"
)"
if [ $? -ne 0 ]; then LOG_ERROR "$result"; exit 255; fi
LOG_INFO "$result"
TRACE_END

TRACE_START "CHECK STATUS AFTER STARTUP OPEN"
query="select instance_name, status from v\$instance;"
result="$(
  sh "${MANAGER_PATH}/executeQueryWithLog/executeQueryWithLog.sh"\
  "$query" "$TRACE_CONTEXT" "$logging_file"
)"
if [ $? -ne 0 ]; then LOG_ERROR "$result"; exit 255; fi
LOG_INFO "$result"
TRACE_END

TRACE_START "COMPLETE"
END_SECOND=$(date +%s)
OPERATION_TIME_SECOND=$((END_SECOND - START_SECOND))

LOG_INFO "ORACLE_DATA: ${ORACLE_DATA}"
LOG_INFO "ORACLE_DBS: ${ORACLE_DBS}"
LOG_INFO "BACKUP_TARGET_DIRECTORY: ${BACKUP_TARGET_DIRECTORY}"
LOG_WARN "TOTAL: ${OPERATION_TIME_SECOND}s"
TRACE_END