
# 코디세이 입학연수 미션1 - 개발 작업실 구축

## 1. 프로젝트 소개

Linux 기본 명령어를 학습하고 Docker를 활용하여 NGINX 웹 서버를 구축한 실습 프로젝트입니다.

직접 명령어를 실행하고 결과를 확인하면서 파일 관리, 컨테이너 운영, 웹 서버 실행, 데이터 저장 방식을 학습했습니다.

## 2. 개발 환경

- Windows 및 WSL2
- Ubuntu 26.04.1 LTS
- ARM64 (aarch64)
- Docker 29.1.3
- NGINX
- HTML

## 3. 프로젝트 구조

```text
codyssey-workstation/
├── Dockerfile
├── README.md
├── site/
│   └── index.html
└── terminal-lab/
    ├── practice.txt
    └── moved-files/
```

## 4. Linux 기본 명령어 실습

다음 명령어를 직접 실행했습니다.

- `pwd` : 현재 작업 위치 확인
- `ls -la` : 파일과 폴더 목록 확인
- `mkdir` : 폴더 생성
- `cd` : 폴더 이동
- `touch` : 빈 파일 생성
- `echo` : 문자 출력 및 파일 내용 작성
- `cat` : 파일 내용 확인
- `cp` : 파일 복사
- `mv` : 파일 이동 및 이름 변경
- `rm` : 파일 삭제
- `chmod` : 파일 및 폴더 권한 변경

### 파일 및 폴더 권한 변경 결과

| 대상 | 변경 전 | 변경 후 |
|---|---|---|
| practice.txt | 644 | 600 |
| moved-files | 755 | 700 |

실행한 명령어:

```bash
chmod 600 practice.txt
chmod 700 moved-files
```

`ls -l`과 `ls -ld`를 이용하여 권한 변경 전후를 확인했습니다.

## 5. Docker 설치 및 실행

Ubuntu에서 Docker를 설치하고 버전을 확인했습니다.

```bash
sudo apt update
sudo apt install docker.io
docker --version
sudo docker info
```

Docker 버전 확인 결과:

```text
Docker version 29.1.3, build 29.1.3-0ubuntu4.1
```

### 기본 컨테이너 실습

```bash
sudo docker run hello-world
sudo docker images
sudo docker ps -a
sudo docker run -it --name ubuntu-lab ubuntu bash
```

`hello-world` 실행 시 정상 메시지를 확인했습니다.

Ubuntu 컨테이너 내부에서 `ls`와 `echo` 명령어를 실행했습니다.

이후 `docker start`, `docker stop`, `docker exec`, `docker attach`를 실습했습니다.

`docker logs`와 `docker stats`를 이용하여 웹 서버의 로그와 자원 사용량도 확인했습니다.

## 6. Dockerfile과 웹 서버 제작

NGINX 기반 Dockerfile을 작성했습니다.

```dockerfile
FROM nginx:alpine

LABEL org.opencontainers.image.title="codyssey-my-web"

COPY site/ /usr/share/nginx/html/

EXPOSE 80
```

### 이미지 빌드

프로젝트 최상위 폴더에서 실행합니다.

```bash
sudo docker build -t codyssey-my-web:1.0 .
```

### 웹 서버 실행

```bash
sudo docker run -d --name codyssey-web -p 8080:80 codyssey-my-web:1.0
```

Windows 브라우저에서 다음 주소로 접속했습니다.

http://localhost:8080

직접 작성한 HTML 웹페이지가 정상적으로 표시되는 것을 확인했습니다.

## 7. 바인드 마운트 실습

Ubuntu의 site 폴더를 NGINX 컨테이너와 연결했습니다.

```bash
sudo docker run -d --name codyssey-bind -p 8081:80 -v "$(pwd)/site:/usr/share/nginx/html:ro" codyssey-my-web:1.0
```

HTML 파일을 수정한 후 웹페이지를 비교했습니다.

- 8080번: 기존 HTML 내용 유지
- 8081번: 수정한 HTML 내용 반영

Docker 이미지를 다시 빌드하지 않고도 바인드 마운트를 통해 수정 사항이 반영되는 것을 확인했습니다.

## 8. Docker 볼륨 실습

Docker가 관리하는 볼륨을 생성했습니다.

```bash
sudo docker volume create codyssey-data
sudo docker volume ls
```

첫 번째 임시 컨테이너에서 볼륨에 파일을 저장했습니다.

```bash
sudo docker run --rm -v codyssey-data:/data ubuntu:latest sh -c 'echo "Codyssey volume test" > /data/volume-test.txt && cat /data/volume-test.txt'
```

새로운 임시 컨테이너에서 같은 파일을 읽었습니다.

```bash
sudo docker run --rm -v codyssey-data:/data ubuntu:latest cat /data/volume-test.txt
```

확인된 출력:

```text
Codyssey volume test
```

컨테이너가 삭제되어도 별도로 관리하는 Docker 볼륨에는 데이터가 유지되는 것을 확인했습니다.

## 9. 실습 결과

- Linux 기본 파일 관리 실습 완료
- 파일과 폴더 권한 변경 확인
- Docker 설치 및 hello-world 실행 성공
- Ubuntu 컨테이너 운영 실습 완료
- Dockerfile 이미지 빌드 성공
- NGINX 웹 서버 브라우저 접속 성공
- 바인드 마운트 변경 사항 반영 확인
- Docker 볼륨 데이터 영속성 확인

## 10. 배운 점

이번 실습을 통해 Linux에서 파일과 폴더를 관리하는 방법을 경험했습니다.

Dockerfile은 이미지를 만드는 설명서이고, Docker 이미지는 컨테이너 실행에 필요한 패키지라는 것을 배웠습니다.

컨테이너를 실행하여 웹 서버를 만들고, 바인드 마운트와 볼륨을 통해 데이터가 관리되는 방식을 직접 확인했습니다.



## 11. Git 및 GitHub 연동

Git을 이용하여 프로젝트 변경 이력을 관리하고
GitHub 공개 저장소에 파일을 업로드했습니다.

- Git 버전: 2.53.0
- 작업 환경: Windows 11, WSL2 Ubuntu, Bash
- 브랜치: main
- GitHub 저장소: https://github.com/sner0906-ui/codyssey-workstation

### VS Code와 GitHub 연결

VS Code를 WSL: Ubuntu 환경으로 실행했습니다.

GitHub 계정으로 로그인한 뒤,
VS Code에서 Git 저장소와 main 브랜치를 확인했습니다.

VS Code 터미널에서 다음 명령어를 실행했습니다.

```bash
git remote -v
```

확인된 출력:

```text
origin  https://github.com/sner0906-ui/codyssey-workstation.git (fetch)
origin  https://github.com/sner0906-ui/codyssey-workstation.git (push)
```

이를 통해 현재 프로젝트가 GitHub 저장소와
연결되어 있음을 확인했습니다.



## 12. 실습 중 발생한 오류와 해결 과정

### 오류 1. Git 커밋 시 사용자 정보 오류

**문제:** 처음 `git commit`을 실행했을 때 Git 사용자 정보가 설정되지 않아 커밋이 실패했습니다.

**원인 추정:** Git이 커밋 작성자의 이름과 이메일을 확인하지 못했기 때문입니다.

**확인:** 터미널에서 Git이 사용자 정보를 설정하라는 오류 메시지를 표시했습니다.

**해결:** 프로젝트에서 `git config --local` 명령어를 사용하여 사용자 이름과 GitHub 비공개 이메일 주소(noreply)를 설정했습니다.

**결과:** 사용자 정보를 설정한 뒤 커밋을 다시 실행하여 성공했고, GitHub 저장소에도 업로드했습니다.

**배운 점:** Git은 파일 변경 내용을 저장할 때 누가 작성한 기록인지 구분하기 위해 이름과 이메일 정보가 필요합니다.



### 오류 2. GitHub 인증 실패

**문제:** 처음 `git push`로 프로젝트를 GitHub에 업로드하려고 했을 때 인증 오류가 발생했습니다.

**오류 메시지:** `Invalid username or token`

**원인 추정:** GitHub 인증 과정에서 사용자 이름과 개인 접근 토큰(PAT)을 입력하는 위치를 혼동했습니다.

**확인:** 인증 오류 메시지를 확인하고 GitHub 사용자 이름과 토큰 입력 방식을 점검했습니다.

**해결:**
- 사용자 이름과 토큰을 올바른 입력 위치에 사용하도록 수정했습니다.
- 인증 과정에서 노출된 기존 토큰은 보안을 위해 폐기했습니다.
- 새로운 토큰을 발급받아 필요한 연결 설정을 다시 진행했습니다.

**결과:** 인증 문제를 해결하여 GitHub 저장소에 프로젝트를 업로드했습니다.

**배운 점:** GitHub 인증에는 올바른 계정 정보가 필요하며, 개인 접근 토큰은 비밀번호처럼 안전하게 관리해야 합니다. 토큰이 노출되면 폐기하고 새로 발급받아야 합니다.



## 13. Docker 명령어 실행 결과

### 1) Docker 이미지 목록 확인

실행 명령어:

```bash
sudo docker images
```

실제 출력에서 주요 열을 정리한 결과:

```text
IMAGE                 DISK USAGE  CONTENT SIZE
codyssey-my-web:1.0   93.2MB      26.3MB
hello-world:latest    22.6kB      10.3kB
nginx:alpine          94.1MB      27.2MB
ubuntu:latest         181MB       44.9MB
```

직접 빌드한 `codyssey-my-web:1.0` 이미지가
Docker 이미지 목록에 저장되어 있음을 확인했습니다.



### 2) Docker 컨테이너 목록 확인

실행 명령어:

```bash
sudo docker ps -a
```

실제 출력에서 주요 항목을 정리한 결과:

| 컨테이너 이름 | 이미지 | 상태 | 포트 |
|---|---|---|---|
| codyssey-bind | codyssey-my-web:1.0 | Up 5 hours | 8081 → 80 |
| codyssey-web | codyssey-my-web:1.0 | Up 5 hours | 8080 → 80 |
| ubuntu-lab | ubuntu | Exited (137) | 없음 |
| romantic_moore | hello-world | Exited (0) | 없음 |

**확인 결과:**
- NGINX 웹 서버 컨테이너 2개가 실행 중이었습니다.
- 웹 서버는 8080번, 바인드 마운트 실습은 8081번 포트를 사용했습니다.
- Ubuntu 실습과 hello-world 컨테이너는 종료된 상태였습니다.
- `docker ps -a`를 통해 실행 중인 컨테이너와 종료된 컨테이너를 모두 확인할 수 있었습니다.



### 3) Docker 웹 서버 로그 확인

실행 명령어:

```bash
sudo docker logs --tail 20 codyssey-web
```

실제 출력에서 주요 로그를 발췌했습니다.

```text
[notice] nginx/1.31.8
"GET / HTTP/1.1" 200 384
"GET /favicon.ico HTTP/1.1" 404 555
"GET / HTTP/1.1" 304 0
```

**확인 결과:**
- NGINX 웹 서버가 실행된 기록을 확인했습니다.
- `GET /` 요청의 응답 코드가 `200`으로 나타나 웹페이지 접속에 성공했음을 확인했습니다.
- `304`는 브라우저 캐시를 활용하는 정상 응답입니다.
- `favicon.ico` 파일이 없어 `404`가 발생했지만, 홈페이지 접속에는 문제가 없었습니다.

**배운 점:**
`docker logs`를 사용하면 컨테이너 내부 프로그램의 실행 상태와 접속 기록을 확인할 수 있습니다.



### 4) Docker 자원 사용량 확인

실행 명령어:

```bash
sudo docker stats --no-stream codyssey-web
```

실제 측정 결과:

```text
NAME           CPU %   MEM USAGE / LIMIT      MEM %   PIDS
codyssey-web   0.00%   11.59MiB / 7.548GiB   0.15%   11
```

**확인 결과:**
- `codyssey-web` 컨테이너의 CPU 사용률은 0.00%였습니다.
- 메모리는 11.59MiB를 사용하고 있었습니다.
- 메모리 사용률은 0.15%였습니다.
- 실행 중인 프로세스 수는 11개였습니다.

**배운 점:**
`docker stats`는 실행 중인 컨테이너의 CPU, 메모리,
네트워크 사용량 등을 확인하는 명령어입니다.

`--no-stream` 옵션을 사용하면 자원 사용량을
한 번만 측정하고 명령어가 종료됩니다.

측정값은 실행 시점에 따라 달라질 수 있습니다.



### 5) Docker 실행 환경 확인

실행 명령어:

```bash
sudo docker info
```

실제 출력에서 주요 항목을 발췌했습니다.

```text
Client:
 Version: 29.1.3

Server:
 Containers: 4
  Running: 2
  Paused: 0
  Stopped: 2
 Images: 6
 Server Version: 29.1.3
 Storage Driver: overlayfs
 Logging Driver: json-file
```

**확인 결과:**
- Docker 클라이언트와 서버 버전은 모두 29.1.3이었습니다.
- 컨테이너 4개 중 2개가 실행 중이고 2개는 종료된 상태였습니다.
- Docker 서버가 이미지 6개를 집계하고 있었습니다.
- Docker 서버가 정상적으로 정보를 반환하는 것을 확인했습니다.

**배운 점:**
`docker info`를 사용하면 Docker의 실행 환경과
컨테이너, 이미지, 저장 방식 등을 확인할 수 있습니다.



## 14. 웹 서버 실행 증빙

### 1) 기본 NGINX 웹 서버 (8080번)

Docker 이미지에 포함된 HTML 파일을 웹브라우저에서 확인했습니다.

![8080번 웹 서버 실행 화면](evidence/8080-web.png)

### 2) 바인드 마운트 웹 서버 (8081번)

Ubuntu의 `site/index.html` 파일을 수정한 뒤,
이미지를 다시 빌드하지 않고 변경 내용이 반영되는 것을 확인했습니다.

![8081번 바인드 마운트 실행 화면](evidence/8081-bind.png)

### 3) 두 웹페이지 비교

- **8080번:** 이미지 제작 당시의 기존 HTML 내용 표시
- **8081번:** 수정한 HTML 내용이 바로 반영됨

이를 통해 바인드 마운트가 호스트의 파일을
컨테이너와 연결하는 기능임을 확인했습니다.


## 15. VS Code와 GitHub 연동 증빙

VS Code를 WSL: Ubuntu 환경에서 실행하고
GitHub 계정으로 로그인했습니다.

GitHub 메뉴에서 Pull Requests와 Issues 항목을 확인했으며,
터미널에서 `git remote -v` 명령어를 실행하여
프로젝트의 GitHub 저장소 연결 주소를 확인했습니다.

![VS Code와 GitHub 연동 화면](evidence/github-vscode.png)

GitHub 저장소:
https://github.com/sner0906-ui/codyssey-workstation



### 6) Docker 볼륨 데이터 유지 재확인

기존에 생성한 `codyssey-data` 볼륨에 저장된 파일을
새로운 임시 컨테이너에서 다시 읽었습니다.

실행 명령어:

```bash
sudo docker run --rm -v codyssey-data:/data ubuntu:latest cat /data/volume-test.txt
```

실제 출력:

```text
Codyssey volume test
```

**확인 결과:**
- 기존 볼륨에 저장한 파일을 정상적으로 읽었습니다.
- `--rm` 옵션으로 임시 컨테이너가 종료 후 삭제되어도
  Docker 볼륨의 데이터는 유지됩니다.

**배운 점:**
Docker 볼륨은 컨테이너와 별도로 데이터를 관리하므로
컨테이너를 삭제한 뒤에도 필요한 데이터를 보관할 수 있습니다.
