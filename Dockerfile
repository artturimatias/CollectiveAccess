FROM ubuntu:18.04

ENV APACHE_RUN_USER     www-data
ENV APACHE_RUN_GROUP    www-data
ENV APACHE_LOG_DIR      /var/log/apache2
ENV APACHE_PID_FILE     /var/run/apache2.pid
ENV APACHE_RUN_DIR      /var/run/apache2
ENV APACHE_LOCK_DIR     /var/lock/apache2
ENV APACHE_LOG_DIR      /var/log/apache2



ENV TZ=Europe/Berlin\
 DEBIAN_FRONTEND=noninteractive
 
RUN apt-get update && apt-get install -y apache2 \
					php7.0 \
					libapache2-mod-php \
					curl \
					php-mysql \
					mysql-client \
					curl \
					php-curl \
					php-xml \
					zip \
					wget \
					ffmpeg \
					ghostscript \
					imagemagick \
					php-gd \
					libreoffice \
					php-zip \
					vim \
					php-mbstring \
					git

#GMAGICK
RUN apt-get install -y php-pear php-dev graphicsmagick libgraphicsmagick1-dev php-gmagick
# && pecl install gmagick-2.0.4RC1

# better PDF (wkhtmltopdf)
RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb  && apt install -y ./wkhtmltox_0.12.5-1.bionic_amd64.deb 

ENV CA_PROVIDENCE_VERSION=1.7.9rc1
ENV CA_PROVIDENCE_DIR=/var/www/providence
ENV CA_PAWTUCKET_VERSION=1.7
ENV CA_PAWTUCKET_DIR=/var/www

RUN mkdir /var/www/providence
#RUN wget --output-document providence-develop.tar.gz --no-check-certificate --content-disposition https://github.com/collectiveaccess/providence/tarball/develop | tar -C /var/www/providence --strip 1 -xzf -
#RUN curl -LJO https://github.com/collectiveaccess/providence/tarball/develop | tar -C /var/www/providence --strip 1 -xzf -

#RUN curl -SsL https://github.com/collectiveaccess/providence/archive/$CA_PROVIDENCE_VERSION.tar.gz | tar -C /var/www/ -xzf -
COPY providence /var/www/providence
#RUN mv /var/www/providence-$CA_PROVIDENCE_VERSION /var/www/providence
RUN cd $CA_PROVIDENCE_DIR && cp setup.php-dist setup.php

#RUN curl -SsL https://github.com/collectiveaccess/pawtucket2/archive/$CA_PAWTUCKET_VERSION.tar.gz | tar -C /var/www/ -xzf -
#RUN mv $CA_PAWTUCKET_DIR/pawtucket2-$CA_PAWTUCKET_VERSION/* /var/www
#RUN cd $CA_PAWTUCKET_DIR && cp setup.php-dist setup.php

RUN sed -i "s@DocumentRoot \/var\/www\/html@DocumentRoot \/var\/www@g" /etc/apache2/sites-available/000-default.conf
RUN rm -rf /var/www/html
run mkdir /$CA_PROVIDENCE_DIR/media/collectiveaccess
run mkdir /$CA_PROVIDENCE_DIR/media/collectiveaccess/tilepics
run mkdir /$CA_PROVIDENCE_DIR/app/locale/fi_FI
#RUN ln -s /$CA_PROVIDENCE_DIR/media /$CA_PAWTUCKET_DIR/media

#COPY php.ini /etc/php/7.0/cli/php.ini

COPY files/php.ini /etc/php/7.2/apache2/php.ini
COPY files/messages.po /$CA_PROVIDENCE_DIR/app/locale/fi_FI/
COPY files/messages.mo /$CA_PROVIDENCE_DIR/app/locale/fi_FI/
#COPY files/base.css /$CA_PROVIDENCE_DIR/themes/default/css/
COPY files/fi_FI.lang /$CA_PROVIDENCE_DIR/app/lib/Parsers/TimeExpressionParser/
COPY files/osc.xml /$CA_PROVIDENCE_DIR/install/profiles/xml/
COPY files/global.conf /$CA_PROVIDENCE_DIR/app/conf/
COPY files/browse.conf /$CA_PROVIDENCE_DIR/app/conf/
COPY files/app.conf.dev /$CA_PROVIDENCE_DIR/app/conf/app.conf
COPY files/search.conf /$CA_PROVIDENCE_DIR/app/conf/
COPY files/multipart_id_numbering.conf /$CA_PROVIDENCE_DIR/app/conf/
#COPY files/TileViewer.php /$CA_PROVIDENCE_DIR/app/lib/core/Media/MediaViewers/
COPY files/menu_logo_osc.png /$CA_PROVIDENCE_DIR/themes/default/graphics/logos/menu_logo.png
COPY files/setup.php /$CA_PROVIDENCE_DIR/setup.php
COPY files/vendor /$CA_PROVIDENCE_DIR/vendor
COPY files/entrypoint.sh /entrypoint.sh
RUN chown -R www-data:www-data /var/www

RUN chmod 777 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 80
CMD [ "/usr/sbin/apache2", "-DFOREGROUND" ]
