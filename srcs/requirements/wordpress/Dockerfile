FROM alpine:3.19

# 필수 시스템 패키지 설치
RUN apk update && apk add --no-cache \
    bash \
    curl \
    libxml2-dev \
    oniguruma-dev \
    libzip-dev \
	php81 \
    php81-fpm \
    php81-mysqli \
    php81-curl \
    php81-dom \
    php81-exif \
    php81-mbstring \
    php81-openssl \
    php81-xml \
    php81-zip \
    php81-opcache

COPY ./tools/setup.sh /scripts/setup.sh

RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp && \
	adduser -S nginx && addgroup -S nginx && \
	chmod +x /scripts/setup.sh

CMD [ "/scripts/setup.sh" ]