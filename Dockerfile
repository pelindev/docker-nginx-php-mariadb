FROM php:7.4-fpm

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    wget \
    nginx \
    supervisor && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php /etc/supervisor && touch /run/php/php7.4-fpm.sock && touch /run/php/php7.4-fpm.pid

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY cfg/supervisord.conf /etc/supervisor/
COPY cfg/nginx.conf /etc/nginx/nginx.conf

WORKDIR /app

CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf" ]
