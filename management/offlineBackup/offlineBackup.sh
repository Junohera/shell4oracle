#!/bin/sh

# SET TRACE
TRACE_CONTEXT=""
TRACE_START () { 
  TRACE_CONTEXT="$1"
  LOG_TRACE "::: ${TRACE_CONTEXT} START :::";
}
TRACE_END () {
  LOG_TRACE "::: ${TRACE_CONTEXT} COMPLETE :::";
}

TRACE_START "LOAD PROFILE START"
. loadProfile/loadProfile.sh system
TRACE_END

TRACE_START "LOGGING FILE INITIALIZING"
prefix="$(echo $0 | awk -F"/" '{print $1}')"
cd $prefix
logging_directory="${MANAGER_PATH}/${prefix}/.log"
logging_file="${logging_directory}/$(echo $(date +%Y%m%d%H%M)).txt"
if [ ! -d logging_directory ]; then mkdir -p $logging_directory; fi
if [ ! -f logging_file ]; then touch $logging_file; fi
TRACE_END

TRACE_START "READ CONFIG FILE"
config="${MANAGER_PATH}/offlineBackup/.config"
BACKUP_DIRECTORY=$(cat $config | sed '/^#/d' | grep 'BACKUP_DIRECTORY=' | awk -F= '{print $NF}');
ORACLE_DATA=$(cat $config | sed '/^#/d' | grep 'ORACLE_DATA=' | awk -F= '{print $NF}');
ORACLE_DBS=$(cat $config | sed '/^#/d' | grep 'ORACLE_DBS=' | awk -F= '{print $NF}');
TRACE_END

TRACE_START "VALIDATION DIRECTORY BY CONFIG FILE"
if [ -z $BACKUP_DIRECTORY ];  then LOG_ERROR "BACKUP_DIRECTORY is not defined. (.config)"; exit 1; fi
if [ -z $ORACLE_DATA ];       then LOG_ERROR "ORACLE_DATA is not defined. (.config)";      exit 1; fi
if [ -z $ORACLE_DBS ];        then LOG_ERROR "ORACLE_DBS is not defined. (.config)";       exit 1; fi
TRACE_END

TRACE_START "CHECK BACKUP_DIRECTORY"
if ! [ -d $BACKUP_DIRECTORY ]; then
  LOG_ERROR "$BACKUP_DIRECTORY is not directory."
  echo -n $(LOG_INFO "If you want that directory to be created, type Enter.(mkdir -p ${BACKUP_DIRECTORY})")
  read is_create_backup_directory

  if ! [ -z $is_create_backup_directory ]; then
    LOG_INFO "The End."
    exit 1
  fi

  mkdir -p ${BACKUP_DIRECTORY}
  if [ $? -ne 0 ]; then
    LOG_ERROR "su - root"
    LOG_ERROR "mkdir -p ${BACKUP_DIRECTORY}"
    LOG_ERROR "chown -R oracle:oinstall ${BACKUP_DIRECTORY}"
    exit 1
  fi
fi
TRACE_END

TRACE_START "CHECK ORACLE_DATA, ORACLE_DBS"
ls $ORACLE_DATA | grep ".dbf" > /dev/null
IS_EXIST_DBF=$(echo $?)
ls $ORACLE_DATA | grep ".ctl" > /dev/null
IS_EXIST_CTL=$(echo $?)
ls $ORACLE_DATA | grep ".log" > /dev/null
IS_EXIST_LOG=$(echo $?)
ls $ORACLE_DBS | grep ".ora" > /dev/null
IS_EXIST_ORA=$(echo $?)

if [ $IS_EXIST_DBF -ne 0 ]; then LOG_ERROR "NOT EXISTS ($ORACLE_DATA/*.dbf)"; exit 127; fi
if [ $IS_EXIST_CTL -ne 0 ]; then LOG_ERROR "NOT EXISTS ($ORACLE_DATA/*.ctl)"; exit 127; fi
if [ $IS_EXIST_LOG -ne 0 ]; then LOG_ERROR "NOT EXISTS ($ORACLE_DATA/*.log)"; exit 127; fi
if [ $IS_EXIST_ORA -ne 0 ]; then LOG_ERROR "NOT EXISTS ($ORACLE_DBS/*.ora)"; exit 127; fi

LOG_INFO "BACKUP_DIRECTORY: ${BACKUP_DIRECTORY}"
LOG_INFO "ORACLE_DATA: ${ORACLE_DATA}"
LOG_INFO "ORACLE_DBS: ${ORACLE_DBS}"
TRACE_END

TRACE_START "CREATE BACKUP_ID"
BACKUP_ID="BACKUP_$(date +%Y%m%d%H%M)"
LOG_INFO "BACKUP_ID: ${BACKUP_ID}"
TRACE_END

TRACE_START "CREATE BACKUP_TARGET_DIRECTORY"
BACKUP_TARGET_DIRECTORY="${BACKUP_DIRECTORY}/${BACKUP_ID}"
mkdir -p $BACKUP_TARGET_DIRECTORY
LOG_INFO "BACKUP_TARGET_DIRECTORY: ${BACKUP_TARGET_DIRECTORY}"
TRACE_END

TRACE_START "READY BACKUP CONTROL FILE PATH"
BACKUP_CONTROLFILE_PATH="$BACKUP_TARGET_DIRECTORY/control.sql"
BACKUP_CONTROLFILE_PATH_FOR_QUERY="'"$BACKUP_TARGET_DIRECTORY/control.sql"'"
if [ -f $BACKUP_CONTROLFILE_PATH ]
then
  rm $BACKUP_CONTROLFILE_PATH
fi
TRACE_END

TRACE_START "CHECK STATUS BEFORE EXECUTE QUERY"
query="select instance_name, status from v\$instance;"
result="$(
  sh "${MANAGER_PATH}/executeQueryWithLog/executeQueryWithLog.sh"\
  "$query" "$TRACE_CONTEXT" "$logging_file"
)"
if [ $? -ne 0 ]; then LOG_ERROR "$result"; exit 255; fi
TRACE_END

TRACE_START "EXECUTE QUERY FOR BACKUP CONTROL FILE GENERATION SCRIPT"
query="alter database backup controlfile to trace as $BACKUP_CONTROLFILE_PATH_FOR_QUERY;"
result="$(
  sh "${MANAGER_PATH}/executeQueryWithLog/executeQueryWithLog.sh"\
  "$query" "$TRACE_CONTEXT" "$logging_file"
)"
if [ $? -ne 0 ]; then
  LOG_ERROR "$result"
  LOG_INFO "when Permission denied (chown -R oracle:oinstall $BACKUP_DIRECTORY)"
  exit 255
fi
LOG_INFO "BACKUP_CONTROLFILE_PATH: $(ls $BACKUP_CONTROLFILE_PATH)"
TRACE_END

TRACE_START "SHUTDOWN IMMEDIATE"
query="shutdown immediate;"
result="$(
  sh "${MANAGER_PATH}/executeQueryWithLog/executeQueryWithLog.sh"\
  "$query" "$TRACE_CONTEXT" "$logging_file" "as sysdba"
)"
if [ $? -ne 0 ]; then LOG_ERROR "$result"; exit 255; fi
LOG_INFO "$result"
TRACE_END

TRACE_START "PHYSICAL BACKUP"
ECHO_RED_GLOW "TODO: FROM physical backup"
TRACE_END

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