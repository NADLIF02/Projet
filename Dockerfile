FROM ubuntu:20.04

# Setup the environment
RUN apt-get -y update && \
    apt-get -y install software-properties-common wget && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get -y update

# Install PHP 7.2 and required extensions
RUN apt-get install -y \
        php7.2 \
        libapache2-mod-php7.2 \
        php7.2-common \
        php7.2-mbstring \
        php7.2-xmlrpc \
        php7.2-soap \
        php7.2-gd \
        php7.2-xml \
        php7.2-intl \
        php7.2-mysql \
        php7.2-cli \
        php7.2-ldap \
        php7.2-zip \
        php7.2-curl

# Download PHPUnit
RUN wget -O phpunit https://phar.phpunit.de/phpunit-8.phar && \
    chmod +x phpunit && \
    mv phpunit /usr/local/bin/phpunit

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

# Copy configurations and application files
RUN wget http://www.sentrifugo.com/home/downloadfile?file_name=Sentrifugo.zip -O Sentrifugo.zip
RUN unzip Sentrifugo.zip

COPY sentrifugo.conf /etc/apache2/sites-available/sentrifugo.conf
COPY --chown=www-data:www-data sentrifugo /var/www/html/

# Configure Apache and restart
RUN a2ensite sentrifugo && \
    a2enmod rewrite && \
    service apache2 restart && \
    rm /var/www/html/index.html
