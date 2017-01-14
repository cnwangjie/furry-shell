#!/bin/bash
clear
echo "Next will start install process
Please select the mode : 1. Default Mode 2. Custom Mode"
read install_mode
if [ $install_mode = 2 ];then
    clear
    echo 'release version : 1. Debian 2. Centos'
    read release
    echo 'server locate : 1. CN 2. other'
    read locate
else
    if cat /etc/issue | grep -q -E -i "debian";then
        release=1
    elif cat /etc/issue | grep -q -E -i "centos";then
        release=2
    else
        exit 1
    fi

    ping -c 2 -i 0.2 -W 2 google.com &> /dev/null
    if [ $? = 0 ];then
        locate=2
    else
        locate=1
    fi
fi

# upgrade packages and install dependence packages
if [ $release = 1 ];then
apt-get update && apt-get upgrade
apt-get -y remove apt-get -y remove apache2 apache2-doc apache2-utils apache2.2-common apache2.2-bin apache2-mpm-prefork apache2-doc apache2-mpm-worker
apt-get -y install libxml2-dev build-essential openssl make curl libcurl4-gnutls-dev libjpeg-dev libpng-dev libmcrypt-dev libreadline6 libreadline6-dev perl libpcre3 libpcre3-dev m4 autoconf bison libbz2-dev libgmp-dev libicu-dev libsasl2-dev libsasl2-modules-ldap libldap-2.4-2 libldap2-dev libldb-dev libpam0g-dev libcurl4-gnutls-dev snmp libsnmp-dev autoconf2.13 libxml2-dev openssl pkg-config libxslt1-dev zlib1g-dev libpcre3-dev libtool libjpeg-dev libpng12-dev libfreetype6-dev libmhash-dev libmcrypt-dev libssl-dev patch
else
yum update && yum upgrade
yum -y remove httpd
yum -y install zlib-devel openssl openssl-devel lynx m4 autoconf bison bzip2-devel pam-devel gmp-devel libicu-devel openldap openldap-devel patch libxml2-devel openssl openssl-devel zlib-devel curl-devel pcre-devel libtool-libs libtool-ltdl-devel libjpeg-devel libpng-devel freetype-devel libxslt libxslt-devel net-snmp net-snmp-devel net-snmp-utils net-snmp-perl
fi

if [ $locate = 1 ];then
    apache_mirror=http://mirrors.tuna.tsinghua.edu.cn/apache/
    php_mirror=http://cn2.php.net/
else
    apache_mirror=http://apache.fayea.com/
    php_mirror=http://php.net/
fi

# download source code
wget $(apache_mirror)/httpd/httpd-2.4.25.tar.gz
wget $(apache_mirror)/apr/apr-1.5.2.tar.gz
wget $(apache_mirror)/apr/apr-util-1.5.4.tar.gz
wget $(php_mirror)distributions/php-7.1.0.tar.gz
tar -zxvf httpd-7.1.0.tar.gz
mv httpd-7.1.0.tar.gz httpd
tar -zxvf apr-1.5.2.tar.gz -C httpd/srclib
mv httpd/srclib/apr-1.5.2 httpd/srclib/apr
tar -zxvf apr-util-1.5.4.tar.gz -C httpd/srclib
mv httpd/srclib/apr-1.5.4 httpd/srclib/apr-util

# compile apache
cd httpd
./configure --prefix=/www \
  --enable-module=so \
  --enable-ssl \
  --enable-cgi \
  --enable-rewrite \
  --with-zlib \
  --with-pcre \
  --enable-modules=most \
  --enable-mpms-shared=all \
  --with-mpm=prefork
make && make install

cd ..
tar -zxvf php-7.1.0.tar.gz
# compile php
cd php-7.1.0

./configure --prefix=/usr/local/php7 \
 --with-curl \
 --with-freetype-dir \
 --with-gd \
 --with-gettext \
 --with-iconv-dir \
 --with-kerberos \
 --with-libdir=lib64 \
 --with-libxml-dir \
 --with-mysqli \
 --with-mysql \
 --with-openssl \
 --with-pcre-regex \
 --with-pdo-mysql \
 --with-pdo-sqlite \
 --with-pear \
 --with-png-dir \
 --with-xmlrpc \
 --with-xsl \
 --with-zlib \
 --with-apxs2=/www/bin/apxs \
 --enable-fpm \
 --enable-bcmath \
 --enable-libxml \
 --enable-inline-optimization \
 --enable-gd-native-ttf \
 --enable-mbregex \
 --enable-mbstring \
 --enable-opcache \
 --enable-pcntl \
 --enable-shmop \
 --enable-soap \
 --enable-sockets \
 --enable-sysvsem \
 --enable-xml \
 --enable-zip \
 --enable-mysqlnd
make && make install

cp php.ini-development /usr/local/lib/php.ini
ln -s /usr/local/php7/bin/php /bin/php

# config apache
sed -i '/^#*ServerName/c\ServerName 127.0.0.1:80' /www/conf/httpd.conf
sed -i '/^\s*DirectoryIndex/c\    DirectoryIndex index.php' /www/conf/httpd.conf
sed -i '/<IfModule mime_module>/a\    AddType application/x-httpd-php .php' /www/conf/httpd.conf
sed -i '/rewrite_module/{/#/d}' /www/conf/httpd.conf
sed -i '/^\s*AllowOverride/c\    AllowOverride All' /www/conf/httpd.conf
