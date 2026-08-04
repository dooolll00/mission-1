# 01. 터미널 기본 조작 로그

> 실행 환경: macOS 15.7.7/ zsh 5.9 (x86_64-apple-darwin24.0)
> 실습 위치: `~/codyssey/practice`

## 1) 현재 위치 확인 · 디렉토리 생성 · 이동

```bash
$ sw_vers
ProductName:		macOS
ProductVersion:		15.7.7
BuildVersion:		24G720

$ zsh --version
zsh 5.9 (x86_64-apple-darwin24.0)

$ pwd
/Users/dooolll5969/Project/mission-1

$ mkdir -p /Users/dooolll5969/codyssey/practice

$ cd /Users/dooolll5969/codyssey/practice

$ pwd
/Users/dooolll5969/codyssey/practice

$ ls -la
total 0
drwxr-xr-x  2 dooolll5969  dooolll5969   64  8  4 19:49 .
drwxr-xr-x  4 dooolll5969  dooolll5969  128  8  4 19:49 ..

## 2) 파일 생성 (빈 파일 / 내용 있는 파일) · 내용 확인

```bash
$ touch notes.txt

$ echo 'hello codyssey' > memo.txt

$ cat memo.txt
hello codyssey

$ ls -la
total 8
drwxr-xr-x  4 dooolll5969  dooolll5969  128  8  4 19:49 .
drwxr-xr-x  4 dooolll5969  dooolll5969  128  8  4 19:49 ..
-rw-r--r--  1 dooolll5969  dooolll5969   15  8  4 19:49 memo.txt
-rw-r--r--  1 dooolll5969  dooolll5969    0  8  4 19:49 notes.txt
```

- `touch`: 크기 0의 빈 파일 생성 (`notes.txt`, size 0 확인)
- `ls -la`: 숨김 파일(`.`, `..` 포함) 전체 목록 확인

## 3) 복사 · 이동/이름변경 · 삭제

```bash
$ mkdir backup
mkdir: backup: File exists

$ cp memo.txt backup/memo-copy.txt

$ ls -la backup
total 8
drwxr-xr-x  3 dooolll5969  dooolll5969   96  8  4 19:50 .
drwxr-xr-x  5 dooolll5969  dooolll5969  160  8  4 19:50 ..
-rw-r--r--  1 dooolll5969  dooolll5969   15  8  4 19:50 memo-copy.txt

$ mv memo.txt memo-renamed.txt        # 이름 변경

$ ls -la
total 8
drwxr-xr-x  5 dooolll5969  dooolll5969  160  8  4 19:50 .
drwxr-xr-x  4 dooolll5969  dooolll5969  128  8  4 19:49 ..
drwxr-xr-x  3 dooolll5969  dooolll5969   96  8  4 19:50 backup
-rw-r--r--  1 dooolll5969  dooolll5969   15  8  4 19:49 memo-renamed.txt
-rw-r--r--  1 dooolll5969  dooolll5969    0  8  4 19:49 notes.txt

$ mv memo-renamed.txt backup/         # 다른 디렉토리로 이동

$ ls -la backup
total 16
drwxr-xr-x  4 dooolll5969  dooolll5969  128  8  4 19:50 .
drwxr-xr-x  4 dooolll5969  dooolll5969  128  8  4 19:50 ..
-rw-r--r--  1 dooolll5969  dooolll5969   15  8  4 19:50 memo-copy.txt
-rw-r--r--  1 dooolll5969  dooolll5969   15  8  4 19:49 memo-renamed.txt

$ rm backup/memo-copy.txt             # 파일 삭제

$ ls -la backup
total 8
drwxr-xr-x  3 dooolll5969  dooolll5969   96  8  4 19:50 .
drwxr-xr-x  4 dooolll5969  dooolll5969  128  8  4 19:50 ..
-rw-r--r--  1 dooolll5969  dooolll5969   15  8  4 19:49 memo-renamed.txt
```

- `mv`는 대상이 같은 디렉토리면 **이름 변경**, 다른 디렉토리면 **이동**으로 동작한다.

## 4) 절대 경로 vs 상대 경로

```bash
$ cd /Users/newid/codyssey/practice && pwd    # 절대 경로: / 부터 전체 경로 지정
/Users/dooolll5969/codyssey/practice

$ cd ../.. && pwd                             # 상대 경로: 현재 위치 기준 두 단계 위로
/Users/dooolll5969

$ cd codyssey/practice && pwd                 # 상대 경로: 현재 위치 기준 아래로
/Users/dooolll5969/codyssey/practice
```

| 구분 | 예시 | 특징 |
|------|------|------|
| 절대 경로 | `/Users/dooolll5969/codyssey/practice` | 루트(`/`)부터 시작. 현재 위치와 무관하게 항상 같은 곳을 가리킴 |
| 상대 경로 | `../..`, `codyssey/practice` | 현재 디렉토리 기준. `.`=현재, `..`=상위 |
