FROM debian:bullseye
LABEL version="0.1"
MAINTAINER veto<veto@myridia.com>
RUN apt-get update && apt-get install -y \
  apache2 \
  apt-transport-https \ 
  lsb-release \
  ca-certificates \
  curl \
  wget \	      
  apt-utils \
  openssh-server \
  supervisor \
  default-mysql-client \
  libpcre3-dev \
  gcc \
  make \
  emacs-nox \ 
  vim \ 
  git \
  gnupg \
  sqlite3 \
  unzip \
  p7zip-full \
  postgresql-client \
  inetutils-ping  \
  net-tools \
  mariadb-client \
  sshpass 
  
RUN wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
RUN echo "deb https://packages.sury.org/php/ bullseye main" | tee /etc/apt/sources.list.d/php.list


RUN apt-get update && apt-get install -y \
  php5.6 \
  php5.6-json \
  php5.6-xml \
  php5.6-cgi  \
  php5.6-mysql  \
  php5.6-mbstring \
  php5.6-gd \
  php5.6-curl \
  php5.6-zip \
  php5.6-dev \
  php5.6-sqlite3 \ 
  php5.6-ldap \
  php5.6-sybase \ 
  php5.6-pgsql \
  php5.6-soap \
  php5.6-redis \  
  libapache2-mod-php5.6 \
  php-pear \
  php5.6-mcrypt


#RUN pear install mail \
#pear upgrade MAIL Net_SMTP 


RUN echo "<?php phpinfo() ?>" > /var/www/html/index.php ; \
mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor ; \
a2enmod rewrite  ;\
sed -i -e '/memory_limit =/ s/= .*/= 2056M/' /etc/php/5.6/apache2/php.ini ; \
sed -i -e '/post_max_size =/ s/= .*/= 800M/' /etc/php/5.6/apache2/php.ini ; \
sed -i -e '/max_file_uploads =/ s/= .*/= 200/' /etc/php/5.6/apache2/php.ini ; \
sed -i -e '/upload_max_filesize =/ s/= .*/= 800M/' /etc/php/5.6/apache2/php.ini ; \
sed -i -e '/display_errors =/ s/= .*/= ON/' /etc/php/5.6/apache2/php.ini ; \
sed -i -e '/short_open_tag =/ s/= .*/= ON/' /etc/php/5.6/apache2/php.ini ; \
sed -i -e '/short_open_tag =/ s/= .*/= ON/' /etc/php/5.6/cli/php.ini ; \
sed -i -e '/AllowOverride / s/ .*/ All/' /etc/apache2/apache2.conf ; \
sed -i -e '/max_execution_time =/ s/= .*/= 1200/' /etc/php/5.6/apache2/php.ini ; \
echo 'open_basedir = "/"' >> /etc/php/5.6/apache2/php.ini ; 


RUN  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin 
RUN ln  -s /usr/bin/composer.phar /usr/bin/composer 

RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 22 80
CMD ["/usr/bin/supervisord"]


