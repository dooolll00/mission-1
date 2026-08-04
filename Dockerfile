# Mission 1 — 커스텀 웹 서버 이미지
# 방식 (A): 웹 서버 베이스 이미지(nginx:alpine) + 정적 콘텐츠/설정 교체
FROM nginx:alpine

# 커스텀 1: 이미지 메타데이터 (누가 봐도 어떤 이미지인지 알 수 있게)
LABEL org.opencontainers.image.title="mission1-web"
LABEL org.opencontainers.image.description="Mission 1 dev-workstation custom nginx image"

# 커스텀 2: 환경 변수 주입 (설정과 코드의 분리 연습)
ENV APP_ENV=dev

# 커스텀 3: 기본 정적 콘텐츠를 내 콘텐츠로 교체
COPY app/ /usr/share/nginx/html/

# 문서화 목적의 포트 선언 (실제 개방은 -p 옵션이 담당)
EXPOSE 80

# 커스텀 4: 헬스체크 — 서버가 응답하는지 컨테이너 스스로 점검
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -qO- http://localhost/ > /dev/null || exit 1
