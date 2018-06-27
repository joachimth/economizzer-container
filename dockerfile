FROM php:7.0-apache

RUN apt-get update && apt-get install -y git && \
	apt-get install -y libcurl3-dev && \
	apt-get install -y libxml2-dev && \
	apt-get install -y zip unzip && \
	apt-get install -y zlib1g-dev && \
	apt-get install -y libpng-dev && \
	apt-get install -y libbz2-dev && \
	apt-get install -y libxslt-dev && \
	apt-get clean -y 
	
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin
RUN docker-php-ext-install bcmath mbstring curl xml zip gd intl xsl

RUN git -C /var/www/html/ clone https://github.com/gugoan/economizzer.git
WORKDIR /var/www/html/

RUN a2enmod rewrite
ADD . /var/www/html

COPY phpinfo.php /var/www/html/
COPY php.ini /usr/local/etc/php/

RUN cd /var/www/html/economizzer && \
	composer.phar global require "fxp/composer-asset-plugin:^1.3.1" && \
    composer.phar install	
	
RUN cd /var/www/html/economizzer && \
	chmod 777 assets/ && \
	chmod 777 runtime/ && \
	chmod 777 web/assets/ 	