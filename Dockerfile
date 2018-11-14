FROM coskunsoysal/alpine3.7-nginx-php7

LABEL maintainer="coskunsoysal@gmail.com"
LABEL description="Magento 2.2.6"

# set environments
ENV MAGENTO_VERSION 2.2.6
ENV INSTALL_DIR /var/www/html
ENV COMPOSER_HOME /var/www/.composer/

# install composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer
COPY ./auth.json $COMPOSER_HOME

# install php7 extensions
RUN apk add php7-pdo_mysql \
    && apk add php7-gd \
    && apk add php7-mcrypt \
    && apk add php7-mbstring \
    && apk add php7-zip \
    && apk add php7-intl \
    && apk add php7-xsl \
    && apk add php7-soap \
    && apk add php7-simplexml \
    && apk add php7-iconv \
    && apk add php7-xmlwriter \
    && apk add php7-tokenizer \
    && apk add php7-bcmath 

# add www-data to users
RUN set -x ; \
  addgroup -g 82 -S www-data ; \
  adduser -u 82 -D -S -G www-data www-data && exit 0 ; exit 1

# copy magento files
RUN rm -rf $INSTALL_DIR/*
RUN chown -R www-data:www-data /var/www

USER www-data
RUN composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition $INSTALL_DIR $MAGENTO_VERSION
USER root

# make permissions
RUN cd $INSTALL_DIR \
    && find . -type d -exec chmod 770 {} \; \
    && find . -type f -exec chmod 660 {} \; \
    && chmod u+x bin/magento

# copy install file
COPY ./install-magento /usr/local/bin/install-magento
RUN chmod +x /usr/local/bin/install-magento

# copy sample data file
COPY ./install-sampledata /usr/local/bin/install-sampledata
RUN chmod +x /usr/local/bin/install-sampledata

RUN echo "memory_limit=2048M" > /etc/php7/conf.d/memory-limit.ini

WORKDIR $INSTALL_DIR

# Add cron job
ADD crontab /etc/cron.d/magento2-cron
RUN chmod 0644 /etc/cron.d/magento2-cron \
    && crontab -u www-data /etc/cron.d/magento2-cron