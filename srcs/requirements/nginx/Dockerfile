FROM debian:bullseye

RUN apt update && \
    apt install -y nginx && \
    mkdir -p /run/nginx

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]
