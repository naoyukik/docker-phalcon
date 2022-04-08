FROM php:7.4-fpm-buster as base_php
SHELL ["/bin/bash", "-oeux", "pipefail", "-c"]

# timezone environment
ENV TZ=UTC \
  # locale
  LANG=en_US.UTF-8 \
  LANGUAGE=en_US:en \
  LC_ALL=en_US.UTF-8 \
  # composer environment
  COMPOSER_ALLOW_SUPERUSER=1 \
  COMPOSER_HOME=/composer \
  # Phalcon environment
  DB_CONNECTION=mysql \
  DB_HOST=db \
  DB_PORT=3306 \
  DB_DATABASE=phalcon_local \
  DB_USERNAME=phper \
  DB_PASSWORD=secret \
  LOG_CHANNEL=stderr

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN apt-get update \
  && apt-get -y install libicu-dev libonig-dev libzip-dev unzip locales libcurl4-openssl-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && locale-gen en_US.UTF-8 \
  && localedef -f UTF-8 -i en_US en_US.UTF-8 \
  && docker-php-ext-install curl fileinfo gettext intl json pdo_mysql mbstring zip bcmath \
  && composer config -g process-timeout 3600 \
  && mkdir /var/run/php-fpm \
  && RUN mkdir /entrypoint.d

COPY docker/php/php-fpm.d/zzz-www.conf /usr/local/etc/php-fpm.d/zzz-www.conf
COPY docker/php/php.ini /usr/local/etc/php/php.ini
COPY docker/php/entrypoint.sh /entrypoint.sh

CMD ["php-fpm"]
ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /work/backend

FROM base_php as phalcon
# install phalcon
RUN pecl install phalcon \
  && echo "extension=phalcon.so" > /usr/local/etc/php/conf.d/phalcon.ini \
  && echo "extension=psr.so" > /usr/local/etc/php/conf.d/psr.ini \
  && RUN composer global require phalcon/devtools

FROM phalcon as xdebug
# install xdebug
RUN pecl install xdebug
COPY docker/php/conf.d/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY docker/php/entrypoint.d/01-xdebug-setup.sh /entrypoint.d/01-xdebug-setup.sh
