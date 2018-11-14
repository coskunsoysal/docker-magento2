Docker Magento 2.2.6
==============================================
Docker Magento 2.2.6 based on Nginx 1.15 & PHP-FPM 7.2 setup for Docker, build on [Alpine Linux](http://www.alpinelinux.org/).

[![Docker Pulls](https://img.shields.io/docker/pulls/coskunsoysal/docker-magento2.svg)](https://hub.docker.com/r/coskunsoysal/docker-magento2/)

This image runs with below php extensions:
>>   php7-gd php7-mcrypt php7-mbstring php7-zip php7-intl 
>>   php7-intl php7-xsl php7-soap php7-simplexml php7-iconv 
>>   php7-xmlwriter php7-tokenizer php7-bcmath 


nginx and php services controlled by supervisor


Usage
-----
Start the Docker containers:

    docker run -p 80:80 coskunsoysal/docker-magento2

See the PHP info on http://localhost ( http://0.0.0.0:80 )

Enjoy
