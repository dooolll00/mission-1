# 01. 터미널 기본 조작 로그

> 실행 환경: macOS 26.6 / zsh
> 실습 위치: `~/codyssey/practice`

## 1) 현재 위치 확인 · 디렉토리 생성 · 이동

```bash
$ pwd
/Users/newid/Project/mission-1

$ mkdir -p /Users/newid/codyssey/practice

$ cd /Users/newid/codyssey/practice

$ pwd
/Users/newid/codyssey/practice

$ ls -la
total 0
drwxr-xr-x@ 2 newid  staff  64 Jul 27 21:28 .
drwxr-xr-x@ 3 newid  staff  96 Jul 27 21:28 ..
```

## 2) 파일 생성 (빈 파일 / 내용 있는 파일) · 내용 확인

```bash
$ touch notes.txt

$ echo 'hello codyssey' > memo.txt

$ cat memo.txt
hello codyssey

$ ls -la
total 8
drwxr-xr-x@ 4 newid  staff  128 Jul 27 21:28 .
drwxr-xr-x@ 3 newid  staff   96 Jul 27 21:28 ..
-rw-r--r--@ 1 newid  staff   15 Jul 27 21:28 memo.txt
-rw-r--r--@ 1 newid  staff    0 Jul 27 21:28 notes.txt
```

- `touch`: 크기 0의 빈 파일 생성 (`notes.txt`, size 0 확인)
- `ls -la`: 숨김 파일(`.`, `..` 포함) 전체 목록 확인

## 3) 복사 · 이동/이름변경 · 삭제

```bash
$ mkdir backup

$ cp memo.txt backup/memo-copy.txt

$ ls -la backup
total 8
drwxr-xr-x@ 3 newid  staff   96 Jul 27 21:28 .
drwxr-xr-x@ 5 newid  staff  160 Jul 27 21:28 ..
-rw-r--r--@ 1 newid  staff   15 Jul 27 21:28 memo-copy.txt

$ mv memo.txt memo-renamed.txt        # 이름 변경

$ ls -la
total 8
drwxr-xr-x@ 5 newid  staff  160 Jul 27 21:28 .
drwxr-xr-x@ 3 newid  staff   96 Jul 27 21:28 ..
drwxr-xr-x@ 3 newid  staff   96 Jul 27 21:28 backup
-rw-r--r--@ 1 newid  staff   15 Jul 27 21:28 memo-renamed.txt
-rw-r--r--@ 1 newid  staff    0 Jul 27 21:28 notes.txt

$ mv memo-renamed.txt backup/         # 다른 디렉토리로 이동

$ ls -la backup
total 16
drwxr-xr-x@ 4 newid  staff  128 Jul 27 21:28 .
drwxr-xr-x@ 4 newid  staff  128 Jul 27 21:28 ..
-rw-r--r--@ 1 newid  staff   15 Jul 27 21:28 memo-copy.txt
-rw-r--r--@ 1 newid  staff   15 Jul 27 21:28 memo-renamed.txt

$ rm backup/memo-copy.txt             # 파일 삭제

$ ls -la backup
total 8
drwxr-xr-x@ 3 newid  staff   96 Jul 27 21:28 .
drwxr-xr-x@ 4 newid  staff  128 Jul 27 21:28 ..
-rw-r--r--@ 1 newid  staff   15 Jul 27 21:28 memo-renamed.txt
```

- `mv`는 대상이 같은 디렉토리면 **이름 변경**, 다른 디렉토리면 **이동**으로 동작한다.

## 4) 절대 경로 vs 상대 경로

```bash
$ cd /Users/newid/codyssey/practice && pwd    # 절대 경로: / 부터 전체 경로 지정
/Users/newid/codyssey/practice

$ cd ../.. && pwd                             # 상대 경로: 현재 위치 기준 두 단계 위로
/Users/newid

$ cd codyssey/practice && pwd                 # 상대 경로: 현재 위치 기준 아래로
/Users/newid/codyssey/practice
```

| 구분 | 예시 | 특징 |
|------|------|------|
| 절대 경로 | `/Users/newid/codyssey/practice` | 루트(`/`)부터 시작. 현재 위치와 무관하게 항상 같은 곳을 가리킴 |
| 상대 경로 | `../..`, `codyssey/practice` | 현재 디렉토리 기준. `.`=현재, `..`=상위 |
