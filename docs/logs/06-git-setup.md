# 06. Git 설정 및 GitHub 연동 로그

## 1) Git 사용자 정보 및 기본 브랜치 설정

```bash
$ git --version
git version 2.50.1 (Apple Git-155)

$ git config --global user.name "dooolll00"          # (기존 설정 확인)
$ git config --global user.email "<masked>@naver.com"
$ git config --global init.defaultBranch main    # 기본 브랜치를 main으로 설정

$ git config --global --list
user.name=dooolll00
user.email=<masked>@naver.com
credential.helper=osxkeychain
init.defaultbranch=main
```

> 🔒 이메일 주소는 개인정보 보호를 위해 마스킹했다. 토큰/비밀번호는 설정에 존재하지 않는다.

## 2) 저장소 초기화

```bash
$ cd ~/Project/mission-1

$ git init
/Users/dooolll5969/Project/mission-1/.git/ 안의 빈 깃 저장소를 다시 초기화했습니다
```

## 3) 커밋 및 GitHub 원격 연결

```bash
$ git add .
$ git commit -m "feat: mission 1 dev workstation setup with logs and evidence"

# GitHub CLI로 저장소 생성 + 원격 연결 + 푸시 (SSH 프로토콜)
$ gh repo create mission-1 --public --source . --push
https://github.com/dooolll00/mission-1
To github.com:dooolll00/mission-1.git
 * [new branch]      HEAD -> main
branch 'main' set up to track 'origin/main'.

$ git remote -v
origin	git@github.com:dooolll00/mission-1.git (fetch)
origin	git@github.com:dooolll00/mission-1.git (push)
```

> 원격 인증은 HTTPS 토큰이 아닌 **SSH 키**로 이루어진다 (보너스 과제 5 충족 — `gh` 설정의 Git operations protocol: ssh). 개인키/토큰 값은 어떤 로그에도 포함하지 않았다.

## 4) VSCode ↔ GitHub 연동

- VSCode 좌측 하단 계정 아이콘 → **GitHub으로 로그인** → 브라우저 OAuth 승인
- 소스 제어(⌃⇧G) 패널에서 이 저장소의 변경사항/브랜치가 표시되는 것으로 연동 확인
- 연동 증거 스크린샷: [docs/images/vscode-github.png](../images/vscode-github.png)
  - 캡처 시 토큰/인증 코드/이메일이 화면에 노출되지 않도록 주의

## 5) Git vs GitHub 역할 차이 (정리)

| | Git | GitHub |
|---|-----|--------|
| 정체 | 로컬에서 동작하는 **분산 버전 관리 시스템** | Git 저장소를 호스팅하는 **원격 협업 플랫폼** |
| 역할 | 커밋/브랜치/이력 관리 — 네트워크 없이도 동작 | 원격 백업, PR 리뷰, 이슈, CI 등 협업 기능 |
| 관계 | GitHub 없이도 Git은 완전하게 동작한다 | GitHub는 Git을 기반으로 한 서비스 중 하나 (GitLab, Bitbucket 등 대체재 존재) |
