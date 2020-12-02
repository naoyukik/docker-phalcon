FROM php:7.4-fpm-buster
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

RUN apt-get update && \
  apt-get -y install git libicu-dev libonig-dev libzip-dev unzip locales libcurl4-openssl-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  locale-gen en_US.UTF-8 && \
  localedef -f UTF-8 -i en_US en_US.UTF-8 && \
  mkdir /var/run/php-fpm && \
  docker-php-ext-install curl fileinfo gettext intl json pdo_mysql mbstring zip bcmath
RUN composer config -g process-timeout 3600

COPY ./php-fpm.d/zzz-www.conf /usr/local/etc/php-fpm.d/zzz-www.conf
COPY ./php.ini /usr/local/etc/php/php.ini

# install phalcon
RUN pecl install phalcon xdebug
RUN echo "extension=phalcon.so" > /usr/local/etc/php/conf.d/phalcon.ini && \
  echo "extension=psr.so" > /usr/local/etc/php/conf.d/psr.ini
RUN echo "zend_extension=xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini && \
  echo "xdebug.client_host = host.docker.internal" >> /usr/local/etc/php/conf.d/xdebug.ini && \
  echo "xdebug.client_port = 9003" >> /usr/local/etc/php/conf.d/xdebug.ini && \
  echo "xdebug.idekey = PHPSTORM" >> /usr/local/etc/php/conf.d/xdebug.ini && \
  echo "xdebug.mode = debug" >> /usr/local/etc/php/conf.d/xdebug.ini && \
  echo "xdebug.start_with_request = trigger" >> /usr/local/etc/php/conf.d/xdebug.ini && \
  echo "xdebug.trigger_value = \"\"" >> /usr/local/etc/php/conf.d/xdebug.ini && \
  echo "xdebug.output_dir = \"/tmp\"" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN composer global require phalcon/devtools

COPY ./entrypoint.sh /entrypoint.sh
COPY ./entrypoint.d /entrypoint.d
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]

WORKDIR /work/backend
