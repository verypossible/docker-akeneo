FROM spartan/php:latest
MAINTAINER Daniel Paul Searles <daniel.paul.searles@gmail.com>

VOLUME /var/www/html
VOLUME /var/run

ENTRYPOINT ["/usr/local/bin/akeneo-entrypoint"]

WORKDIR /var/www/html

RUN mkdir -p /var/www/html && \
    mkdir -p /usr/local/lib/php/akeneo

COPY akeneo-entrypoint /usr/local/bin/akeneo-entrypoint

COPY php-fpm/www.conf /etc/php5/fpm/pool.d/www.conf

COPY composer.* /usr/local/lib/php/akeneo/

RUN cd /usr/local/lib/php/akeneo && \
    composer install --prefer-source --no-interaction && \
    find vendor -type d -name .git -print0 | xargs -0 rm -rf

ONBUILD CMD ["php5-fpm", "-F", "-O"]
ONBUILD COPY . /var/www/html
ONBUILD RUN cd /var/www/html && \
            rm -rf vendor && \
            ln -s /usr/local/lib/php/akeneo/vendor vendor && \
            composer install --prefer-source --no-interaction && \
            find vendor -type d -name .git -print0 | xargs -0 rm -rf
