FROM alpine:3.19

RUN apk update && apk add --no-cache \
	mariadb-client \
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
	php81-opcache \
	php81-phar

COPY ./tools/setup.sh /scripts/setup.sh

RUN ln -s /usr/bin/php81 /usr/bin/php && \
	curl -o /usr/local/bin/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	ln -s /usr/local/bin/wp-cli.phar /usr/local/bin/wp && \
	chmod +x /usr/local/bin/wp && mkdir -p /var/www/html/wordpress && \
	wp core download --allow-root --path=/var/www/html/wordpress && \
	adduser -S seoklee && addgroup -S seoklee && \
	chmod +x /scripts/setup.sh

CMD [ "/scripts/setup.sh" ]