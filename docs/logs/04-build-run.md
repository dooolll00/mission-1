# 04. 커스텀 이미지 빌드 & 포트 매핑 로그

## 1) 선택한 베이스와 커스텀 포인트

- **선택 방식**: (A) 웹 서버 베이스 이미지 활용 — `nginx:alpine` + 정적 콘텐츠/설정 교체
- **Dockerfile**: [/Dockerfile](../../Dockerfile) (직접 작성)

| 커스텀 포인트 | 목적 |
|---------------|------|
| `LABEL org.opencontainers.image.*` | 이미지 메타데이터 — 어떤 이미지인지 식별 가능하게 |
| `ENV APP_ENV=dev` | 설정과 코드의 분리 연습 (환경 변수 주입) |
| `COPY app/ /usr/share/nginx/html/` | nginx 기본 페이지를 내 정적 콘텐츠로 교체 |
| `EXPOSE 80` | 사용 포트 문서화 (실제 개방은 `-p`가 담당) |
| `HEALTHCHECK` | 서버 응답 여부를 컨테이너 스스로 점검 |

## 2) 빌드

```bash
$ docker build -t mission1-web:1.0 .
[+] Building 7.7s (7/7) FINISHED                                                                                         docker:orbstack
 => [internal] load build definition from Dockerfile                                                                                0.2s
 => => transferring dockerfile: 274B                                                                                                0.0s
 => [internal] load metadata for docker.io/library/nginx:alpine                                                                     2.1s
 => [internal] load .dockerignore                                                                                                   0.2s
 => => transferring context: 2B                                                                                                     0.0s
 => [internal] load build context                                                                                                   0.4s
 => => transferring context: 340B                                                                                                   0.0s
 => [1/2] FROM docker.io/library/nginx:alpine@sha256:4a73073bd557c65b759505da037898b61f1be6cbcc3c2c3aeac22d2a470c1752               3.3s
 => => resolve docker.io/library/nginx:alpine@sha256:4a73073bd557c65b759505da037898b61f1be6cbcc3c2c3aeac22d2a470c1752               0.2s
 => => sha256:46519e7231d2eb5604df229beb44d59719a489eaa7aca52982535a010b07a9ed 20.31MB / 20.31MB                                    0.5s
 => => sha256:390dc935348d8070e695fbaae2a4bb114fb9e69c59f628e7576036ee9d5244c9 1.40kB / 1.40kB                                      0.4s
 => => sha256:d0008c891db48b5f526d914bce9e8d889fe1a9d1f08291ae03fe97f871726f38 1.21kB / 1.21kB                                      0.6s
 => => sha256:46f977ee452f4399c208714afa034868d6056864f8a0cf3c643ab143dd802c80 404B / 404B                                          0.6s
 => => sha256:62bec68d7c31c4c8a19d812d84da5f7748e54690c037979945b6c5b6c924b142 957B / 957B                                          0.2s
 => => sha256:1223f016b4e4a2c21f7c49d4837fbfd47a9da6436b511690ca1e582fc2810d59 627B / 627B                                          0.3s
 => => sha256:3cd534fe98c64d68a1f4f1c83abb8d5cba7ecfd7be88e592389929d12e6253da 1.89MB / 1.89MB                                      0.3s
 => => sha256:55afa1ecc21d2bb5e5045f32dafee56272ffd89860bac26f6c32123439af26a4 3.85MB / 3.85MB                                      0.3s
 => => extracting sha256:55afa1ecc21d2bb5e5045f32dafee56272ffd89860bac26f6c32123439af26a4                                           0.2s
 => => extracting sha256:3cd534fe98c64d68a1f4f1c83abb8d5cba7ecfd7be88e592389929d12e6253da                                           0.2s
 => => extracting sha256:1223f016b4e4a2c21f7c49d4837fbfd47a9da6436b511690ca1e582fc2810d59                                           0.1s
 => => extracting sha256:62bec68d7c31c4c8a19d812d84da5f7748e54690c037979945b6c5b6c924b142                                           0.1s
 => => extracting sha256:46f977ee452f4399c208714afa034868d6056864f8a0cf3c643ab143dd802c80                                           0.1s
 => => extracting sha256:d0008c891db48b5f526d914bce9e8d889fe1a9d1f08291ae03fe97f871726f38                                           0.1s
 => => extracting sha256:390dc935348d8070e695fbaae2a4bb114fb9e69c59f628e7576036ee9d5244c9                                           0.1s
 => => extracting sha256:46519e7231d2eb5604df229beb44d59719a489eaa7aca52982535a010b07a9ed                                           0.4s
 => [2/2] COPY app/ /usr/share/nginx/html/                                                                                          0.2s
 => exporting to image                                                                                                              1.0s
 => => exporting layers                                                                                                             0.5s
 => => exporting manifest sha256:58a716ff33ae3ea6fe132b4646d0233517c1b80a4fa59ed1bec939c5091055d0                                   0.1s
 => => exporting config sha256:bd612d6084ad675b153c97c66043f193adfd17a69b784ab890ad2de4a5ac1efa                                     0.1s
 => => exporting attestation manifest sha256:50552661b37e990ce226730319fc1c0eedc96ec2360665cdf60affee109b1cee                       0.1s
 => => exporting manifest list sha256:58671610b2f67223f1ce2b0a2e8729b86e37554e9f48401606d6be004bc382e6                              0.1s
 => => naming to docker.io/library/mission1-web:1.0                                                                                 0.0s
 => => unpacking to docker.io/library/mission1-web:1.0                                                                              0.1s

$ docker images | grep -E 'IMAGE|mission1-web'
WARNING: This output is designed for human readability. For machine-readable output, please use --format.
mission1-web:1.0     58671610b2f6       93.9MB         26.1MB   
```

## 3) 포트 매핑 실행 — 같은 이미지로 두 컨테이너 (8080, 8081)

```bash
$ docker run -d -p 8080:80 --name mission1-web-8080 mission1-web:1.0
4c1bdaea14ee6175d076dcca24a120f2d1f7e6324102f5165982c428652752bc

$ docker run -d -p 8081:80 --name mission1-web-8081 mission1-web:1.0
a6d0adea9ded153b9d37a15a73194ea45db2904464097f6315892a10c5ce25dc

$ docker ps --filter name=mission1-web
CONTAINER ID   IMAGE              COMMAND                   CREATED          STATUS                             PORTS                                     NAMES
a6d0adea9ded   mission1-web:1.0   "/docker-entrypoint.…"   7 seconds ago    Up 7 seconds (health: starting)    0.0.0.0:8081->80/tcp, [::]:8081->80/tcp   mission1-web-8081
4c1bdaea14ee   mission1-web:1.0   "/docker-entrypoint.…"   14 seconds ago   Up 15 seconds (health: starting)   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   mission1-web-8080
(base) dooolll5969@c3r6s7 mission-1 % curl -s -o /dev/null -w 'HTTP %{http_code}\n' http://localhost:8080
HTTP 200
(base) dooolll5969@c3r6s7 mission-1 % curl -s http://localhost:8080 | grep -o '<title>.*</title>'
<title>Mission 1 — Dev Workstation</title>
(base) dooolll5969@c3r6s7 mission-1 % curl -s -o /dev/null -w 'HTTP %{http_code}\n' http://localhost:8081
HTTP 200
(base) dooolll5969@c3r6s7 mission-1 % docker logs mission1-web-8080
a6d0adea9ded   mission1-web:1.0   "/docker-entrypoint.…"   7 seconds ago    Up 7 seconds (health: starting)    0.0.0.0:8081->80/tcp, [::]:8081->80/tcp   mission1-web-8081
4c1bdaea14ee   mission1-web:1.0   "/docker-entrypoint.…"   14 seconds ago   Up 15 seconds (health: starting)   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   mission1-web-8080
```

→ **같은 이미지 하나로 포트만 바꿔 여러 컨테이너를 재현 실행**할 수 있음을 확인 (이미지=설계도, 컨테이너=실행 인스턴스).

## 4) 접속 검증 — curl (2개 포트)

```bash
$ curl -s -o /dev/null -w 'HTTP %{http_code}\n' http://localhost:8080
HTTP 200

$ curl -s http://localhost:8080 | grep -o '<title>.*</title>'
<title>Mission 1 — Dev Workstation</title>

$ curl -s -o /dev/null -w 'HTTP %{http_code}\n' http://localhost:8081
HTTP 200

$ curl -s http://localhost:8081 | grep -o '<title>.*</title>'
<title>Mission 1 — Dev Workstation</title>
```

## 5) 접속 화면

주소창(포트 포함)이 보이는 실제 브라우저 캡처:

| 포트 | 스크린샷 |
|------|----------|
| 8080 | <img width="450" alt="browser-8080" src="https://github.com/user-attachments/assets/04f7fa64-fe84-4f56-a928-b4d28ec85ef3"> |
| 8081 | <img width="450" alt="browser-8081" src="https://github.com/user-attachments/assets/a5825634-36ba-403f-a1b2-5066a7370c26"> |


## 6) 컨테이너 로그 및 헬스체크

```bash
$ docker logs mission1-web-8080 | tail -4
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2026/08/04 06:12:06 [notice] 1#1: using the "epoll" event method
2026/08/04 06:12:06 [notice] 1#1: nginx/1.31.3
2026/08/04 06:12:06 [notice] 1#1: built by gcc 15.2.0 (Alpine 15.2.0) 
2026/08/04 06:12:06 [notice] 1#1: OS: Linux 7.0.5-orbstack-00330-ge3df4e19b0a0-dirty
2026/08/04 06:12:06 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 20480:1048576
2026/08/04 06:12:06 [notice] 1#1: start worker processes
2026/08/04 06:12:06 [notice] 1#1: start worker process 30
2026/08/04 06:12:06 [notice] 1#1: start worker process 31
2026/08/04 06:12:06 [notice] 1#1: start worker process 32
2026/08/04 06:12:06 [notice] 1#1: start worker process 33
2026/08/04 06:12:06 [notice] 1#1: start worker process 34
2026/08/04 06:12:06 [notice] 1#1: start worker process 35
192.168.215.1 - - [04/Aug/2026:06:12:30 +0000] "GET / HTTP/1.1" 200 270 "-" "curl/8.7.1" "-"
::1 - - [04/Aug/2026:06:12:36 +0000] "GET / HTTP/1.1" 200 270 "-" "Wget" "-"
192.168.215.1 - - [04/Aug/2026:06:12:44 +0000] "GET / HTTP/1.1" 200 270 "-" "curl/8.7.1" "-"
192.168.215.1 - - [04/Aug/2026:06:13:05 +0000] "GET / HTTP/1.1" 200 270 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36" "-"
192.168.215.1 - - [04/Aug/2026:06:13:06 +0000] "GET /favicon.ico HTTP/1.1" 404 555 "http://localhost:8080/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36" "-"
2026/08/04 06:13:06 [error] 33#33: *5 open() "/usr/share/nginx/html/favicon.ico" failed (2: No such file or directory), client: 192.168.215.1, server: localhost, request: "GET /favicon.ico HTTP/1.1", host: "localhost:8080", referrer: "http://localhost:8080/"
::1 - - [04/Aug/2026:06:13:06 +0000] "GET / HTTP/1.1" 200 270 "-" "Wget" "-"
::1 - - [04/Aug/2026:06:13:36 +0000] "GET / HTTP/1.1" 200 270 "-" "Wget" "-"
::1 - - [04/Aug/2026:06:14:06 +0000] "GET / HTTP/1.1" 200 270 "-" "Wget" "-"
::1 - - [04/Aug/2026:06:14:36 +0000] "GET / HTTP/1.1" 200 270 "-" "Wget" "-"
::1 - - [04/Aug/2026:06:15:06 +0000] "GET / HTTP/1.1" 200 270 "-" "Wget" "-"
::1 - - [04/Aug/2026:06:15:36 +0000] "GET / HTTP/1.1" 200 270 "-" "Wget" "-"
::1 - - [04/Aug/2026:06:16:06 +0000] "GET / HTTP/1.1" 200 270 "-" "Wget" "-"
::1 - - [04/Aug/2026:06:16:36 +0000] "GET / HTTP/1.1" 200 270 "-" "Wget" "-"

$ docker inspect --format 'Health: {{.State.Health.Status}}' mission1-web-8080
Health: healthy   # 첫 interval(30s) 경과 후 healthy로 전환
```

## 7) 포트 매핑이 필요한 이유 (정리)

컨테이너는 호스트와 **격리된 자체 네트워크 네임스페이스**에서 동작하므로, 컨테이너 안에서 80번 포트로 리스닝해도 호스트에서는 보이지 않는다.
`-p <host>:<container>`가 호스트 포트로 들어온 트래픽을 컨테이너 포트로 전달(포워딩)해 주어야 외부(브라우저)에서 접속할 수 있다.
같은 이미지를 8080/8081 두 포트로 동시에 띄운 위 실험이 "호스트 포트만 다르면 같은 서비스를 여러 개 실행할 수 있다"는 점을 보여준다.
