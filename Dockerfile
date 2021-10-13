FROM	alpine/git as gitsrc
WORKDIR /ftr
RUN	git clone https://bitbucket.org/fivefilters/full-text-rss.git .

FROM	php:8-apache

COPY --from=gitsrc /ftr /var/www/html


RUN   apt-get update && \
      DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      libtidy-dev libzip-dev zip unzip libcurl4-openssl-dev  \
      && rm -rf /var/lib/apt/lists/* && apt-get autoremove -y && apt-get clean \
	  && docker-php-ext-install tidy zip curl \
	  && mkdir -p /var/www/html/cache/rss \
	  && chmod -Rv 777 /var/www/html/cache \
	  && chmod -Rv 777 /var/www/html/site_config
