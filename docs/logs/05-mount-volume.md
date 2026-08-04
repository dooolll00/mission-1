# 05. 바인드 마운트 반영 & 볼륨 영속성 검증 로그

## A. 바인드 마운트 — 호스트 변경 즉시 반영

호스트 디렉토리(`bindtest/`)를 nginx 문서 루트에 바인드 마운트하고, 호스트에서 파일을 수정하면 **재빌드/재시작 없이** 반영되는지 검증한다.

```bash
$ mkdir -p bindtest && echo '<h1>v1 - original</h1>' > bindtest/index.html

$ docker run -d -p 8082:80 -v $(pwd)/bindtest:/usr/share/nginx/html --name mission1-web-bind mission1-web:1.0
5d1d2b26af305393e157df5506f353d8094622eb4304edd4109f69f149d4f74a
```

### 변경 전

```bash
$ curl -s http://localhost:8082
<h1>v1 - original</h1>
```

### 호스트에서 파일 수정 → 변경 후

```bash
$ echo '<h1>v2 - updated on host</h1>' > bindtest/index.html

$ curl -s http://localhost:8082
<h1>v2 - updated on host</h1>
```

→ 이미지를 다시 빌드하지 않아도 **호스트 파일 수정이 컨테이너에 즉시 반영**됨을 확인했다.

> ⚠️ 수정 직후 첫 요청에서 응답이 `<h1>v2 - updated on hos`처럼 잘리는 현상이 1회 발생했다.
> 원인 분석과 해결 과정은 [README 트러블슈팅 #3](../../README.md#8-트러블슈팅)에 기록했다.

## B. Docker 볼륨 — 컨테이너 삭제 후 데이터 유지

### 1) 볼륨 생성 및 연결

```bash
$ docker volume create mission1-data
mission1-data

$ docker run -d --name vol-test -v mission1-data:/data ubuntu:24.04 sleep infinity
78c329bcd1c8d7b15dc70e8fdb3b2296f23b81d7b4ed9e5bb248c8d1b377eece

$ docker exec vol-test sh -c 'echo persistent-hello > /data/hello.txt && cat /data/hello.txt'
persistent-hello
```

### 2) 컨테이너 삭제 (데이터를 쓴 컨테이너가 완전히 사라짐)

```bash
$ docker rm -f vol-test
vol-test

$ docker ps -a --filter name=vol-test
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
(없음 — 컨테이너 완전 삭제 확인)
```

### 3) 새 컨테이너에 같은 볼륨 연결 → 데이터 유지 확인

```bash
$ docker run -d --name mission1-vol-test2 -v mission1-data:/data ubuntu:24.04 sleep infinity
126b2a1deab0206773dac7af3fac313d5ac60c8c42ef9d7e18aab16538fd9042

$ docker exec mission1-vol-test2 cat /data/hello.txt
persistent-hello        # ← 삭제 전 컨테이너에서 쓴 데이터가 그대로 유지됨

$ docker rm -f mission1-vol-test2
vol-test2
```

## C. 정리 — 바인드 마운트 vs 볼륨

| 구분 | 바인드 마운트 | Docker 볼륨 |
|------|--------------|-------------|
| 저장 위치 | 호스트의 특정 경로 (내가 지정) | Docker가 관리하는 영역 |
| 주 용도 | 개발 중 소스 실시간 반영 | DB 데이터 등 영속 데이터 보관 |
| 수명 | 호스트 파일과 동일 | 컨테이너와 독립 — **컨테이너를 삭제해도 유지** |
| 이식성 | 호스트 경로에 종속 | 경로 무관, `docker volume` 명령으로 관리 |

컨테이너의 쓰기 레이어는 컨테이너 삭제와 함께 사라지지만, 볼륨은 컨테이너 밖(도커 관리 영역)에 존재하므로 위 실험처럼 컨테이너를 삭제·재생성해도 데이터가 유지된다.
