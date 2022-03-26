FROM	alpine/git as gitsrc
WORKDIR /ftr
RUN	git clone --depth 1 https://bitbucket.org/zottelchen/full-text-rss-http2-simplepie-update.git .

FROM	php:7-cli-alpine

COPY    --from=gitsrc /ftr /var/www/html

RUN     mkdir -p /var/www/html/cache/rss && \
	    chmod -Rv 777 /var/www/html/cache && \
	    chmod -Rv 777 /var/www/html/site_config
	
ADD     https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
	    
RUN     chmod +x /usr/local/bin/install-php-extensions && \
	    install-php-extensions tidy curl zip

WORKDIR /var/www/html
EXPOSE  8080
CMD     php -q -S 0.0.0.0:8080
