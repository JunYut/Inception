FROM debian:bullseye

RUN apt update && \
    apt install -y nginx && \
    mkdir -p /run/nginx

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]
