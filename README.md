[toc]

# Client
## findTnsnamesWindow
client에서 tnsnames.ora 파일 중 우선순위 가장 높은 파일 검색
## ~~getInternetProtocolAddress(window)~~
ipconfig 결과 가공

# Server
## getDiffDataFiles
모든 datafile과 모든 tempfile들을 논리집합, 물리집합으로 구분하여 누락된 데이터파일과 제거해야할 데이터파일을 색출
## ~~getQueryResultInShell~~
쿼리를 전달받아 결과 제공하는 shell
## log
쿼리의 결과를 반환하고, 로깅
## exportTnsnames
클라이언트에서 접근하기위한 tnsnames.ora 파일에 추가해야할 내용 반환
## getServicename
Service ID 조회
## getGapAnalysis
A B 간의 갭 조회

---
# TODO
1. server디렉토리 제거
1. agent.sh는 runner나 다른 이름으로 변경
1. db 접속정보 profile export플로우 추가
1. runner 이용시 profile 선택하여 실행하도록 수정
1. profiles 폴더만들고 유저별 접속정보추가