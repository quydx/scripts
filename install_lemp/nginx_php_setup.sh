#!/bin/bash
set -e
function checkerr {
  if [ $? -eq 0 ];then 
    echo "$1 successful"
  else
    echo "$1 failed"
  fi
}

{ sudo yum check-update || sudo yum update -y
sudo yum groupinstall -y 'Development Tools' && sudo yum install -y vim
sudo yum install -y epel-release
sudo yum install -y perl perl-devel perl-ExtUtils-Embed libxslt libxslt-devel libxml2 libxml2-devel gd gd-devel GeoIP GeoIP-devel
} &> /dev/null
if [ ! -x /usr/bin/wget ]; then 
  sudo yum install wget -y 
fi

{
wget http://nginx.org/download/nginx-1.14.0.tar.gz -P ~ && tar zxvf ~/nginx-1.14.0.tar.gz -C ~
wget https://ftp.pcre.org/pub/pcre/pcre-8.40.tar.gz -P ~ && tar xzvf ~/pcre-8.40.tar.gz -C ~
wget https://www.zlib.net/zlib-1.2.11.tar.gz -P ~ && tar xzvf ~/zlib-1.2.11.tar.gz -C ~
wget https://www.openssl.org/source/openssl-1.1.0f.tar.gz -P ~ && tar xzvf ~/openssl-1.1.0f.tar.gz -C ~
} &> /dev/null
echo "Remove all *tar.gz"
rm -rf *.tar.gz
cd ~/nginx-1.14.0
sudo cp ~/nginx-1.14.0/man/nginx.8 /usr/share/man/man8
sudo gzip /usr/share/man/man8/nginx.8
echo "Build nginx"
./configure --prefix=/usr/local/nginx \
            --sbin-path=/usr/sbin/nginx \
            --modules-path=/usr/lib64/nginx/modules \
            --conf-path=/usr/local/nginx/nginx.conf \
            --error-log-path=/var/log/nginx/error.log \
            --pid-path=/var/run/nginx.pid \
            --lock-path=/var/run/nginx.lock \
            --user=nginx \
            --group=nginx \
            --build=CentOS \
            --builddir=nginx-1.14.0 \
            --with-select_module \
            --with-poll_module \
            --with-threads \
            --with-file-aio \
            --with-http_ssl_module \
            --with-http_v2_module \
            --with-http_realip_module \
            --with-http_addition_module \
            --with-http_xslt_module=dynamic \
            --with-http_image_filter_module=dynamic \
            --with-http_geoip_module=dynamic \
            --with-http_sub_module \
            --with-http_dav_module \
            --with-http_flv_module \
            --with-http_mp4_module \
            --with-http_gunzip_module \
            --with-http_gzip_static_module \
            --with-http_auth_request_module \
            --with-http_random_index_module \
            --with-http_secure_link_module \
            --with-http_degradation_module \
            --with-http_slice_module \
            --with-http_stub_status_module \
            --http-log-path=/var/log/nginx/access.log \
            --http-client-body-temp-path=/var/cache/nginx/client_temp \
            --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
            --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
            --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
            --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
            --with-mail=dynamic \
            --with-mail_ssl_module \
            --with-stream=dynamic \
            --with-stream_ssl_module \
            --with-stream_realip_module \
            --with-stream_geoip_module=dynamic \
            --with-stream_ssl_preread_module \
            --with-compat \
            --with-pcre=../pcre-8.40 \
            --with-pcre-jit \
            --with-zlib=../zlib-1.2.11 \
            --with-openssl=../openssl-1.1.0f \
            --with-openssl-opt=no-nextprotoneg \
            --with-debug
make 
sudo make install
sudo ln -s /usr/lib64/nginx/modules /etc/nginx/modules
if [ `id -u nginx 2>/dev/null || echo -1` -ge 0 ];then 
  userdel -r nginx
fi 
sudo useradd --system --home /var/cache/nginx --shell /sbin/nologin --comment "nginx user" --user-group nginx
sudo mkdir -p /var/cache/nginx && sudo nginx -t

cd -
cp nginx.service /usr/lib/systemd/system/nginx.service
sudo systemctl start nginx.service && sudo systemctl enable nginx.service

mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
cp nginx.conf /etc/nginx/nginx.conf

wget http://rpms.remirepo.net/enterprise/remi-release-7.rpm -P ~
rpm -Uvh ~/remi-release-7.rpm
yum install yum-utils -y
yum-config-manager --enable remi-php71
yum --enablerepo=remi,remi-php71 install php-fpm php-common -y
yum --enablerepo=remi,remi-php71 install php-opcache php-pecl-apcu php-cli php-pear php-pdo php-mysqlnd php-pgsql \
 php-pecl-mongodb php-pecl-redis php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml -y

mv /etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf.bak
cp www.conf /etc/php-fpm.d/www.conf

systemctl start php-fpm.service
systemctl enable php-fpm.service

touch /etc/nginx/html/index.php
echo "<?php echo 'welcome, nginx-vtg-2;'?>" >> /etc/nginx/html/index.php
systemctl restart nginx
echo "setup done !!"

