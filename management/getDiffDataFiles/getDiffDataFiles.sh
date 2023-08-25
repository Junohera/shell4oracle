#!/bin/sh

CURRENT_PATH=$(dirname $(realpath $0))
cd $CURRENT_PATH || exit

echo "$CURRENT_PATH"
echo "$"

. "${MANAGER_PATH}/loadProfile/loadProfile.sh" system

prefix="$(echo $0 | awk -F"/" '{print $1}')"

if [ ! -d .temp ]; then mkdir .temp; fi
directories=".temp/${prefix}.directories"
physicals=".temp/${prefix}.physical"
logicals=".temp/${prefix}.logical"
delete_target=".temp/${prefix}.delete_target"
missing_target=".temp/${prefix}.missing_target"

# load distinct directories by query
loadDirectoriesByQuery() {
  query="
  select distinct substr(file_name, 1, instr(file_name, '/', -1) - 1) as datafile_directory
    from (select 'data' as type, file_name, file_id
            from dba_data_files
           union all
          select 'temp' as type, file_name, file_id
            from dba_temp_files
           order by type, file_id);
  "
  result=$(sh "${MANAGER_PATH}/executeQueryWithLog/executeQueryWithLog.sh" "$query")
  
  echo "$result" > $directories
}
# load physical datafiles
loadPhysicalDatafiles() {
  > $physicals
  while IFS= read -r directory;
  do
    find $directory -maxdepth 1 -mindepth 1 -type f -name "*.dbf" >> $physicals
  done < $directories
}
# load logical datafiles
loadLogicalDatafiles() {
	> $logicals
  query="
  select file_name
    from (select 'data' as type, file_name, file_id
            from dba_data_files
           union all
          select 'temp' as type, file_name, file_id
            from dba_temp_files
           order by type, file_id);
  "
  result=$(sh "${MANAGER_PATH}/executeQueryWithLog/executeQueryWithLog.sh" "$query")
  
  echo "$result" > $logicals
}
# get delete target: physical minus logical
getDeleteTargets() {
  > "${delete_target}"

  echo "select path from (select null as path from dual" >> "${delete_target}"
  while IFS= read -r line;
  do
		with_single_quotation="'$line'"
    echo " union all select ${with_single_quotation} from dual" >> "${delete_target}"
  done < "$logicals"
  echo ") where path is not null"  >> "${delete_target}"

  echo " minus" >> "${delete_target}"

  echo "select path from (select null as path from dual" >> "${delete_target}"
  while IFS= read -r line;
  do
		with_single_quotation="'$line'"
		echo " union all select ${with_single_quotation} from dual" >> "${delete_target}"
  done < "$physicals"
  echo ") where path is not null"  >> "${delete_target}"

  echo ";" >> "${delete_target}"

  result=$(sh "${MANAGER_PATH}/executeQueryWithLog/executeQueryWithLog.sh" "$(cat "${delete_target}")" "GET_DELETE_TARGETS(LOGICAL-PHYSICAL)")
  echo "$result"
}
# get missing target: logical minus physical
getMissingTargets() {
  > "${missing_target}"

  echo "select path from (select null as path from dual" >> "${missing_target}"
  while IFS= read -r line;
  do
		with_single_quotation="'$line'"
		echo " union all select ${with_single_quotation} from dual" >> "${missing_target}"
  done < "$physicals"
  echo ") where path is not null"  >> "${missing_target}"

  echo " minus" >> "${missing_target}"

  echo "select path from (select null as path from dual" >> "${missing_target}"
  while IFS= read -r line;
  do
		with_single_quotation="'$line'"
    echo " union all select ${with_single_quotation} from dual" >> "${missing_target}"
  done < "$logicals"
  echo ") where path is not null"  >> "${missing_target}"

  echo ";" >> "${missing_target}"

  result=$(sh "${MANAGER_PATH}/executeQueryWithLog/executeQueryWithLog.sh" "$(cat "${missing_target}")" "GET_MISSING_TARGETS(PHYSICAL-LOGICAL)")
  echo "$result"
}

loadDirectoriesByQuery
loadPhysicalDatafiles
loadLogicalDatafiles
getDeleteTargets
getMissingTargets