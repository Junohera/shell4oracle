# Sample
```shell
# 1. move manager_path
cd $MANAGER_PATH;
# 2. load profile
. loadProfile/loadProfile.sh system
# 3. ready query
query="
  select 0 + level
    from dual
 connect by level >= 10;  
"
# 4. execute
result=$(sh "executeQueryWithLog/executeQueryWithLog.sh" "$query")
# 5. echo
echo "$result"
```
# Purpose
- 단순한 연동법으로 복잡한 절차 단순화(관심사를 쿼리작성과 결과값을 이용하는데에 집중하도록 분리)
- shell을 통해 연동한 정보 실시간 기록(접속정보, 쿼리정보, 성공/실패여부, 결과값)


