# 03. Docker 설치 점검 및 기본 운영 로그

> Docker Desktop for Mac / Server 29.6.2

## 1) 설치 점검

```bash
$ docker --version
Docker version 29.4.0, build 9d7ad9f
```

`docker info`로 데몬 동작 여부 점검 (출력 발췌):

```bash
$ docker info | head -30
Client:
 Version:    29.4.0
 Context:    orbstack
 Debug Mode: false
 Plugins:
  buildx: Docker Buildx (Docker Inc.)
    Version:  v0.33.0
    Path:     /Users/dooolll5969/.docker/cli-plugins/docker-buildx
  compose: Docker Compose (Docker Inc.)
    Version:  v5.1.2
    Path:     /Users/dooolll5969/.docker/cli-plugins/docker-compose
  ...
```

> 참고: 최초 점검 시 `Cannot connect to the Docker daemon at unix:///Users/newid/.docker/run/docker.sock` 오류 발생 → Docker Desktop 기동으로 해결. 상세 내용은 [README 트러블슈팅 #1](../../README.md#8-트러블슈팅) 참조.

## 2) hello-world 실행

```bash
$ docker run --rm hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
4f55086f7dd0: Pull complete
d5e71e642bf5: Download complete 
Digest: sha256:c3cbe1cc1aa588a64951ac6286e0df7b27fe2e6324b1001c619bb358770c0178
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (arm64v8)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
$ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

## 3) 이미지 다운로드 및 목록 확인

```bash
$ docker pull ubuntu:24.04
24.04: Pulling from library/ubuntu
966c395d29cb: Pull complete
4029a2d69959: Download complete 
Digest: sha256:561618e2c15bf2397621dd04f96926663a3b5616c189cf7e38db7e82f5c538ea
Status: Downloaded newer image for ubuntu:24.04
docker.io/library/ubuntu:24.04

$ docker images | grep -E "IMAGE|ubuntu|hello-world"
IMAGE                ID             DISK USAGE   CONTENT SIZE   EXTRA   
hello-world:latest   c3cbe1cc1aa5       21.8kB         9.49kB        
ubuntu:24.04         561618e2c15b        117MB         31.7MB 
```

> 미션과 무관한 개인 프로젝트 이미지는 출력에서 제외(grep 필터)했다.

## 4-3. ubuntu 컨테이너 실행과 내부 진입

**방법 A — 대화형으로 직접 진입 (attach 계열):**

```bash
$ docker run -it --name mission1-ubuntu-a ubuntu:24.04 bash
root@dd982431ce76:/$ ls /
bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
root@dd982431ce76:/$ echo 'hello from inside container'
hello from inside container
root@dd982431ce76:/$ cat /etc/os-release
PRETTY_NAME="Ubuntu 24.04.4 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.4 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo
root@dd982431ce76:/# exit

$ exit

$ docker ps -a --filter name=mission1
CONTAINER ID   IMAGE          COMMAND   CREATED          STATUS                      PORTS     NAMES
dd982431ce76   ubuntu:24.04   "bash"    44 seconds ago   Exited (0) 14 seconds ago             mission1-ubuntu-a
```

**방법 B — 백그라운드 실행 후 exec로 진입:**

```bash
$ docker run -d --name mission1-ubuntu ubuntu:24.04 sleep infinity
6640b7bba8c2fe8ada03c42af148e60848384903c25c87fd5b91d32353372675

$ docker exec mission1-ubuntu ls /
bin
boot
dev
etc
home
lib
lib64
media
mnt
opt
proc
root
run
sbin
srv
sys
tmp
usr
var

$ docker exec mission1-ubuntu echo 'hello from inside container'
hello from inside container

$ docker ps --filter name=mission1
CONTAINER ID   IMAGE          COMMAND            CREATED          STATUS          PORTS     NAMES
6640b7bba8c2   ubuntu:24.04   "sleep infinity"   19 seconds ago   Up 19 seconds             mission1-ubuntu
```

## 5) 컨테이너 종료/유지 관찰 — run vs exec

```bash
$ docker run --name mission1-oneshot ubuntu:24.04 echo 'one-shot done'
one-shot done

$ docker ps -a --filter name=mission1
CONTAINER ID   IMAGE          COMMAND                  CREATED              STATUS                      PORTS     NAMES
958f7ba8a450   ubuntu:24.04   "echo 'one-shot done'"   6 seconds ago        Exited (0) 5 seconds ago              mission1-oneshot
6640b7bba8c2   ubuntu:24.04   "sleep infinity"         32 seconds ago       Up 31 seconds                         mission1-ubuntu
dd982431ce76   ubuntu:24.04   "bash"                   About a minute ago   Exited (0) 56 seconds ago             mission1-ubuntu-a
```

**관찰 정리:**
- 컨테이너의 수명 = **메인 프로세스(PID 1)의 수명**이다.
  - `echo`를 메인으로 실행한 `mission1-oneshot`은 명령이 끝나자 즉시 `Exited (0)` 상태가 됐다.
  - `sleep infinity`를 메인으로 실행한 `mission1-ubuntu`는 계속 `Up` 상태를 유지했다.
- `docker exec`는 **이미 실행 중인 컨테이너에 별도 프로세스를 추가**하는 것이라, exec로 실행한 명령이 끝나도 컨테이너는 종료되지 않는다.
- `docker attach`는 메인 프로세스(PID 1)의 입출력에 직접 붙는 것이라, attach 상태에서 프로세스를 종료하면 컨테이너 자체가 종료된다. (exec는 안전, attach는 주의)

## 6) 운영 명령 — logs / stats / stop

```bash
$ docker logs mission1-oneshot
one-shot done

$ docker stats --no-stream mission1-ubuntu
CONTAINER ID   NAME              CPU %     MEM USAGE / LIMIT   MEM %     NET I/O         BLOCK I/O     PIDS
6640b7bba8c2   mission1-ubuntu   0.00%     396KiB / 15.67GiB   0.00%     1.17kB / 126B   1.84MB / 0B   1

$ docker stop mission1-ubuntu
docker ps -a --filter name=mission1
mission1-ubuntu

$ docker ps -a --filter name=mission1
CONTAINER ID   IMAGE          COMMAND                  CREATED              STATUS                                PORTS     NAMES
958f7ba8a450   ubuntu:24.04   "echo 'one-shot done'"   40 seconds ago       Exited (0) 39 seconds ago                       mission1-oneshot
6640b7bba8c2   ubuntu:24.04   "sleep infinity"         About a minute ago   Exited (137) Less than a second ago             mission1-ubuntu
dd982431ce76   ubuntu:24.04   "bash"                   2 minutes ago        Exited (0) About a minute ago                   mission1-ubuntu-a
```
