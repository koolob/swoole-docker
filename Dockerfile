FROM php:5.6-cli
MAINTAINER koolob
ENV WORK_HOME /home/swoole
RUN mkdir -p ${WORK_HOME}
RUN apt-get update && apt-get install -y \
	wget \
	zip \
	libssl-dev
RUN cd ${WORK_HOME} \
	&& wget https://github.com/redis/hiredis/archive/v0.13.3.zip \
	&& unzip v0.13.3.zip \
	&& cd hiredis-0.13.3 \
	&& make -j \
	&& make install \
	&& ldconfig

RUN cd ${WORK_HOME} \
	&& wget https://github.com/jemalloc/jemalloc/releases/download/4.0.4/jemalloc-4.0.4.tar.bz2 \
	&& tar -xjf jemalloc-4.0.4.tar.bz2 \
	&& cd jemalloc-4.0.4 \
	&& ./configure \
	&& make -j install \
	&& ldconfig

RUN cd ${WORK_HOME} \
	&& wget https://pecl.php.net/get/swoole-1.8.4.tgz \
	&& tar zxvf swoole-1.8.4.tgz \
	&& cd swoole-1.8.4 \
	&& phpize \
	&& ./configure --enable-async-redis --enable-async-httpclient --enable-openssl --enable-jemalloc \
	&& make \
	&& make install

RUN pecl install redis \
	&& docker-php-ext-enable redis \
	&& docker-php-ext-enable swoole