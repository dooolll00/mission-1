# 02. 파일/디렉토리 권한 실습 로그

> 실습 위치: `~/codyssey/practice`
> 요구사항: 파일 1개 + 디렉토리 1개에 대한 권한 변경 전/후 비교

## 1) 파일 권한 실습 — `secret.txt`

```bash
$ echo 'important data' > secret.txt

$ ls -l secret.txt                    # 변경 전: 644 (rw-r--r--)
-rw-r--r--  1 dooolll5969  dooolll5969  15  8  4 14:57 secret.txt

$ chmod 600 secret.txt                # 소유자만 읽기/쓰기
$ ls -l secret.txt
-rw-------  1 dooolll5969  dooolll5969  15  8  4 14:57 secret.txt

$ chmod 000 secret.txt                # 모든 권한 제거
$ ls -l secret.txt
---------- 1 dooolll5969 dooolll5969 15  8 4 14:57 secret.txt

$ cat secret.txt                      # 소유자 본인도 읽기 실패
cat: secret.txt: Permission denied

$ chmod 644 secret.txt                # 복구
$ ls -l secret.txt
-rw-r--r--  1 dooolll5969  dooolll5969  15  8  4 14:57 secret.txt

$ cat secret.txt                      # 읽기 성공
important data
```

### 변경 전/후 비교 (파일)

| 단계 | 8진수 | 표기 | 실제 동작 |
|------|-------|------|-----------|
| 변경 전 | 644 | `rw-r--r--` | 누구나 읽기 가능, 소유자만 쓰기 |
| 1차 변경 | 600 | `rw-------` | 소유자만 읽기/쓰기 |
| 2차 변경 | 000 | `----------` | `cat` → **Permission denied** |
| 복구 | 644 | `rw-r--r--` | `cat` 정상 동작 |

## 2) 디렉토리 권한 실습 — `shared-dir`

```bash
$ mkdir -p shared-dir

$ ls -ld shared-dir                   # 변경 전: 755 (rwxr-xr-x)
drwxr-xr-x  2 dooolll5969  dooolll5969  64  8  4 14:58 shared-dir

$ chmod 700 shared-dir                # 소유자만 접근
$ ls -ld shared-dir
drwx------  2 dooolll5969  dooolll5969  64  8  4 14:58 shared-dir

$ chmod 500 shared-dir                # 읽기+진입만 가능, 쓰기 불가
$ ls -ld shared-dir
dr-x------  2 dooolll5969  dooolll5969  64  8  4 14:58 shared-dir

$ touch shared-dir/new.txt            # 디렉토리에 파일 생성 = 쓰기 → 실패
touch: shared-dir/new.txt: Permission denied

$ chmod 755 shared-dir                # 복구
$ ls -ld shared-dir
drwxr-xr-x  2 dooolll5969  dooolll5969  64  8  4 14:58 shared-dir

$ touch shared-dir/new.txt            # 쓰기 성공
$ ls -l shared-dir
total 0
-rw-r--r--  1 dooolll5969  dooolll5969  0  8  4 14:58 new.txt
```

### 변경 전/후 비교 (디렉토리)

| 단계 | 8진수 | 표기 | 실제 동작 |
|------|-------|------|-----------|
| 변경 전 | 755 | `rwxr-xr-x` | 누구나 목록/진입 가능, 소유자만 쓰기 |
| 1차 변경 | 700 | `rwx------` | 소유자만 접근 |
| 2차 변경 | 500 | `r-x------` | 내부 파일 생성 → **Permission denied** |
| 복구 | 755 | `rwxr-xr-x` | `touch` 정상 동작 |

## 3) 권한 표기 해석 규칙 정리

- 권한은 **소유자(u) / 그룹(g) / 기타(o)** 세 자리로 나뉘며, 각 자리는 `r(4) + w(2) + x(1)`의 합이다.
  - `755` = `rwx`(4+2+1) / `r-x`(4+1) / `r-x`(4+1) → 실행 파일·디렉토리의 일반적 권한
  - `644` = `rw-`(4+2) / `r--`(4) / `r--`(4) → 일반 문서 파일의 기본 권한
- 파일의 `x`는 "실행", **디렉토리의 `x`는 "진입(cd) 가능"**, 디렉토리의 `w`는 "내부에 파일 생성/삭제 가능"을 의미한다 — 위 실습에서 `500`(w 제거) 상태의 `touch` 실패로 직접 확인했다.
