FROM nginx:alpine

LABEL org.opencontainers.image.title="mission1-web"

ENV APP_ENV=dev

COPY app/ /usr/share/nginx/html/

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -qO- http://localhost/ > /dev/null || exit 1ㅐ
