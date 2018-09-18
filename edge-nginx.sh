set -e
yum install vim wget telnet gcc gcc-c++ openssl-devel gd-devel pcre-devel GeoIP-devel -y
cd /usr/src/
wget 'http://nginx.org/download/nginx-1.11.2.tar.gz'
tar -xzf nginx-1.11.2.tar.gz 
cd nginx-1.11.2/src/http/
wget https://github.com/simpl/ngx_devel_kit/archive/v0.3.0.tar.gz
wget https://github.com/openresty/lua-nginx-module/archive/v0.10.8.tar.gz
wget https://www.openssl.org/source/old/1.0.2/openssl-1.0.2h.tar.gz
tar -xzf v0.3.0.tar.gz
tar -xzf v0.10.8.tar.gz
tar -xzf openssl-1.0.2h.tar.gz 
git clone https://github.com/FRiCKLE/ngx_cache_purge.git
cd /usr/src/
wget http://luajit.org/download/LuaJIT-2.0.4.tar.gz
tar -xzf LuaJIT-2.0.4.tar.gz
cd LuaJIT-2.0.4
make PREFIX=/usr/local/LuaJIT-2.0.4
make install PREFIX=/usr/local/LuaJIT-2.0.4
export LUAJIT_LIB=/usr/local/LuaJIT-2.0.4/lib
export LUAJIT_INC=/usr/local/LuaJIT-2.0.4/include/luajit-2.0
cd /usr/src/nginx-1.11.2
./configure --prefix=/usr/local/nginx-1.10.1 --with-debug --without-mail_pop3_module --without-mail_imap_module --without-mail_smtp_module --without-http_scgi_module --without-http_uwsgi_module --with-http_gzip_static_module --with-http_realip_module --with-http_ssl_module --with-http_sub_module --with-ipv6 --with-file-aio --with-http_secure_link_module --with-http_image_filter_module --with-http_flv_module --with-http_mp4_module --with-http_stub_status_module --add-module=src/http/ngx_cache_purge/ --pid-path=/usr/local/nginx-1.10.1/var/run/nginx.pid --conf-path=/usr/local/nginx-1.10.1/conf/nginx.conf --lock-path=/usr/local/nginx-1.10.1/var/lock/subsys/nginx --sbin-path=/usr/local/nginx-1.10.1/sbin/nginx --with-ld-opt=-Wl,-rpath,/usr/local/LuaJIT-2.0.4/lib --add-module=src/http/ngx_devel_kit-0.3.0 --add-module=src/http/lua-nginx-module-0.10.8 --with-http_v2_module --with-openssl=src/http/openssl-1.0.2h/ --with-http_geoip_module
make -j 4
make install
mkdir -p /usr/local/nginx-1.10.1/conf/sites-enabled/ /usr/local/nginx-1.10.1/var/lock/subsys/ /cdn_cache/
echo 'PATH=$PATH:/usr/local/nginx-1.10.1/sbin/' >> /etc/profile
source /etc/profile
# NGINX PURGE CONFIG ##
# proxy_cache_purge PURGE from 127.0.0.1 192.168.42.0/24 118.70.124.143/32 113.190.252.218/32 123.30.168.0/24 123.30.188.0/24 103.216.120.0/22 192.168.158.0/24;
# curl -I -XPURGE -H 'Host: 106335df9.vws.vegacdn.vn' 'http://103.216.122.43/ttHOnH9RfpBanow6Xeo3vA/1519943243/cliptv_vod_v2/_definst_/amlst:cmc/media1/0/0/0/229/117358.mp4:levels*a_7_6_5_4_3_2_1:template*multiaudio.xml/playlist.m3u8?user='
