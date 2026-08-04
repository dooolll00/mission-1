# 07. (보너스) Docker Compose 멀티 컨테이너 로그

> 구성: [docker-compose.yml](../../docker-compose.yml) — `web`(커스텀 nginx) + `redis`(보조 서비스)

## 1) 실행 (up) — 실행 명령이 "문서화된 설정"이 되는 순간

```bash
$ docker compose up -d
[+] up 3/3
 ✔ Network mission-1_default   Created                                                                                               0.1s
 ✔ Container mission-1-redis-1 Started                                                                                               0.7s
 ✔ Container mission-1-web-1   Started                                                                                               0.7s

$ docker compose ps
NAME                IMAGE            COMMAND                   SERVICE   CREATED         STATUS                            PORTS
mission-1-redis-1   redis:7-alpine   "docker-entrypoint.s…"   redis     8 seconds ago   Up 6 seconds                      6379/tcp
mission-1-web-1     mission-1-web    "/docker-entrypoint.…"   web       7 seconds ago   Up 6 seconds (health: starting)   0.0.0.0:8090->80/tcp, [::]:8090->80/tcp
```

- `docker run -d -p 8090:80 -e APP_ENV=... --name ...` 같은 긴 명령이 **YAML 파일로 문서화**되어, 누구나 `up` 한 번으로 동일한 구성을 재현할 수 있다.

## 2) 접속 및 환경 변수 주입 확인

```bash
$ curl -s -o /dev/null -w 'HTTP %{http_code}\n' http://localhost:8090
HTTP 200

$ docker compose exec web printenv APP_ENV
compose        # Dockerfile의 ENV APP_ENV=dev를 Compose environment가 덮어씀
```

→ **설정과 코드의 분리**: 이미지는 그대로 두고 Compose 설정만으로 실행 모드를 바꿀 수 있다.

## 3) 컨테이너 간 네트워크 통신 (서비스 디스커버리)

```bash
$ docker compose exec web nc -zv redis 6379
redis (192.168.97.2:6379) open      # web 컨테이너에서 "redis"라는 이름으로 접근 성공

$ docker compose exec redis redis-cli ping
PONG
```

- Compose가 만든 기본 네트워크 안에서는 **서비스 이름이 곧 DNS 호스트명**이다. IP를 몰라도 `redis:6379`로 접근된다.
- `redis`는 호스트에 포트를 열지 않았지만(`ports` 없음) 내부 네트워크에서는 통신 가능 — 외부 노출과 내부 통신의 분리.

## 4) 운영 명령 루틴 — logs / down

```bash
$ docker compose logs web
web-1  | /docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
web-1  | /docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
web-1  | /docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
web-1  | 10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
web-1  | 10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
web-1  | /docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
web-1  | /docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
web-1  | /docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
web-1  | /docker-entrypoint.sh: Configuration complete; ready for start up
web-1  | 2026/08/04 08:53:23 [notice] 1#1: using the "epoll" event method
web-1  | 2026/08/04 08:53:23 [notice] 1#1: nginx/1.31.3
web-1  | 2026/08/04 08:53:23 [notice] 1#1: built by gcc 15.2.0 (Alpine 15.2.0) 
web-1  | 2026/08/04 08:53:23 [notice] 1#1: OS: Linux 7.0.5-orbstack-00330-ge3df4e19b0a0-dirty
web-1  | 2026/08/04 08:53:23 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 20480:1048576
web-1  | 2026/08/04 08:53:23 [notice] 1#1: start worker processes
web-1  | 2026/08/04 08:53:23 [notice] 1#1: start worker process 30
web-1  | 2026/08/04 08:53:23 [notice] 1#1: start worker process 31
web-1  | 2026/08/04 08:53:23 [notice] 1#1: start worker process 32
web-1  | 2026/08/04 08:53:23 [notice] 1#1: start worker process 33
web-1  | 2026/08/04 08:53:23 [notice] 1#1: start worker process 34
web-1  | 2026/08/04 08:53:23 [notice] 1#1: start worker process 35
web-1  | 192.168.97.1 - - [04/Aug/2026:08:53:52 +0000] "GET / HTTP/1.1" 200 270 "-" "curl/8.7.1" "-"
web-1  | ::1 - - [04/Aug/2026:08:53:53 +0000] "GET / HTTP/1.1" 200 270 "-" "Wget" "-"

$ docker compose down
[+] down 3/3
 ✔ Container mission-1-web-1   Removed                                                                                               0.4s
 ✔ Container mission-1-redis-1 Removed                                                                                               0.3s
 ✔ Network mission-1_default   Removed    

$ docker compose ps
NAME      IMAGE     COMMAND   SERVICE   CREATED   STATUS    PORTS
(모두 정리됨)
```

- 상태 확인 루틴: `up -d` → `ps`(상태) → `logs`(문제 시) → `down`(네트워크까지 일괄 정리)
