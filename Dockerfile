FROM php:8.3-fpm-alpine AS symfony_php

# Install system dependencies
RUN apk add --no-cache \
    git \
    unzip \
    libzip-dev \
    postgresql-dev

# Install PHP extensions
RUN docker-php-ext-install pdo_pgsql zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

RUN composer install --no-interaction --optimize-autoloader --no-dev --no-scripts