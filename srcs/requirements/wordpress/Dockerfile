FROM alpine:3.18.6

RUN apk update && apk upgrade && apk add curl wget php82 php82-fpm php82-phar php82-json php82-mysqli php82-curl php82-iconv php81-pecl-mailparse mariadb-client && mv /usr/bin/php82 /usr/bin/php

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64\
&& chmod +x /usr/local/bin/dumb-init\
&& mkdir -p /var/www/html\
&& chmod 755 /var/www/html\
&& curl -s -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar --output /usr/bin/wp\
&& chmod +x /usr/bin/wp \
&& cp /usr/bin/wp /wp-cli.phar\
&& wp core download --allow-root --path=/var/www/html

RUN rm -f /etc/php82/php-fpm.d/www.conf
COPY config/www.conf /etc/php82/php-fpm.d/.
COPY tools/entry.sh /tmp
RUN chmod +x /tmp/entry.sh\
&& adduser -D -H -u 82 -s /sbin/nologin www-data -G www-data

# CMD ["sh"]
STOPSIGNAL SIGQUIT

ENTRYPOINT	[ "/usr/local/bin/dumb-init", "--" ]
CMD			[ "sh", "-c", "/tmp/entry.sh" ]