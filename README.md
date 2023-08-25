[toc]

> 오라클을 운영하면서 필요한 쉘파일

# Project Structure
__management__: 서버 관점에서의 오라클 운영과 관련된 쉘파일

__.etc__: 클라이언트 관점에서의 기타 쉘파일

---

# Project Explain
## Management
### how to use
```shell
# step 1. execute Manager.sh
sh Manager.sh

1  exportTnsnames
2  getDiffDataFiles
3  getInternetProtocolAddress
4  getQueryResultInShell
5  getServiceName
6  sample
Enter number:
# step 2. input number
1

# step 3. done
DB1 = 
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 172.16.229.132)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = DB1)
    )
  )
[oracle@oel7 admin]$ 
```
### services
1. getDiffDataFiles: 모든 datafile과 모든 tempfile들을 논리집합, 물리집합으로 구분하여 누락된 데이터파일과 제거해야할 데이터파일을 색출
1. ~~getQueryResultInShell~~: 쿼리를 전달받아 결과 제공하는 shell
1. log: 쿼리의 결과를 반환하고, 로깅
1. exportTnsnames: 클라이언트에서 접근하기위한 tnsnames.ora 파일에 추가해야할 내용 반환
1. getServicename: Service ID 조회
1. getGapAnalysis: A B 간의 갭 조회

### how to develop
```shell
# step 1. create directory, file
cd "${PROJECT_ROOT}/management"
mkdir new_service
vi new_service.sh

#!/bin/sh
echo "hello world"
:wq

# step 2. register services
echo "new_service" | tee -a .services

# step 3. exeucute service
sh Manager.sh 'new_service'
or
sh Manager.sh
```

## .etc
```shell
# step 1. open git bash(Window)
# step 2. direct execute ${service}.sh
sh Manager.sh
```
**findTnsnamesWindow**: client에서 tnsnames.ora 파일 중 우선순위 가장 높은 파일 검색

**~~getInternetProtocolAddress(window)~~**: ipconfig 결과 가공
---
# TODO
1. db 접속정보 profile export플로우 추가
1. profile 선택하여 실행하도록 수정