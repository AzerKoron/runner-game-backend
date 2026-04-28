FROM php:8.3-fpm-alpine AS symfony_php

# Install system dependencies (включая автоконфигурацию для Xdebug)
RUN apk add --no-cache \
    git \
    unzip \
    libzip-dev \
    postgresql-dev \
    autoconf \
    g++ \
    make \
    linux-headers

# Install PHP extensions
RUN docker-php-ext-install pdo_pgsql zip

# Install Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Configure Xdebug
RUN echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install Composer via curl
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app
COPY . .

RUN composer install --no-interaction --optimize-autoloader --no-dev --no-scripts