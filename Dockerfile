
FROM nginx:alpine

LABEL org.opencontainers.image.title="codyssey-my-web"

COPY site/ /usr/share/nginx/html/

EXPOSE 80
