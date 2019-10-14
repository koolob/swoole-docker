FROM php:7.2-cli
MAINTAINER koolob
RUN apt-get update 
RUN pecl install redis \
	&& pecl install swoole \
	&& docker-php-ext-enable redis \
	&& docker-php-ext-enable swoole