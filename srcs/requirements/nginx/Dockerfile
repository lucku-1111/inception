FROM alpine:3.19

RUN apk update && \
	apk add --no-cache dumb-init nginx openssl && \
	mkdir -p /run/nginx /etc/nginx/ssl && \
	openssl genrsa 2048 > /etc/nginx/ssl/seoklee.key && \
	openssl req -new -key /etc/nginx/ssl/seoklee.key -out /etc/nginx/ssl/seoklee.csr -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=42Seoul/CN=seoklee.42.fr" && \
	openssl x509 -req -days 365 -in /etc/nginx/ssl/seoklee.csr -signkey /etc/nginx/ssl/seoklee.key -out /etc/nginx/ssl/seoklee.crt

COPY ./conf/default.conf /etc/nginx/http.d/default.conf
COPY ./tools/setup.sh /scripts/setup.sh

RUN chmod +x /scripts/setup.sh

CMD [ "/scripts/setup.sh" ]