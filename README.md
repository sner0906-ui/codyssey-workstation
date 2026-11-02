
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
