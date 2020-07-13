FROM php:7.4-apache
 
ARG DEBIAN_FRONTEND=noninteractive

# Update
RUN apt-get -y update --fix-missing && \
    apt-get upgrade -y && \
    apt-get --no-install-recommends install -y apt-utils && \
    rm -rf /var/lib/apt/lists/*

# Install useful tools and install important libaries
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install nano wget \
    dialog \
    libsqlite3-dev \
    libsqlite3-0 && \
        apt-get -y --no-install-recommends install default-mysql-client \
    zlib1g-dev \
    libzip-dev \
    libicu-dev && \
        apt-get -y --no-install-recommends install --fix-missing apt-utils 
# Install imagick
RUN apt-get update && \
    apt-get -y --no-install-recommends install --fix-missing libmagickwand-dev && \
    rm -rf /var/lib/apt/lists/* && \
    pecl install imagick && \
    docker-php-ext-enable imagick

# Other PHP7 Extensions
RUN docker-php-ext-install gd && \
    docker-php-ext-install mysqli 
    
# # Enable apache modules
RUN a2enmod rewrite headers
COPY ./DocumentRoot /var/www/html
COPY ./devconfig/apache/vhosts /etc/apache2/sites-enabled
COPY ./devconfig/php/php.ini /usr/local/etc/php/php.ini
COPY ./devconfig/apache/apache2.conf /etc/apache2/apache2.conf
COPY ./logs/apache2 /var/log/apache2

# Cleanup & changing permissions
RUN rm -rf /usr/src/* 
