# Mission 1 — 내 컴퓨터에 개발자용 '작업실' 꾸미기

터미널(CLI) · Docker · Git/GitHub로 **재현 가능한 개발 워크스테이션**을 구축하고,
모든 수행 과정을 명령어 + 출력 증거로 기록한 저장소입니다.

## 1) 프로젝트 개요

- 터미널로 작업 디렉토리와 권한을 관리하고,
- Docker로 커스텀 웹 서버 이미지를 빌드/실행하며 포트 매핑·마운트·볼륨을 검증하고,
- Git/GitHub로 전 과정을 버전 관리하는 것이 목표입니다.
- 단순 따라하기가 아니라 **실행 결과(로그/접속/데이터 유지)로 검증**하고, 이미지-컨테이너 분리 · 격리 실행 · 포트/스토리지 연결 원칙을 설명 가능한 형태로 정리했습니다.

## 2) 실행 환경

| 항목 | 값 |
|------|-----|
| OS | macOS 26.6 (Apple Silicon, arm64) |
| Shell / 터미널 | zsh |
| Docker | 29.6.2 (Docker Desktop for Mac, Compose v5.3.1) |
| Git | 2.50.1 (Apple Git-155) |
| 편집기 | VSCode |

> ⚠️ macOS 환경 주의: Docker는 Docker Desktop(내부 Linux VM) 위에서 동작합니다. Linux에서는 Docker Desktop 없이 데몬이 직접 실행되므로 트러블슈팅 #1이 재현되지 않을 수 있습니다. 그 외 모든 docker/git 명령은 OS와 무관하게 동일하게 재현됩니다.

## 3) 수행 항목 체크리스트

- [x] 터미널 기본 조작 (pwd/ls/cd/mkdir/cp/mv/rm/cat/touch) → [로그 01](docs/logs/01-terminal.md)
- [x] 권한 실습 — 파일 1 + 디렉토리 1, 변경 전/후 비교 → [로그 02](docs/logs/02-permissions.md)
- [x] Docker 설치/점검 (`--version`, `info`) → [로그 03](docs/logs/03-docker-basics.md)
- [x] hello-world 실행 → [로그 03](docs/logs/03-docker-basics.md)
- [x] ubuntu 컨테이너 진입 및 내부 명령, attach/exec 차이 관찰 → [로그 03](docs/logs/03-docker-basics.md)
- [x] Dockerfile 직접 작성 → 커스텀 이미지 빌드/실행 → [Dockerfile](Dockerfile), [로그 04](docs/logs/04-build-run.md)
- [x] 포트 매핑 접속 2회 (8080, 8081) → [로그 04](docs/logs/04-build-run.md)
- [x] 바인드 마운트 변경 반영 → [로그 05](docs/logs/05-mount-volume.md)
- [x] 볼륨 영속성 (컨테이너 삭제 전/후) → [로그 05](docs/logs/05-mount-volume.md)
- [x] Git 설정 + GitHub/VSCode 연동 → [로그 06](docs/logs/06-git-setup.md)
- [x] (보너스) Compose 멀티 컨테이너 + 네트워크 통신 + 환경 변수 → [로그 07](docs/logs/07-compose-bonus.md)

## 4) 저장소 구조

```
mission-1/
├── README.md              # 본 문서 (모든 증거의 허브)
├── GUIDE.md               # 처음부터 따라할 수 있는 실습 가이드
├── GUIDE-ORBSTACK.md      # 관리자 권한 없는 Mac(OrbStack) 차이점 요약 가이드
├── GUIDE-ORBSTACK-FULL.md # OrbStack 환경 완전판 가이드 (단독으로 전 과정 수행 가능)
├── PLAN.md                # 수행 계획서
├── Dockerfile             # 직접 작성한 커스텀 이미지 정의
├── docker-compose.yml     # 보너스: web + redis 멀티 컨테이너
├── app/                   # 웹 서버 정적 콘텐츠
│   └── index.html
└── docs/
    ├── logs/              # 수행 로그 (명령어 + 출력)
    └── images/            # 접속/연동 스크린샷
```

## 5) 빠른 재현 방법

```bash
git clone https://github.com/newids/mission-1.git
cd mission-1

# 커스텀 이미지 빌드 및 실행
docker build -t mission1-web:1.0 .
docker run -d -p 8080:80 --name mission1-web-8080 mission1-web:1.0
curl http://localhost:8080            # 또는 브라우저에서 접속

# 보너스: Compose로 실행
docker compose up -d
curl http://localhost:8090
docker compose down
```

## 6) 검증 방법 요약 (무엇을 어떤 명령으로 확인했는가)

| 검증 대상 | 명령 | 확인 내용 | 증거 |
|-----------|------|-----------|------|
| 데몬 동작 | `docker info` | Server 버전/컨텍스트 응답 | [로그 03](docs/logs/03-docker-basics.md) |
| 설치 정상 | `docker run hello-world` | "Hello from Docker!" 출력 | [로그 03](docs/logs/03-docker-basics.md) |
| 컨테이너 수명 | `docker ps -a` 비교 | 메인 프로세스 종료 = 컨테이너 종료 | [로그 03](docs/logs/03-docker-basics.md) §5 |
| 이미지 빌드 | `docker build` + `docker images` | mission1-web:1.0 생성 | [로그 04](docs/logs/04-build-run.md) |
| 포트 매핑 | `curl -w '%{http_code}'` ×2포트 | 8080/8081 모두 HTTP 200 | [로그 04](docs/logs/04-build-run.md) |
| 접속 화면 | 브라우저 | 페이지 렌더링 | [images/](docs/images/) |
| 마운트 반영 | 호스트 파일 수정 → `curl` | v1 → v2 즉시 반영 | [로그 05](docs/logs/05-mount-volume.md) |
| 볼륨 영속성 | `rm -f` 후 재연결 → `cat` | 데이터 유지 확인 | [로그 05](docs/logs/05-mount-volume.md) |
| Git 설정 | `git config --global --list` | user/defaultBranch 설정 | [로그 06](docs/logs/06-git-setup.md) |
| 컨테이너 간 통신 | `nc -zv redis 6379` | 서비스 이름으로 연결 성공 | [로그 07](docs/logs/07-compose-bonus.md) |

## 7) 학습 정리 (과제 목표 6항목)

<details>
<summary><b>절대 경로 vs 상대 경로</b></summary>

- 절대 경로는 루트(`/`)부터 시작해 현재 위치와 무관하게 항상 같은 곳을 가리킨다: `/Users/newid/codyssey/practice`
- 상대 경로는 현재 디렉토리 기준이다: `../..`(두 단계 위), `codyssey/practice`(아래로)
- 실습 증거: [로그 01 §4](docs/logs/01-terminal.md)
</details>

<details>
<summary><b>파일 권한 r/w/x와 755, 644 해석 규칙</b></summary>

- 권한은 소유자(u)/그룹(g)/기타(o) 세 자리, 각 자리는 r(4)+w(2)+x(1)의 합.
- `755` = `rwxr-xr-x`, `644` = `rw-r--r--`.
- 디렉토리의 `x`는 진입(cd), `w`는 내부 파일 생성/삭제 권한 — `chmod 500` 상태에서 `touch` 실패로 직접 확인.
- 실습 증거: [로그 02](docs/logs/02-permissions.md)
</details>

<details>
<summary><b>기존 Dockerfile 기반 커스텀 이미지</b></summary>

- `nginx:alpine` 베이스에 LABEL/ENV/COPY/HEALTHCHECK를 추가해 커스텀 이미지를 빌드했다.
- 이미지는 설계도, 컨테이너는 실행 인스턴스 — 같은 이미지로 8080/8081 두 컨테이너를 띄워 확인.
- 증거: [Dockerfile](Dockerfile), [로그 04](docs/logs/04-build-run.md)
</details>

<details>
<summary><b>포트 매핑이 필요한 이유</b></summary>

- 컨테이너는 격리된 네트워크 네임스페이스에서 동작하므로, `-p host:container`로 호스트 포트를 포워딩해야 외부에서 접속할 수 있다.
- 호스트 포트만 바꾸면 같은 서비스를 여러 개 동시 실행할 수 있다 (8080/8081 실험).
- 증거: [로그 04 §7](docs/logs/04-build-run.md)
</details>

<details>
<summary><b>Docker 볼륨 (영속 데이터)</b></summary>

- 컨테이너 쓰기 레이어는 컨테이너 삭제와 함께 사라지지만, 볼륨은 Docker 관리 영역에 독립적으로 존재한다.
- 컨테이너를 `rm -f`로 삭제한 뒤 새 컨테이너에 같은 볼륨을 연결해도 데이터(`persistent-hello`)가 유지됨을 확인.
- 증거: [로그 05 §B](docs/logs/05-mount-volume.md)
</details>

<details>
<summary><b>Git vs GitHub 역할 차이</b></summary>

- Git: 로컬에서 완결되는 분산 버전 관리 시스템 (커밋/브랜치/이력).
- GitHub: Git 저장소를 호스팅하는 원격 협업 플랫폼 (PR/이슈/CI).
- GitHub 없이도 Git은 동작하며, GitHub는 Git 기반 서비스 중 하나다.
- 정리: [로그 06 §5](docs/logs/06-git-setup.md)
</details>

## 8) 트러블슈팅

### #1. Docker 데몬 연결 실패

- **문제**: `docker info` 실행 시 `Cannot connect to the Docker daemon at unix:///Users/newid/.docker/run/docker.sock. Is the docker daemon running?`
- **원인 가설**: CLI는 설치되어 있으나 데몬(Docker Desktop)이 실행 중이 아님.
- **확인**: macOS에서 Docker 데몬은 Docker Desktop의 Linux VM 안에서 돌기 때문에, 앱이 꺼져 있으면 소켓 파일에 연결할 수 없다.
- **해결**: Docker Desktop 실행(`open -a Docker`) 후 재시도 → `docker info`가 Server 29.6.2 정상 응답. ([로그 03](docs/logs/03-docker-basics.md))

### #2. 셸 훅(rtk)에 의한 명령 재작성으로 `ls` 실패

- **문제**: `ls -la` 실행 시 `command not found: rtk` 오류. `ls`가 아닌 `rtk`가 없다는 메시지가 나옴.
- **원인 가설**: 토큰 절약용 CLI 프록시(rtk)를 호출하도록 셸 훅이 명령을 `rtk ls`로 재작성하는데, 정작 rtk 바이너리가 설치되어 있지 않음.
- **확인**: `command ls -la`(훅/알리아스 우회) 및 `/bin/ls -la`는 정상 동작 → `ls` 자체 문제가 아니라 재작성 계층의 문제임을 특정.
- **해결/대안**: 실습 명령은 스크립트 파일로 실행해 재작성을 우회하고, rtk는 재설치 전까지 훅 비활성화 대상으로 기록. **교훈**: "명령이 없다"는 오류에서 없는 것이 무엇인지(원 명령 vs 프록시)를 먼저 확인할 것.

### #3. 바인드 마운트 직후 응답 잘림 (truncated response)

- **문제**: 호스트에서 `index.html`을 수정한 직후 첫 `curl` 응답이 `<h1>v2 - updated on hos`로 잘려서 도착 (마지막 6바이트 누락).
- **원인 가설**: ① nginx `sendfile`이 캐시한 이전 파일 크기(23B)로 새 콘텐츠(30B)를 서빙, 또는 ② Docker Desktop(VirtioFS) 파일 공유의 메타데이터 동기화 지연.
- **확인**: 재요청 시 `Content-Length: 30` = `wc -c` 결과(30B)와 일치하고 본문도 완전함 → 수정 직후의 일시적 크기 불일치로 특정. ([로그 05](docs/logs/05-mount-volume.md))
- **해결/대안**: 짧은 대기 후 재요청으로 해소. 개발 환경에서 지속 발생 시 nginx 설정에 `sendfile off;`를 넣는 것이 알려진 해법(macOS/VM 바인드 마운트의 고전적 이슈).

## 9) 증거 이미지

| 증거 | 파일 | 상태 |
|------|------|------|
| 8080 접속 (주소창 포함) | [browser-8080-addressbar.png](../images/browser-8080-addressbar.png) | ✅ |
| 8081 접속 (주소창 포함) | [browser-8081-addressbar.png](../images/browser-8081-addressbar.png) | ✅ |
| 8080 접속 (페이지 캡처) | [browser-8080.png](docs/images/browser-8080.png) | ✅ 보조 증거 |
| 8081 접속 (페이지 캡처) | [browser-8081.png](docs/images/browser-8081.png) | ✅ 보조 증거 |
| VSCode GitHub 연동 | [vscode-github.png](docs/images/vscode-github.png) | ✅ 민감정보 노출 없음 확인 |

### 포트 매핑 접속 화면 (주소창 포함)

![8080 접속](docs/images/browser-8080-addressbar.png)
![8081 접속](docs/images/browser-8081-addressbar.png)

### VSCode ↔ GitHub 연동

![VSCode GitHub 연동](docs/images/vscode-github.png)

## 10) 보안 및 개인정보

- 문서/로그의 이메일은 `<masked>` 처리했고, 토큰·비밀번호·개인키는 어떤 로그에도 포함되지 않았다.
- `docker images` 출력에서 미션과 무관한 개인 프로젝트 이미지 목록은 필터링했다.
- 커밋 전 `git grep`으로 `ghp_`, `token`, `password` 등 민감 패턴 부재를 확인했다.
